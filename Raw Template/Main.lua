-- MEOW HUB | Main.lua
local ctx = _G.MeowCtx
if not ctx then warn("[Main.lua] ctx NIL!"); return end

local Players      = game:GetService("Players")
local LocalPlayer  = Players.LocalPlayer
local Theme        = ctx.Theme
local Tween        = ctx.Tween
local New          = ctx.New
local Corner       = ctx.Corner
local Stroke       = ctx.Stroke
local PageMain     = ctx.Pages.Main_Tokyo

-- Icons (utf8.char - aman dari obfuscator)
local IC_COIN    = utf8.char(129689)  -- 馃獧
local IC_REJOIN  = utf8.char(128260)  -- 馃攧
local IC_CHECK   = utf8.char(9989)    -- 鉁�
local IC_WAIT    = "..."
local IC_OK      = "OK"
local IC_ERR     = "X"

local function RunCollectCoins()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp  = char:WaitForChild("HumanoidRootPart")
    for _, coin in pairs(workspace.Coins:GetChildren()) do
        if coin:IsA("BasePart") then
            firetouchinterest(hrp, coin, 0)
            firetouchinterest(hrp, coin, 1)
            task.wait()
        end
    end
end

local autoExecuteAfterRejoin = false
local AUTOEXEC_FILE = "autoexec/MeowHub_AnimeTokyo.lua"
local function SaveAutoExec(src)
    pcall(function() if not isfolder("autoexec") then makefolder("autoexec") end end)
    return pcall(writefile, AUTOEXEC_FILE, src or "")
end
local function DeleteAutoExec()
    pcall(function() if isfile(AUTOEXEC_FILE) then delfile(AUTOEXEC_FILE) end end)
end

-- 鈺愨晲 SECTION: AUTO FARM 鈺愨晲
New("TextLabel", {
    Text = "AUTO FARM", Size = UDim2.new(1,-16,0,12),
    Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1,
    TextColor3 = Theme.AccentDim, TextSize = 9, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
}, PageMain)
New("Frame", {
    Size = UDim2.new(1,-16,0,1), Position = UDim2.new(0,8,0,22),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 11,
}, PageMain)

local CollectBtn = New("TextButton", {
    Text = IC_COIN .. "  Auto Collect Coin",
    Size = UDim2.new(1,-16,0,34), Position = UDim2.new(0,8,0,30),
    BackgroundColor3 = Color3.fromRGB(0,38,28), BackgroundTransparency = 0.1,
    TextColor3 = Theme.Accent, TextSize = 11, Font = Enum.Font.GothamBold,
    BorderSizePixel = 0, ZIndex = 12, AutoButtonColor = false,
}, PageMain)
Corner(CollectBtn, 7)
local CollectStroke = New("UIStroke", {
    Color = Theme.Accent, Thickness = 1,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, CollectBtn)

local CollectStatus = New("TextLabel", {
    Text = "Klik untuk mengumpulkan semua coin",
    Size = UDim2.new(1,-16,0,12), Position = UDim2.new(0,8,0,68),
    BackgroundTransparency = 1, TextColor3 = Theme.TextDim,
    TextSize = 9, Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
}, PageMain)

task.spawn(function()
    while true do
        Tween(CollectStroke,{Color=Theme.Accent},    0.9, Enum.EasingStyle.Sine)
        task.wait(0.9)
        Tween(CollectStroke,{Color=Theme.AccentDim}, 0.9, Enum.EasingStyle.Sine)
        task.wait(0.9)
    end
end)

CollectBtn.MouseButton1Click:Connect(function()
    CollectStatus.Text = IC_WAIT .. " Mengumpulkan coin..."
    Tween(CollectStatus,{TextColor3=Theme.Accent})
    Tween(CollectBtn,{BackgroundColor3=Color3.fromRGB(0,22,16)})
    task.spawn(function()
        local ok, err = pcall(RunCollectCoins)
        if ok then
            CollectStatus.Text = IC_OK .. "  Semua coin berhasil dikumpulkan!"
            Tween(CollectStatus,{TextColor3=Color3.fromRGB(0,220,130)})
        else
            CollectStatus.Text = IC_ERR .. "  " .. tostring(err):sub(1,32)
            Tween(CollectStatus,{TextColor3=Color3.fromRGB(255,80,80)})
        end
        task.delay(3, function()
            Tween(CollectBtn,{BackgroundColor3=Color3.fromRGB(0,38,28)})
            CollectStatus.Text = "Klik untuk mengumpulkan semua coin"
            Tween(CollectStatus,{TextColor3=Theme.TextDim})
        end)
    end)
end)
CollectBtn.MouseEnter:Connect(function() Tween(CollectBtn,{BackgroundTransparency=0}) end)
CollectBtn.MouseLeave:Connect(function() Tween(CollectBtn,{BackgroundTransparency=0.1}) end)

-- 鈺愨晲 SECTION: REJOIN 鈺愨晲
New("Frame", {
    Size=UDim2.new(1,-16,0,1), Position=UDim2.new(0,8,0,86),
    BackgroundColor3=Theme.Border, BorderSizePixel=0, ZIndex=11,
}, PageMain)
New("TextLabel", {
    Text="REJOIN", Size=UDim2.new(1,-16,0,12),
    Position=UDim2.new(0,8,0,91), BackgroundTransparency=1,
    TextColor3=Theme.AccentDim, TextSize=9, Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11,
}, PageMain)

local RejoinBtn = New("TextButton", {
    Text = IC_REJOIN .. "  Rejoin For Spawn Coin!",
    Size = UDim2.new(1,-16,0,34), Position = UDim2.new(0,8,0,106),
    BackgroundColor3 = Color3.fromRGB(30,18,0), BackgroundTransparency = 0.1,
    TextColor3 = Color3.fromRGB(255,200,0), TextSize = 11, Font = Enum.Font.GothamBold,
    BorderSizePixel = 0, ZIndex = 12, AutoButtonColor = false,
}, PageMain)
Corner(RejoinBtn, 7)
New("UIStroke",{Color=Color3.fromRGB(200,140,0),Thickness=1,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border},RejoinBtn)
RejoinBtn.MouseEnter:Connect(function() Tween(RejoinBtn,{BackgroundTransparency=0}) end)
RejoinBtn.MouseLeave:Connect(function() Tween(RejoinBtn,{BackgroundTransparency=0.1}) end)

-- Checkbox Auto Execute
local checkboxChecked = false
local CheckCard = New("Frame",{
    Size=UDim2.new(1,-16,0,28), Position=UDim2.new(0,8,0,146),
    BackgroundColor3=Theme.Card, BackgroundTransparency=0.4,
    BorderSizePixel=0, ZIndex=11,
}, PageMain)
Corner(CheckCard,6); Stroke(CheckCard,Theme.Border,1)

local CheckBox = New("TextButton",{
    Text="", Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,8,0.5,-8),
    BackgroundColor3=Color3.fromRGB(18,20,36), BorderSizePixel=0,
    ZIndex=13, AutoButtonColor=false,
}, CheckCard)
Corner(CheckBox,4); Stroke(CheckBox,Theme.AccentDim,1)

local CheckMark = New("TextLabel",{
    Text=utf8.char(10003), Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1, TextColor3=Theme.Accent, TextSize=11,
    Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Center,
    TextYAlignment=Enum.TextYAlignment.Center,
    Visible=false, ZIndex=14,
}, CheckBox)

New("TextLabel",{
    Text="Auto Execute After Rejoin",
    Size=UDim2.new(1,-34,1,0), Position=UDim2.new(0,30,0,0),
    BackgroundTransparency=1, TextColor3=Theme.TextMain,
    TextSize=10, Font=Enum.Font.GothamSemibold,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=12,
}, CheckCard)

local AutoExecStatus = New("TextLabel",{
    Text="", Size=UDim2.new(1,-16,0,12), Position=UDim2.new(0,8,0,178),
    BackgroundTransparency=1, TextColor3=Theme.TextDim,
    TextSize=9, Font=Enum.Font.Code,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11,
}, PageMain)

local function ToggleCheckbox()
    checkboxChecked = not checkboxChecked
    autoExecuteAfterRejoin = checkboxChecked
    CheckMark.Visible = checkboxChecked
    if checkboxChecked then
        Tween(CheckBox,{BackgroundColor3=Color3.fromRGB(0,34,26)})
        Tween(CheckCard,{BackgroundColor3=Color3.fromRGB(0,18,28),BackgroundTransparency=0.2})
    else
        Tween(CheckBox,{BackgroundColor3=Color3.fromRGB(18,20,36)})
        Tween(CheckCard,{BackgroundColor3=Theme.Card,BackgroundTransparency=0.4})
        AutoExecStatus.Text=""
    end
end
CheckBox.MouseButton1Click:Connect(ToggleCheckbox)
CheckCard.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then ToggleCheckbox() end
end)

RejoinBtn.MouseButton1Click:Connect(function()
    RejoinBtn.Text = IC_WAIT .. " Rejoining..."
    RejoinBtn.Active = false
    if autoExecuteAfterRejoin then
        local ok = SaveAutoExec("-- MeowHub autoexec")
        AutoExecStatus.Text = ok and (IC_OK.." Autoexec tersimpan!") or "! Gagal simpan"
        AutoExecStatus.TextColor3 = ok and Color3.fromRGB(0,220,130) or Color3.fromRGB(255,80,80)
    else DeleteAutoExec() end
    task.delay(0.8, function()
        local ok = pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end)
        if not ok then
            RejoinBtn.Text = IC_ERR .. "  Gagal Rejoin"
            task.delay(2, function()
                RejoinBtn.Text = IC_REJOIN .. "  Rejoin For Spawn Coin!"
                RejoinBtn.Active = true
            end)
        end
    end)
end)

print("[Main.lua] OK - children: "..#PageMain:GetChildren())
