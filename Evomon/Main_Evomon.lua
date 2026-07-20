-- ============================================================
--  EVOMON | Main_Evomon.lua
-- ============================================================

local ctx = _G.MeowCtx
if not ctx then warn("[Main_Evomon] ctx NIL!"); return end

local Theme    = ctx.Theme
local Tween    = ctx.Tween
local New      = ctx.New
local Corner   = ctx.Corner
local Stroke   = ctx.Stroke
local PageMain = ctx.Pages.Main

local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS          = game:GetService("ReplicatedStorage")

-- ============================================================
--  REMOTE SETUP
-- ============================================================
local BattleRemote, AutoBattleRemote, OperateRemote, LocationEvent, LotteryEvent

pcall(function()
    BattleRemote     = RS:WaitForChild("Remote"):WaitForChild("Battle"):WaitForChild("ReqEnterPetBattle")
    AutoBattleRemote = RS:WaitForChild("Remote"):WaitForChild("Battle"):WaitForChild("ReqAutoBattle")
    OperateRemote    = RS:WaitForChild("Remote"):WaitForChild("Battle"):WaitForChild("ReqOperateBattle")
    LocationEvent    = RS:WaitForChild("Remote"):WaitForChild("MoveableSystem"):WaitForChild("ResUpdateLocations")
    LotteryEvent     = RS:WaitForChild("Remote"):WaitForChild("ShinyPetLottery"):WaitForChild("ResShinyPetLotteryDataChanged")
end)

-- ============================================================
--  STATE
-- ============================================================
local creatureMap     = {}
local autoFarm        = false
local autoCatch       = false
local lastBattleTime  = 0
local battleDelay     = 1.5
local prismaticCount  = 0
local shinyCount      = 0
local PRISMATIC_LIMIT = 149
local EXPIRE_TIME     = 8

-- ============================================================
--  HELPERS
-- ============================================================
local function GetPlayerPos()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return hrp and hrp.Position or nil
end

local function ExistsInWS(name)
    return workspace:FindFirstChild(name) ~= nil
end

local function ExpireOld()
    local now = tick()
    for id, data in pairs(creatureMap) do
        if now - data.lastSeen > EXPIRE_TIME then
            creatureMap[id] = nil
        end
    end
end

local function GetNearest()
    ExpireOld()
    local pos = GetPlayerPos()
    if not pos then return nil, 0 end
    local bestId, bestDist = nil, math.huge
    for id, data in pairs(creatureMap) do
        local d = (pos - data.pos).Magnitude
        if d < bestDist then bestDist = d; bestId = id end
    end
    return bestId, bestDist
end

local function CountNearby()
    local pos = GetPlayerPos()
    local nearby, total = 0, 0
    for _, data in pairs(creatureMap) do
        total = total + 1
        if pos and (pos - data.pos).Magnitude <= 500 then
            nearby = nearby + 1
        end
    end
    return nearby, total
end

-- ============================================================
--  UI: SCROLLING FRAME
-- ============================================================
local MainScroll = New("ScrollingFrame", {
    Size                   = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    ScrollBarThickness     = 3,
    ScrollBarImageColor3   = Theme.Accent,
    CanvasSize             = UDim2.new(0,0,0,390),
    ScrollingDirection     = Enum.ScrollingDirection.Y,
    ZIndex                 = 10,
}, PageMain)

-- ============================================================
--  UI: STATUS SECTION
-- ============================================================
local StatusCard = New("Frame", {
    Size             = UDim2.new(1,-16,0,68),
    Position         = UDim2.new(0,8,0,8),
    BackgroundColor3 = Color3.fromRGB(10,16,30),
    BackgroundTransparency = 0.2,
    BorderSizePixel  = 0,
    ZIndex           = 11,
}, MainScroll)
Corner(StatusCard, 7)
Stroke(StatusCard, Theme.Border, 1)

local StatusLbl = New("TextLabel", {
    Text     = "Status: Menunggu...",
    Size     = UDim2.new(1,-12,0,16),
    Position = UDim2.new(0,6,0,6),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255,200,60),
    TextSize = 10, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, StatusCard)

local InfoLbl = New("TextLabel", {
    Text     = "Nearby: 0  |  Tracked: 0",
    Size     = UDim2.new(1,-12,0,14),
    Position = UDim2.new(0,6,0,26),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(140,140,180),
    TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, StatusCard)

local PetLbl = New("TextLabel", {
    Text     = "Prismatic: 0 / 149   Shiny: 0",
    Size     = UDim2.new(1,-12,0,14),
    Position = UDim2.new(0,6,0,44),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(180,120,255),
    TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, StatusCard)

local function SetStatus(msg, color)
    StatusLbl.Text = "Status: " .. msg
    StatusLbl.TextColor3 = color or Color3.fromRGB(120,200,120)
end

local function UpdateInfo()
    ExpireOld()
    local nearby, total = CountNearby()
    InfoLbl.Text = string.format("Nearby: %d  |  Tracked: %d", nearby, total)
end

local function UpdatePetInfo()
    local color = prismaticCount >= PRISMATIC_LIMIT
        and Color3.fromRGB(255,80,80)
        or Color3.fromRGB(180,120,255)
    PetLbl.TextColor3 = color
    PetLbl.Text = string.format("Prismatic: %d / %d   Shiny: %d",
        prismaticCount, PRISMATIC_LIMIT, shinyCount)
end

-- ============================================================
--  UI: DELAY INPUT
-- ============================================================
local DelayCard = New("Frame", {
    Size             = UDim2.new(1,-16,0,34),
    Position         = UDim2.new(0,8,0,84),
    BackgroundColor3 = Theme.Card,
    BackgroundTransparency = 0.3,
    BorderSizePixel  = 0,
    ZIndex           = 11,
}, MainScroll)
Corner(DelayCard, 7)
Stroke(DelayCard, Theme.Border, 1)

New("TextLabel", {
    Text     = "Delay per battle (detik):",
    Size     = UDim2.new(0.58,0,1,0),
    Position = UDim2.new(0,8,0,0),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextMain,
    TextSize = 10, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, DelayCard)

local DelayBox = New("TextBox", {
    Text             = "1.5",
    Size             = UDim2.new(0.3,0,0,24),
    Position         = UDim2.new(0.67,0,0.5,-12),
    BackgroundColor3 = Color3.fromRGB(12,18,36),
    TextColor3       = Color3.new(1,1,1),
    TextSize         = 12,
    Font             = Enum.Font.GothamBold,
    BorderSizePixel  = 0,
    ZIndex           = 13,
    TextXAlignment   = Enum.TextXAlignment.Center,
}, DelayCard)
Corner(DelayBox, 5)
Stroke(DelayBox, Theme.AccentDim, 1)

DelayBox.Changed:Connect(function(prop)
    if prop == "Text" then
        local val = tonumber(DelayBox.Text)
        if val then battleDelay = math.clamp(val, 0.1, 30) end
    end
end)

-- ============================================================
--  UI: AUTO FARM TOGGLE
-- ============================================================
local FarmCard = New("Frame", {
    Size             = UDim2.new(1,-16,0,48),
    Position         = UDim2.new(0,8,0,126),
    BackgroundColor3 = Theme.Card,
    BackgroundTransparency = 0.3,
    BorderSizePixel  = 0,
    ZIndex           = 11,
}, MainScroll)
Corner(FarmCard, 7)
local FarmStroke = New("UIStroke", {
    Color = Theme.Border, Thickness = 1,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, FarmCard)

New("TextLabel", {
    Text     = utf8.char(9876),
    Size     = UDim2.new(0,30,1,0),
    Position = UDim2.new(0,6,0,0),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextDim,
    TextSize = 18, Font = Enum.Font.Gotham,
    ZIndex = 12,
}, FarmCard)

New("TextLabel", {
    Text     = "Auto Farm",
    Size     = UDim2.new(1,-90,0,20),
    Position = UDim2.new(0,40,0,4),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextMain,
    TextSize = 12, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, FarmCard)

New("TextLabel", {
    Text     = "Lawan creature otomatis",
    Size     = UDim2.new(1,-90,0,16),
    Position = UDim2.new(0,40,0,26),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextDim,
    TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, FarmCard)

local FarmBtn = New("TextButton", {
    Text     = "OFF",
    Size     = UDim2.new(0,44,0,22),
    Position = UDim2.new(1,-50,0.5,-11),
    BackgroundColor3 = Color3.fromRGB(30,16,20),
    TextColor3 = Color3.fromRGB(180,60,80),
    TextSize = 10, Font = Enum.Font.GothamBold,
    BorderSizePixel = 0, ZIndex = 13, AutoButtonColor = false,
}, FarmCard)
Corner(FarmBtn, 11)
Stroke(FarmBtn, Color3.fromRGB(80,20,30), 1)

-- ============================================================
--  UI: AUTO CATCH TOGGLE
-- ============================================================
local CatchCard = New("Frame", {
    Size             = UDim2.new(1,-16,0,48),
    Position         = UDim2.new(0,8,0,182),
    BackgroundColor3 = Theme.Card,
    BackgroundTransparency = 0.3,
    BorderSizePixel  = 0,
    ZIndex           = 11,
}, MainScroll)
Corner(CatchCard, 7)
local CatchStroke = New("UIStroke", {
    Color = Theme.Border, Thickness = 1,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, CatchCard)

New("TextLabel", {
    Text     = utf8.char(128056),
    Size     = UDim2.new(0,30,1,0),
    Position = UDim2.new(0,6,0,0),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextDim,
    TextSize = 18, Font = Enum.Font.Gotham,
    ZIndex = 12,
}, CatchCard)

New("TextLabel", {
    Text     = "Auto Catch",
    Size     = UDim2.new(1,-90,0,20),
    Position = UDim2.new(0,40,0,4),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextMain,
    TextSize = 12, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, CatchCard)

New("TextLabel", {
    Text     = "Auto off saat Prismatic >= 149",
    Size     = UDim2.new(1,-90,0,16),
    Position = UDim2.new(0,40,0,26),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextDim,
    TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, CatchCard)

local CatchBtn = New("TextButton", {
    Text     = "OFF",
    Size     = UDim2.new(0,44,0,22),
    Position = UDim2.new(1,-50,0.5,-11),
    BackgroundColor3 = Color3.fromRGB(30,16,20),
    TextColor3 = Color3.fromRGB(180,60,80),
    TextSize = 10, Font = Enum.Font.GothamBold,
    BorderSizePixel = 0, ZIndex = 13, AutoButtonColor = false,
}, CatchCard)
Corner(CatchBtn, 11)
Stroke(CatchBtn, Color3.fromRGB(80,20,30), 1)

-- ============================================================
--  UI: INFO CARD
-- ============================================================
local HintCard = New("Frame", {
    Size             = UDim2.new(1,-16,0,38),
    Position         = UDim2.new(0,8,0,238),
    BackgroundColor3 = Color3.fromRGB(8,16,10),
    BackgroundTransparency = 0.3,
    BorderSizePixel  = 0,
    ZIndex           = 11,
}, MainScroll)
Corner(HintCard, 7)
Stroke(HintCard, Color3.fromRGB(0,80,40), 1)

New("TextLabel", {
    Text     = utf8.char(9432) .. "  Auto Farm berjalan di background.\nGerakkan karakter untuk trigger update lokasi creature.",
    Size     = UDim2.new(1,-12,1,0),
    Position = UDim2.new(0,6,0,0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(100,200,120),
    TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextWrapped = true,
    ZIndex = 12,
}, HintCard)

-- ============================================================
--  TOGGLE LOGIC
-- ============================================================
local function SetFarmOn(state)
    autoFarm = state
    if state then
        FarmBtn.Text = "ON"
        Tween(FarmBtn,   {BackgroundColor3=Color3.fromRGB(0,34,26), TextColor3=Theme.Accent})
        Tween(FarmCard,  {BackgroundColor3=Color3.fromRGB(0,18,28), BackgroundTransparency=0.15})
        Tween(FarmStroke,{Color=Theme.Accent})
        SetStatus("Auto Farm ON", Color3.fromRGB(100,255,100))
    else
        FarmBtn.Text = "OFF"
        Tween(FarmBtn,   {BackgroundColor3=Color3.fromRGB(30,16,20), TextColor3=Color3.fromRGB(180,60,80)})
        Tween(FarmCard,  {BackgroundColor3=Theme.Card, BackgroundTransparency=0.3})
        Tween(FarmStroke,{Color=Theme.Border})
        SetStatus("Auto Farm OFF", Color3.fromRGB(200,100,100))
    end
end

local function SetCatchOn(state)
    autoCatch = state
    if state then
        CatchBtn.Text = "ON"
        Tween(CatchBtn,   {BackgroundColor3=Color3.fromRGB(36,18,0), TextColor3=Color3.fromRGB(255,160,60)})
        Tween(CatchCard,  {BackgroundColor3=Color3.fromRGB(28,14,0), BackgroundTransparency=0.15})
        Tween(CatchStroke,{Color=Color3.fromRGB(255,160,60)})
        SetStatus("Auto Catch ON", Color3.fromRGB(255,160,60))
    else
        CatchBtn.Text = "OFF"
        Tween(CatchBtn,   {BackgroundColor3=Color3.fromRGB(30,16,20), TextColor3=Color3.fromRGB(180,60,80)})
        Tween(CatchCard,  {BackgroundColor3=Theme.Card, BackgroundTransparency=0.3})
        Tween(CatchStroke,{Color=Theme.Border})
        SetStatus("Auto Catch OFF", Color3.fromRGB(200,100,100))
    end
end

FarmBtn.MouseButton1Click:Connect(function()  SetFarmOn(not autoFarm) end)
CatchBtn.MouseButton1Click:Connect(function() SetCatchOn(not autoCatch) end)

FarmBtn.MouseEnter:Connect(function()
    if not autoFarm then Tween(FarmBtn,{BackgroundColor3=Color3.fromRGB(45,20,26)}) end
end)
FarmBtn.MouseLeave:Connect(function()
    if not autoFarm then Tween(FarmBtn,{BackgroundColor3=Color3.fromRGB(30,16,20)}) end
end)
CatchBtn.MouseEnter:Connect(function()
    if not autoCatch then Tween(CatchBtn,{BackgroundColor3=Color3.fromRGB(45,20,26)}) end
end)
CatchBtn.MouseLeave:Connect(function()
    if not autoCatch then Tween(CatchBtn,{BackgroundColor3=Color3.fromRGB(30,16,20)}) end
end)

-- ============================================================
--  AUTO FARM LOOP
-- ============================================================
task.spawn(function()
    while true do
        task.wait(0.2)
        if not autoFarm then continue end

        local delay = battleDelay
        local now   = tick()
        if now - lastBattleTime < delay then continue end

        local id, dist = GetNearest()
        if not id then
            SetStatus("Menunggu creature...", Color3.fromRGB(255,200,60))
            continue
        end

        lastBattleTime = tick()
        creatureMap[id] = nil
        SetStatus(string.format("Enter battle -> %s (%.0f studs)", id, dist), Color3.fromRGB(100,220,255))
        pcall(function() BattleRemote:FireServer(id) end)
        UpdateInfo()

        -- Tunggu battle mulai
        SetStatus("Menunggu battle...", Color3.fromRGB(255,200,60))
        local battleStarted = false
        local t = 0
        while not battleStarted do
            if not autoFarm then break end
            if ExistsInWS("BGM_Battle1_1") or ExistsInWS("BGM_BattleNew1_1") then
                battleStarted = true
            end
            task.wait(0.1); t = t + 0.1
            if t >= 10 then break end
        end
        if not battleStarted then
            SetStatus("Timeout battle, cari lagi...", Color3.fromRGB(255,100,100))
            continue
        end

        -- Loop AutoBattle selama BGM battle
        SetStatus("Battle berlangsung...", Color3.fromRGB(80,200,255))
        while autoFarm and (ExistsInWS("BGM_Battle1_1") or ExistsInWS("BGM_BattleNew1_1")) do
            pcall(function() AutoBattleRemote:InvokeServer(true) end)
            task.wait(0.5)
        end
        if not autoFarm then continue end

        -- Tunggu fase akhir
        SetStatus("Menunggu fase akhir...", Color3.fromRGB(255,200,60))
        local t2 = 0
        local funnyStarted = false
        while not funnyStarted do
            if not autoFarm then break end
            if ExistsInWS("BGM_BattleFunny_1") then funnyStarted = true end
            task.wait(0.1); t2 = t2 + 0.1
            if t2 >= 10 then break end
        end
        if not funnyStarted then
            SetStatus("Timeout fase akhir...", Color3.fromRGB(255,100,100))
            continue
        end

        if autoCatch then
            SetStatus("Catching...", Color3.fromRGB(180,255,120))
            while autoFarm and autoCatch and ExistsInWS("BGM_BattleFunny_1") do
                pcall(function()
                    OperateRemote:InvokeServer({
                        sourcePos = 1, targetPos = 1,
                        actionType = 5, itemId = 2000015,
                    })
                end)
                task.wait(0.5)
            end
            if not autoCatch and ExistsInWS("BGM_BattleFunny_1") then
                SetStatus("Prismatic limit! Skip catch...", Color3.fromRGB(255,80,80))
                pcall(function() OperateRemote:InvokeServer({actionType=8}) end)
                task.wait(0.3)
            end
        else
            SetStatus("Skip catch...", Color3.fromRGB(255,180,60))
            pcall(function() OperateRemote:InvokeServer({actionType=8}) end)
            task.wait(0.3)
        end

        SetStatus("Cari creature berikutnya...", Color3.fromRGB(120,255,120))
    end
end)

-- Auto expire + update loop
task.spawn(function()
    while true do
        task.wait(3)
        ExpireOld()
        UpdateInfo()
    end
end)

-- ============================================================
--  HOOKS
-- ============================================================
if LocationEvent then
    LocationEvent.OnClientEvent:Connect(function(data)
        if type(data) ~= "table" then return end
        local now = tick()
        for id, pos in pairs(data) do
            if typeof(pos) == "Vector3" then
                creatureMap[tostring(id)] = {pos=pos, lastSeen=now}
            end
        end
        UpdateInfo()
    end)
end

if LotteryEvent then
    LotteryEvent.OnClientEvent:Connect(function(petType, itemId, amount)
        if type(amount) ~= "number" then return end
        if petType == 2 then
            prismaticCount = amount
        elseif petType == 1 then
            shinyCount = amount
        end
        UpdatePetInfo()
        if petType == 2 and autoCatch and amount >= PRISMATIC_LIMIT then
            SetCatchOn(false)
            SetStatus("Prismatic "..amount.."/"..PRISMATIC_LIMIT.." → Catch OFF!", Color3.fromRGB(255,80,80))
            warn("[Evomon] Prismatic limit! Auto Catch dimatikan.")
        end
    end)
end

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

SetStatus("Listening... gerakkan karakter", Color3.fromRGB(255,200,60))
print("[Main_Evomon] OK - children: " .. #PageMain:GetChildren())
