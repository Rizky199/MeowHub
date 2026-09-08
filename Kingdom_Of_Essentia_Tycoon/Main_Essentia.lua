-- ============================================================
--  KINGDOM OF ESSENTIA TYCOON | Main_Essentia.lua
-- ============================================================

local ctx = _G.MeowCtx
if not ctx then warn("[Main_Essentia] ctx NIL!"); return end

local Theme    = ctx.Theme
local Tween    = ctx.Tween
local New      = ctx.New
local Corner   = ctx.Corner
local Stroke   = ctx.Stroke
local PageMain = ctx.Pages.Main

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer     = Players.LocalPlayer

-- ============================================================
--  REMOTE SETUP
-- ============================================================
local GemRemote = nil
pcall(function()
    GemRemote = ReplicatedStorage
        :WaitForChild("RemoteEvents")
        :WaitForChild("RemoteCollectGem")
end)

-- ============================================================
--  STATE
-- ============================================================
local gemActive      = false
local tycoonActive   = false
local proxActive     = false
local proxConns      = {}
local lastTargetRef  = nil
local lastTargetTime = 0
local lastTpTime     = 0

-- ============================================================
--  HELPERS: TYCOON TELEPORT
-- ============================================================
local function ResolveTycoonName(val)
    if not val then return nil end
    local t = typeof(val)
    if t == "string" and val ~= "" then return val end
    if t == "number" then return ("Tycoon%d"):format(val) end
    if t == "Instance" then return val.Name end
    return nil
end

local function GetTycoonModel()
    local td = LocalPlayer:FindFirstChild("TycoonData")
    if not td then return nil, nil end
    local tVal = td:FindFirstChild("Tycoon")
    if not tVal then return nil, nil end
    local name = ResolveTycoonName(tVal.Value)
    if not name then return nil, nil end
    return workspace:FindFirstChild(name), name
end

local function FirstBasePart(inst)
    if not inst then return nil end
    if inst:IsA("BasePart") then return inst end
    if inst:IsA("Model") then
        if inst.PrimaryPart then return inst.PrimaryPart end
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("BasePart") then return d end
        end
        return nil
    end
    local anc = inst:FindFirstAncestorOfClass("Model")
        or inst:FindFirstAncestorOfClass("BasePart")
    if anc then return FirstBasePart(anc) end
    if inst:IsA("Folder") then
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("BasePart") then return d end
        end
    end
    return nil
end

local function ComputeTpCFrame(target)
    local bp = FirstBasePart(target)
    if not bp then return nil end
    local base   = bp.CFrame
    local offset = base.LookVector * -2 + Vector3.new(0, 3, 0)
    local pos    = base.Position + offset
    local look   = Vector3.new(base.Position.X - pos.X, 0, base.Position.Z - pos.Z)
    if look.Magnitude < 0.05 then look = Vector3.new(0,0,-1) end
    return CFrame.lookAt(pos, pos + look, Vector3.new(0,1,0))
end

local function PivotTo(char, cf)
    if not char then return end
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        char:PivotTo(cf)
        if hrp then
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end)
end

local function GetNextTarget()
    local td  = LocalPlayer:FindFirstChild("TycoonData")
    local nav = td and td:FindFirstChild("NextAffordableButton")
    if not nav then return nil end
    local val = nav.Value
    if typeof(val) == "Instance" and val and val.Parent then
        return val
    end
    return nil
end

-- ============================================================
--  LOGIC: INSTANT PROXIMITY PROMPT
-- ============================================================
local function PatchProximityPrompts()
    for _, conn in ipairs(proxConns) do conn:Disconnect() end
    proxConns = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
        end
    end
    local conn = workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("ProximityPrompt") and proxActive then
            obj.HoldDuration = 0
        end
    end)
    table.insert(proxConns, conn)
end

local function StopProximityPatch()
    for _, conn in ipairs(proxConns) do conn:Disconnect() end
    proxConns = {}
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
    CanvasSize             = UDim2.new(0,0,0,420),
    ScrollingDirection     = Enum.ScrollingDirection.Y,
    ZIndex                 = 10,
}, PageMain)

-- ============================================================
--  HELPER: Buat Toggle Card
-- ============================================================
local function MakeCard(yPos, icon, title, subtitle, onToggle)
    local card = New("Frame", {
        Size             = UDim2.new(1,-16,0,50),
        Position         = UDim2.new(0,8,0,yPos),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.3,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, MainScroll)
    Corner(card, 7)
    local cardStroke = New("UIStroke", {
        Color = Theme.Border, Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, card)

    New("TextLabel", {
        Text = icon,
        Size = UDim2.new(0,30,1,0), Position = UDim2.new(0,6,0,0),
        BackgroundTransparency = 1, TextColor3 = Theme.TextDim,
        TextSize = 18, Font = Enum.Font.Gotham, ZIndex = 12,
    }, card)

    New("TextLabel", {
        Text = title,
        Size = UDim2.new(1,-90,0,22), Position = UDim2.new(0,40,0,5),
        BackgroundTransparency = 1, TextColor3 = Theme.TextMain,
        TextSize = 11, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
    }, card)

    New("TextLabel", {
        Text = subtitle,
        Size = UDim2.new(1,-90,0,16), Position = UDim2.new(0,40,0,28),
        BackgroundTransparency = 1, TextColor3 = Theme.TextDim,
        TextSize = 9, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
    }, card)

    local btn = New("TextButton", {
        Text = "OFF",
        Size = UDim2.new(0,44,0,22), Position = UDim2.new(1,-50,0.5,-11),
        BackgroundColor3 = Color3.fromRGB(30,16,20),
        TextColor3 = Color3.fromRGB(180,60,80),
        TextSize = 10, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0, ZIndex = 13, AutoButtonColor = false,
    }, card)
    Corner(btn, 11)
    Stroke(btn, Color3.fromRGB(80,20,30), 1)

    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        onToggle(isOn)
        if isOn then
            btn.Text = "ON"
            Tween(btn,       {BackgroundColor3=Color3.fromRGB(0,34,26), TextColor3=Theme.Accent})
            Tween(card,      {BackgroundColor3=Color3.fromRGB(0,18,28), BackgroundTransparency=0.15})
            Tween(cardStroke,{Color=Theme.Accent})
        else
            btn.Text = "OFF"
            Tween(btn,       {BackgroundColor3=Color3.fromRGB(30,16,20), TextColor3=Color3.fromRGB(180,60,80)})
            Tween(card,      {BackgroundColor3=Theme.Card, BackgroundTransparency=0.3})
            Tween(cardStroke,{Color=Theme.Border})
        end
    end)
    btn.MouseEnter:Connect(function()
        if not isOn then Tween(btn,{BackgroundColor3=Color3.fromRGB(45,20,26)}) end
    end)
    btn.MouseLeave:Connect(function()
        if not isOn then Tween(btn,{BackgroundColor3=Color3.fromRGB(30,16,20)}) end
    end)

    return card, btn
end

-- ============================================================
--  UI: SECTION GEM COLLECT
-- ============================================================
New("TextLabel", {
    Text = "GEM COLLECT",
    Size = UDim2.new(1,-16,0,12), Position = UDim2.new(0,8,0,8),
    BackgroundTransparency = 1, TextColor3 = Theme.AccentDim,
    TextSize = 9, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
}, MainScroll)
New("Frame", {
    Size = UDim2.new(1,-16,0,1), Position = UDim2.new(0,8,0,22),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 11,
}, MainScroll)

MakeCard(30, utf8.char(128142), "Auto Collect Gem", "FireServer setiap 0.1 detik",
    function(state)
        gemActive = state
    end
)

-- ============================================================
--  UI: SECTION TYCOON TELEPORT
-- ============================================================
New("Frame", {
    Size = UDim2.new(1,-16,0,1), Position = UDim2.new(0,8,0,90),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 11,
}, MainScroll)
New("TextLabel", {
    Text = "TYCOON AUTO BUY",
    Size = UDim2.new(1,-16,0,12), Position = UDim2.new(0,8,0,95),
    BackgroundTransparency = 1, TextColor3 = Theme.AccentDim,
    TextSize = 9, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
}, MainScroll)
New("Frame", {
    Size = UDim2.new(1,-16,0,1), Position = UDim2.new(0,8,0,109),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 11,
}, MainScroll)

MakeCard(117, utf8.char(127968), "Auto Teleport Buy", "Teleport ke button terjangkau berikutnya",
    function(state)
        tycoonActive = state
    end
)

-- ============================================================
--  UI: SECTION INSTANT PROXIMITY
-- ============================================================
New("Frame", {
    Size = UDim2.new(1,-16,0,1), Position = UDim2.new(0,8,0,177),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 11,
}, MainScroll)
New("TextLabel", {
    Text = "GAMEPLAY",
    Size = UDim2.new(1,-16,0,12), Position = UDim2.new(0,8,0,182),
    BackgroundTransparency = 1, TextColor3 = Theme.AccentDim,
    TextSize = 9, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
}, MainScroll)
New("Frame", {
    Size = UDim2.new(1,-16,0,1), Position = UDim2.new(0,8,0,196),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 11,
}, MainScroll)

MakeCard(204, utf8.char(128161), "Instant Proximity", "HoldDuration = 0 semua ProximityPrompt",
    function(state)
        proxActive = state
        if state then
            PatchProximityPrompts()
        else
            StopProximityPatch()
        end
    end
)

-- ============================================================
--  UI: STATUS CARD
-- ============================================================
local StatusCard = New("Frame", {
    Size             = UDim2.new(1,-16,0,56),
    Position         = UDim2.new(0,8,0,264),
    BackgroundColor3 = Color3.fromRGB(10,16,30),
    BackgroundTransparency = 0.2,
    BorderSizePixel  = 0,
    ZIndex           = 11,
}, MainScroll)
Corner(StatusCard, 7)
Stroke(StatusCard, Theme.Border, 1)

local TycoonLbl = New("TextLabel", {
    Text = "Tycoon: -",
    Size = UDim2.new(1,-12,0,14), Position = UDim2.new(0,6,0,6),
    BackgroundTransparency = 1, TextColor3 = Theme.TextDim,
    TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
}, StatusCard)

local TargetLbl = New("TextLabel", {
    Text = "Target: -",
    Size = UDim2.new(1,-12,0,14), Position = UDim2.new(0,6,0,22),
    BackgroundTransparency = 1, TextColor3 = Theme.TextDim,
    TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
}, StatusCard)

local StatusLbl = New("TextLabel", {
    Text = "Status: idle",
    Size = UDim2.new(1,-12,0,14), Position = UDim2.new(0,6,0,38),
    BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(120,200,120),
    TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
}, StatusCard)

-- ============================================================
--  UI: INFO CARD
-- ============================================================
New("TextLabel", {
    Text = utf8.char(9432) .. "  Pastikan karakter sudah masuk Tycoon sebelum aktifkan Auto Buy.",
    Size = UDim2.new(1,-16,0,30), Position = UDim2.new(0,8,0,330),
    BackgroundTransparency = 1, TextColor3 = Theme.TextDim,
    TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextWrapped = true, ZIndex = 11,
}, MainScroll)

-- ============================================================
--  LOOP: GEM COLLECT
-- ============================================================
task.spawn(function()
    while true do
        task.wait(0.1)
        if gemActive and GemRemote then
            pcall(function() GemRemote:FireServer() end)
        end
    end
end)

-- ============================================================
--  LOOP: TYCOON AUTO BUY
-- ============================================================
task.spawn(function()
    -- Hook NextAffordableButton
    local td  = LocalPlayer:WaitForChild("TycoonData", 10)
    local nav = td and td:FindFirstChild("NextAffordableButton")
    if nav and nav:IsA("ObjectValue") then
        nav:GetPropertyChangedSignal("Value"):Connect(function()
            lastTargetRef  = nav.Value
            lastTargetTime = os.clock()
        end)
        lastTargetRef  = nav.Value
        lastTargetTime = os.clock()
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        local _, name = GetTycoonModel()
        TycoonLbl.Text = "Tycoon: " .. (name or "-")
    end
end)

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if not tycoonActive then continue end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

        local target = GetNextTarget()
        TargetLbl.Text = "Target: " .. (target and target:GetFullName() or "-")

        if not target then
            StatusLbl.Text = "Status: menunggu target..."
            StatusLbl.TextColor3 = Color3.fromRGB(255,200,60)
            continue
        end

        local now = os.clock()
        local shouldTp = false

        if target ~= lastTargetRef then
            lastTargetRef  = target
            lastTargetTime = now
            shouldTp = true
        elseif (now - lastTpTime) >= 0.3 and (now - lastTargetTime) >= 0.3 then
            shouldTp = true
        end

        if shouldTp then
            local cf = ComputeTpCFrame(target)
            if cf then
                StatusLbl.Text = "Status: teleporting..."
                StatusLbl.TextColor3 = Color3.fromRGB(100,200,255)
                PivotTo(char, cf)
                lastTpTime = now
                StatusLbl.Text = "Status: teleported OK"
                StatusLbl.TextColor3 = Color3.fromRGB(100,255,100)
            else
                StatusLbl.Text = "Status: target no BasePart"
                StatusLbl.TextColor3 = Color3.fromRGB(255,80,80)
            end
        end
    end
end)

print("[Main_Essentia] OK - children: " .. #PageMain:GetChildren())
