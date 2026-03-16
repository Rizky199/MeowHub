-- ╔══════════════════════════════════════════╗
-- ║         MEOW HUB | Utility.lua          ║
-- ║   Helpers • Toggle Cards • Section UI   ║
-- ╚══════════════════════════════════════════╝
-- Modul ini berisi:
--   • Helper umum: Tween, New, Corner, Stroke, MakeDraggable
--   • UI helper: MakeToggleCard, SectionLabel
--   • Logic gameplay: SetInfiniteJump, SetNoclip, SetEsp,
--                     ApplyWalkSpeed, TeleportToPlayer,
--                     CreateLight/RemoveLight,
--                     StartSpectate/StopSpectate

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ══════════════════════════════════
--  THEME (shared reference)
-- ══════════════════════════════════
local Theme = {
    Background = Color3.fromRGB(10, 15, 30),
    Header     = Color3.fromRGB(8, 12, 25),
    Sidebar    = Color3.fromRGB(8, 13, 26),
    Content    = Color3.fromRGB(12, 18, 34),
    Card       = Color3.fromRGB(14, 20, 40),
    Accent     = Color3.fromRGB(0, 229, 255),
    AccentDim  = Color3.fromRGB(0, 100, 130),
    TextMain   = Color3.fromRGB(200, 230, 255),
    TextDim    = Color3.fromRGB(70, 100, 130),
    Border     = Color3.fromRGB(0, 50, 70),
    CloseRed   = Color3.fromRGB(255, 45, 120),
    MinGold    = Color3.fromRGB(255, 200, 0),
    CatBg      = Color3.fromRGB(8, 14, 28),
}

-- ══════════════════════════════════
--  HELPER DASAR
-- ══════════════════════════════════

--- Tween singkat
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

--- Buat Instance dengan props sekaligus
local function New(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

--- Tambahkan UICorner ke parent
local function Corner(p, r)
    New("UICorner", { CornerRadius = UDim.new(0, r or 8) }, p)
end

--- Tambahkan UIStroke ke parent
local function Stroke(p, c, t)
    New("UIStroke", {
        Color           = c or Theme.Border,
        Thickness       = t or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, p)
end

--- Buat frame/button bisa di-drag
local function MakeDraggable(handle, target)
    local drag, ds, sp = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; ds = i.Position; sp = target.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
                  or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            target.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X,
                                        sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
end

-- ══════════════════════════════════
--  UI BUILDER: TOGGLE CARD
--  Dipakai oleh Main, Utility, Setting
-- ══════════════════════════════════

--- Buat kartu toggle ON/OFF generik
--- @param parent  Frame/ScrollingFrame tujuan
--- @param yPos    Posisi Y dalam pixel
--- @param icon    Emoji/teks ikon
--- @param label   Teks nama fitur
--- @param onToggle function(state:boolean)
local function MakeToggleCard(parent, yPos, icon, label, onToggle)
    local card = New("Frame", {
        Size             = UDim2.new(1, -16, 0, 38),
        Position         = UDim2.new(0, 8, 0, yPos),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.3,
        BorderSizePixel  = 0, ZIndex = 11,
    }, parent)
    Corner(card, 7)
    local cStroke = New("UIStroke", {
        Color = Theme.Border, Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, card)

    New("TextLabel", {
        Text = icon, Size = UDim2.new(0, 26, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextDim,
        TextSize = 14, Font = Enum.Font.Gotham, ZIndex = 12,
    }, card)

    New("TextLabel", {
        Text = label,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 34, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextMain,
        TextSize = 11, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
    }, card)

    local btn = New("TextButton", {
        Text = "OFF",
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -50, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(30, 16, 20),
        TextColor3 = Color3.fromRGB(180, 60, 80),
        TextSize = 10, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0, ZIndex = 13,
        AutoButtonColor = false,
    }, card)
    Corner(btn, 11)
    Stroke(btn, Color3.fromRGB(80, 20, 30), 1)

    local dot = New("Frame", {
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(0, 5, 0.5, -4),
        BackgroundColor3 = Color3.fromRGB(180, 60, 80),
        BorderSizePixel = 0, ZIndex = 14,
    }, btn)
    Corner(dot, 4)

    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        onToggle(isOn)
        if isOn then
            btn.Text = "ON"
            Tween(btn,     { BackgroundColor3 = Color3.fromRGB(0,34,26), TextColor3 = Theme.Accent })
            Tween(dot,     { BackgroundColor3 = Theme.Accent, Position = UDim2.new(1,-13,0.5,-4) })
            Tween(card,    { BackgroundColor3 = Color3.fromRGB(0,18,28), BackgroundTransparency = 0.15 })
            Tween(cStroke, { Color = Theme.Accent })
        else
            btn.Text = "OFF"
            Tween(btn,     { BackgroundColor3 = Color3.fromRGB(30,16,20), TextColor3 = Color3.fromRGB(180,60,80) })
            Tween(dot,     { BackgroundColor3 = Color3.fromRGB(180,60,80), Position = UDim2.new(0,5,0.5,-4) })
            Tween(card,    { BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.3 })
            Tween(cStroke, { Color = Theme.Border })
        end
    end)
    btn.MouseEnter:Connect(function()
        if not isOn then Tween(btn, { BackgroundColor3 = Color3.fromRGB(45,20,26) }) end
    end)
    btn.MouseLeave:Connect(function()
        if not isOn then Tween(btn, { BackgroundColor3 = Color3.fromRGB(30,16,20) }) end
    end)
    return card
end

-- ══════════════════════════════════
--  UI BUILDER: SECTION LABEL
-- ══════════════════════════════════

--- Buat judul seksi + garis divider
--- @param parent Frame/ScrollingFrame tujuan
--- @param yPos   Posisi Y
--- @param text   Teks judul seksi
local function SectionLabel(parent, yPos, text)
    New("TextLabel", {
        Text = text,
        Size = UDim2.new(1,-16,0,12),
        Position = UDim2.new(0,8,0,yPos),
        BackgroundTransparency = 1,
        TextColor3 = Theme.AccentDim,
        TextSize = 9, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
    }, parent)
    New("Frame", {
        Size = UDim2.new(1,-16,0,1),
        Position = UDim2.new(0,8,0,yPos+14),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0, ZIndex = 11,
    }, parent)
end

-- ══════════════════════════════════
--  LOGIC: INFINITE JUMP
-- ══════════════════════════════════
local infiniteJumpEnabled = false
local jumpConn = nil

local function SetInfiniteJump(state)
    infiniteJumpEnabled = state
    if state then
        jumpConn = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if jumpConn then
            jumpConn:Disconnect()
            jumpConn = nil
        end
    end
end

-- reconnect setelah respawn
LocalPlayer.CharacterAdded:Connect(function()
    if infiniteJumpEnabled then
        task.wait(0.5)
        SetInfiniteJump(true)
    end
end)

-- ══════════════════════════════════
--  LOGIC: NOCLIP
-- ══════════════════════════════════
local noclipEnabled = false
local noclipConn    = nil

local function SetNoclip(state)
    noclipEnabled = state
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if noclipEnabled then
        task.wait(0.5)
        SetNoclip(true)
    end
end)

-- ══════════════════════════════════
--  LOGIC: ESP PLAYER
-- ══════════════════════════════════
local espEnabled = false
local espBoxes   = {}

local function RemoveEsp(player)
    if espBoxes[player] then
        for _, obj in ipairs(espBoxes[player]) do
            if obj and obj.Parent then obj:Destroy() end
        end
        espBoxes[player] = nil
    end
end

local function CreateEspForPlayer(player)
    if player == LocalPlayer then return end
    RemoveEsp(player)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local bb = Instance.new("BillboardGui")
    bb.Name         = "MeowESP"
    bb.Adornee      = root
    bb.Size         = UDim2.new(0, 100, 0, 40)
    bb.StudsOffset  = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop  = true
    bb.ResetOnSpawn = false
    bb.Parent       = game:GetService("CoreGui")

    local nameL = Instance.new("TextLabel")
    nameL.Size                   = UDim2.new(1, 0, 0.6, 0)
    nameL.BackgroundTransparency = 1
    nameL.TextColor3             = Color3.fromRGB(0, 229, 255)
    nameL.TextStrokeTransparency = 0.5
    nameL.TextStrokeColor3       = Color3.fromRGB(0,0,0)
    nameL.Text                   = player.Name
    nameL.TextSize               = 13
    nameL.Font                   = Enum.Font.GothamBold
    nameL.Parent                 = bb

    local distL = Instance.new("TextLabel")
    distL.Size                   = UDim2.new(1, 0, 0.4, 0)
    distL.Position               = UDim2.new(0, 0, 0.6, 0)
    distL.BackgroundTransparency = 1
    distL.TextColor3             = Color3.fromRGB(255, 215, 0)
    distL.TextStrokeTransparency = 0.5
    distL.TextStrokeColor3       = Color3.fromRGB(0,0,0)
    distL.Text                   = "? studs"
    distL.TextSize               = 10
    distL.Font                   = Enum.Font.Gotham
    distL.Parent                 = bb

    espBoxes[player] = { bb, nameL, distL }

    local distConn
    distConn = RunService.Heartbeat:Connect(function()
        if not espEnabled or not bb.Parent then
            distConn:Disconnect(); return
        end
        local myChar  = LocalPlayer.Character
        local myRoot  = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local theirRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if myRoot and theirRoot then
            distL.Text = math.floor((myRoot.Position - theirRoot.Position).Magnitude) .. " studs"
        end
    end)
end

local function EnableEsp()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            p.CharacterAdded:Connect(function()
                task.wait(0.5)
                if espEnabled then CreateEspForPlayer(p) end
            end)
            CreateEspForPlayer(p)
        end
    end
    Players.PlayerAdded:Connect(function(p)
        if espEnabled then
            p.CharacterAdded:Connect(function()
                task.wait(0.5)
                if espEnabled then CreateEspForPlayer(p) end
            end)
        end
    end)
    Players.PlayerRemoving:Connect(function(p) RemoveEsp(p) end)
end

local function DisableEsp()
    for player, _ in pairs(espBoxes) do RemoveEsp(player) end
end

local function SetEsp(state)
    espEnabled = state
    if state then EnableEsp() else DisableEsp() end
end

-- ══════════════════════════════════
--  LOGIC: WALKSPEED
-- ══════════════════════════════════
local DEFAULT_SPEED = 16
local currentSpeed  = DEFAULT_SPEED

local function ApplyWalkSpeed(speed)
    currentSpeed = speed
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speed end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = currentSpeed end
end)

-- ══════════════════════════════════
--  LOGIC: TELEPORT TO PLAYER
-- ══════════════════════════════════
local function TeleportToPlayer(target)
    if not target or target == LocalPlayer then return end
    local myChar  = LocalPlayer.Character
    local myRoot  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local theirChar = target.Character
    local theirRoot = theirChar and theirChar:FindFirstChild("HumanoidRootPart")
    if myRoot and theirRoot then
        myRoot.CFrame = theirRoot.CFrame + Vector3.new(2, 2, 0)
    end
end

-- ══════════════════════════════════
--  LOGIC: PLAYER LIGHT
-- ══════════════════════════════════
local lightObj = nil

local function RemoveLight()
    if lightObj and lightObj.Parent then lightObj:Destroy() end
    lightObj = nil
end

local function CreateLight(color, brightness, range)
    RemoveLight()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    lightObj           = Instance.new("PointLight")
    lightObj.Color     = color or Color3.new(1,1,1)
    lightObj.Brightness = brightness or 5
    lightObj.Range     = range or 20
    lightObj.Shadows   = true
    lightObj.Parent    = hrp
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if _G.MeowLightOn then
        CreateLight(Color3.new(1,1,1), 5, 20)
    end
end)

-- ══════════════════════════════════
--  LOGIC: SPECTATOR
-- ══════════════════════════════════
local spectating     = false
local spectateConn   = nil
local spectateTarget = nil
local specCam        = workspace.CurrentCamera

local function StopSpectate()
    spectating     = false
    spectateTarget = nil
    if spectateConn then spectateConn:Disconnect(); spectateConn = nil end
    specCam.CameraType = Enum.CameraType.Custom
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then specCam.CameraSubject = hum end
    end
end

local function StartSpectate(target)
    if not target or target == LocalPlayer then return end
    StopSpectate()
    spectating     = true
    spectateTarget = target
    specCam.CameraType = Enum.CameraType.Custom

    spectateConn = RunService.RenderStepped:Connect(function()
        if not spectating then return end
        local char = target.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            specCam.CameraSubject = char:FindFirstChildOfClass("Humanoid") or root
            specCam.CameraType    = Enum.CameraType.Custom
        end
    end)
end

-- ══════════════════════════════════
--  EXPORT
-- ══════════════════════════════════
return {
    -- Helpers
    Theme          = Theme,
    Tween          = Tween,
    New            = New,
    Corner         = Corner,
    Stroke         = Stroke,
    MakeDraggable  = MakeDraggable,
    -- UI Builder
    MakeToggleCard = MakeToggleCard,
    SectionLabel   = SectionLabel,
    -- Logic
    SetInfiniteJump  = SetInfiniteJump,
    SetNoclip        = SetNoclip,
    SetEsp           = SetEsp,
    ApplyWalkSpeed   = ApplyWalkSpeed,
    currentSpeed     = function() return currentSpeed end,
    DEFAULT_SPEED    = DEFAULT_SPEED,
    TeleportToPlayer = TeleportToPlayer,
    CreateLight      = CreateLight,
    RemoveLight      = RemoveLight,
    StartSpectate    = StartSpectate,
    StopSpectate     = StopSpectate,
}
