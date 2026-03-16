-- ===================================
-- --         MEOW HUB | GUI.lua              --
-- --   ScreenGui • Window • Header • Sidebar --
-- ===================================
-- Requires: Utility.lua (untuk Tween, New, Corner, Stroke, MakeDraggable)
-- Requires: Settings.lua (untuk Theme, konstanta ukuran)

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ----------------------------------
--  TRANSPARENCY SETTINGS
--  0 = solid penuh | 1 = tak terlihat
-- ----------------------------------
local BG_ALPHA      = 0.35
local HEADER_ALPHA  = 0.25
local SIDEBAR_ALPHA = 0.30
local CONTENT_ALPHA = 0.40

-- ----------------------------------
--  THEME
-- ----------------------------------
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

-- ----------------------------------
--  HELPERS
-- ----------------------------------
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function New(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function Corner(p, r)
    New("UICorner", { CornerRadius = UDim.new(0, r or 8) }, p)
end

local function Stroke(p, c, t)
    New("UIStroke", {
        Color           = c or Theme.Border,
        Thickness       = t or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, p)
end

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

-- ----------------------------------
--  UKURAN WINDOW
-- ----------------------------------
local WIN_W   = 320
local WIN_H   = 250
local HDR_H   = 34
local SIDE_W  = 65
local TAB_H   = 46
local TAB_PAD = 8

-- ----------------------------------
--  SCREENGUI
-- ----------------------------------
local Gui = New("ScreenGui", {
    Name           = "MeowHub",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder   = 999,
}, PlayerGui)

-- ----------------------------------
--  CAT ICON  (muncul saat minimize)
-- ----------------------------------
local CatBtn = New("TextButton", {
    Name             = "CatIcon",
    Text             = "",
    Size             = UDim2.new(0, 52, 0, 52),
    Position         = UDim2.new(0, 20, 1, -72),
    BackgroundColor3 = Theme.CatBg,
    BackgroundTransparency = 0.2,
    BorderSizePixel  = 0,
    Visible          = false,
    ZIndex           = 30,
    AutoButtonColor  = false,
    ClipsDescendants = false,
}, Gui)
Corner(CatBtn, 26)
Stroke(CatBtn, Theme.Accent, 2)

-- outer glow ring
New("ImageLabel", {
    AnchorPoint       = Vector2.new(0.5, 0.5),
    Size              = UDim2.new(1, 22, 1, 22),
    Position          = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 1,
    Image             = "rbxassetid://6014261993",
    ImageColor3       = Theme.Accent,
    ImageTransparency = 0.5,
    ScaleType         = Enum.ScaleType.Slice,
    SliceCenter       = Rect.new(49, 49, 450, 450),
    ZIndex            = 29,
}, CatBtn)

-- cat emoji di minimize button
New("TextLabel", {
    Text               = utf8.char(128049),
    Size               = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    TextSize           = 26,
    Font               = Enum.Font.Gotham,
    TextXAlignment     = Enum.TextXAlignment.Center,
    TextYAlignment     = Enum.TextYAlignment.Center,
    ZIndex             = 31,
}, CatBtn)

-- tooltip
local CatTip = New("TextLabel", {
    Text             = "Meow Hub",
    Size             = UDim2.new(0, 76, 0, 18),
    Position         = UDim2.new(0.5, -38, 1, 5),
    BackgroundColor3 = Theme.CatBg,
    BackgroundTransparency = 0.25,
    TextColor3       = Theme.Accent,
    TextSize         = 9,
    Font             = Enum.Font.GothamSemibold,
    Visible          = false,
    ZIndex           = 32,
}, CatBtn)
Corner(CatTip, 4)

CatBtn.MouseEnter:Connect(function()
    CatTip.Visible = true
    Tween(CatBtn, { BackgroundColor3 = Color3.fromRGB(16, 24, 46) })
end)
CatBtn.MouseLeave:Connect(function()
    CatTip.Visible = false
    Tween(CatBtn, { BackgroundColor3 = Theme.CatBg })
end)

MakeDraggable(CatBtn, CatBtn)

-- pulse saat minimize
local pulseRunning = false
local function StartPulse()
    if pulseRunning then return end
    pulseRunning = true
    task.spawn(function()
        while CatBtn.Visible do
            Tween(CatBtn, { Size = UDim2.new(0, 56, 0, 56) }, 0.55, Enum.EasingStyle.Sine)
            task.wait(0.55)
            Tween(CatBtn, { Size = UDim2.new(0, 52, 0, 52) }, 0.55, Enum.EasingStyle.Sine)
            task.wait(0.55)
        end
        pulseRunning = false
    end)
end

-- ----------------------------------
--  MAIN WINDOW
-- ----------------------------------
local Main = New("Frame", {
    Name                   = "Main",
    Size                   = UDim2.new(0, WIN_W, 0, 0),
    Position               = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    BackgroundColor3       = Theme.Background,
    BackgroundTransparency = BG_ALPHA,
    BorderSizePixel        = 0,
    ClipsDescendants       = false,
    ZIndex                 = 10,
}, Gui)
Corner(Main, 10)
Stroke(Main, Color3.fromRGB(0, 229, 255), 1)

-- Animasi masuk pakai transparency (bukan resize) agar konten tidak ter-clip
Main.Size = UDim2.new(0, WIN_W, 0, WIN_H)
Main.BackgroundTransparency = 1
task.defer(function()
    Tween(Main, { BackgroundTransparency = BG_ALPHA }, 0.35, Enum.EasingStyle.Quad)
end)

-- ----------------------------------
--  HEADER
-- ----------------------------------
local Header = New("Frame", {
    Size                   = UDim2.new(1, 0, 0, HDR_H),
    BackgroundColor3       = Theme.Header,
    BackgroundTransparency = HEADER_ALPHA,
    BorderSizePixel        = 0,
    ZIndex                 = 11,
}, Main)
Stroke(Header, Theme.Border, 1)

-- top cyan line
New("Frame", {
    Size                   = UDim2.new(1, 0, 0, 2),
    BackgroundColor3       = Theme.Accent,
    BackgroundTransparency = 0.2,
    BorderSizePixel        = 0,
    ZIndex                 = 12,
}, Header)

-- cat emoji di header
New("TextLabel", {
    Text = utf8.char(128049),
    Size = UDim2.new(0, 22, 1, 0),
    Position = UDim2.new(0, 7, 0, 0),
    BackgroundTransparency = 1,
    TextSize = 14, Font = Enum.Font.Gotham,
    ZIndex = 12,
}, Header)

-- title
New("TextLabel", {
    Text = "Meow Hub | Anime Tokyo | v0.0.1",
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 31, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1,1,1),
    TextSize = 10, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, Header)

-- hidden separator
New("TextLabel", {
    Text = "", Size = UDim2.new(0, 8, 1, 0),
    Position = UDim2.new(0, 115, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextDim, TextSize = 11,
    Font = Enum.Font.Gotham, ZIndex = 12,
}, Header)

-- version badge (tersembunyi)
local VBadge = New("TextLabel", {
    Text = "",
    Size = UDim2.new(0, 38, 0, 16),
    Position = UDim2.new(0, 126, 0.5, -8),
    BackgroundColor3 = Color3.fromRGB(0, 22, 36),
    BackgroundTransparency = 1,
    TextColor3 = Theme.Accent,
    TextSize = 9, Font = Enum.Font.Code, ZIndex = 12,
}, Header)
Corner(VBadge, 4)

-- -- Tombol Minimize --
local MinBtn = New("TextButton", {
    Text = "-",
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -46, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(22, 22, 32),
    BackgroundTransparency = 0.2,
    TextColor3 = Theme.TextDim,
    TextSize = 11, Font = Enum.Font.GothamBold,
    BorderSizePixel = 0, ZIndex = 12,
    AutoButtonColor = false,
}, Header)
Corner(MinBtn, 5)
Stroke(MinBtn, Color3.fromRGB(40, 40, 60), 1)
MinBtn.MouseEnter:Connect(function()
    Tween(MinBtn, { BackgroundColor3 = Color3.fromRGB(38,30,0), TextColor3 = Theme.MinGold })
end)
MinBtn.MouseLeave:Connect(function()
    Tween(MinBtn, { BackgroundColor3 = Color3.fromRGB(22,22,32), TextColor3 = Theme.TextDim })
end)

-- -- Tombol Close --
local CloseBtn = New("TextButton", {
    Text = "X",
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -23, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(22, 22, 32),
    BackgroundTransparency = 0.2,
    TextColor3 = Theme.TextDim,
    TextSize = 10, Font = Enum.Font.GothamBold,
    BorderSizePixel = 0, ZIndex = 12,
    AutoButtonColor = false,
}, Header)
Corner(CloseBtn, 5)
Stroke(CloseBtn, Color3.fromRGB(40, 40, 60), 1)
CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, { BackgroundColor3 = Color3.fromRGB(48,7,16), TextColor3 = Theme.CloseRed })
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, { BackgroundColor3 = Color3.fromRGB(22,22,32), TextColor3 = Theme.TextDim })
end)
CloseBtn.MouseButton1Click:Connect(function()
    Tween(Main, { BackgroundTransparency = 1 }, 0.25, Enum.EasingStyle.Quad)
    CatBtn.Visible = false
    task.delay(0.28, function() Gui:Destroy() end)
end)

-- ----------------------------------
--  MINIMIZE ↔ CAT LOGIC
-- ----------------------------------
local minimized = false

local function DoMinimize()
    if minimized then return end
    minimized = true

    local wx = Main.AbsolutePosition.X
    local wy = Main.AbsolutePosition.Y

    Tween(Main, { BackgroundTransparency = 1 }, 0.2, Enum.EasingStyle.Quad)
    task.delay(0.22, function()
        Main.Visible = false
        Main.BackgroundTransparency = BG_ALPHA

        local iconX = wx + WIN_W / 2 - 26
        local iconY = wy

        CatBtn.Size     = UDim2.new(0, 6, 0, 6)
        CatBtn.Position = UDim2.new(0, iconX + 23, 0, iconY + 23)
        CatBtn.Visible  = true

        Tween(CatBtn, {
            Size     = UDim2.new(0, 52, 0, 52),
            Position = UDim2.new(0, iconX, 0, iconY),
        }, 0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        StartPulse()
    end)
end

local function DoRestore()
    if not minimized then return end
    minimized = false

    local cx = CatBtn.AbsolutePosition.X
    local cy = CatBtn.AbsolutePosition.Y

    Tween(CatBtn, {
        Size     = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(0, cx + 23, 0, cy + 23),
    }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

    task.delay(0.18, function()
        CatBtn.Visible = false
        Main.Position = UDim2.new(0, cx - WIN_W/2 + 26, 0, cy)
        Main.BackgroundTransparency = 1
        Main.Visible = true
        Tween(Main, { BackgroundTransparency = BG_ALPHA }, 0.3, Enum.EasingStyle.Quad)
    end)
end

MinBtn.MouseButton1Click:Connect(DoMinimize)
CatBtn.MouseButton1Click:Connect(DoRestore)

-- ----------------------------------
--  BODY
-- ----------------------------------
local Body = New("Frame", {
    Size             = UDim2.new(1, 0, 0, WIN_H - HDR_H),
    Position         = UDim2.new(0, 0, 0, HDR_H),
    BackgroundTransparency = 1,
    BorderSizePixel  = 0,
    ClipsDescendants = false,
    ZIndex           = 10,
}, Main)

-- ----------------------------------
--  SIDEBAR
-- ----------------------------------
local Sidebar = New("Frame", {
    Size                   = UDim2.new(0, SIDE_W, 1, 0),
    BackgroundColor3       = Theme.Sidebar,
    BackgroundTransparency = SIDEBAR_ALPHA,
    BorderSizePixel        = 0,
    ZIndex                 = 10,
}, Body)

-- divider kanan sidebar
New("Frame", {
    Size             = UDim2.new(0, 1, 1, 0),
    Position         = UDim2.new(1, -1, 0, 0),
    BackgroundColor3 = Theme.Border,
    BorderSizePixel  = 0, ZIndex = 11,
}, Sidebar)

-- sliding indicator
local Indicator = New("Frame", {
    Size             = UDim2.new(0, 3, 0, TAB_H - 8),
    Position         = UDim2.new(0, 0, 0, TAB_PAD + 4),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel  = 0, ZIndex = 12,
}, Sidebar)
Corner(Indicator, 2)

-- ----------------------------------
--  CONTENT AREA
-- ----------------------------------
local Content = New("Frame", {
    Size                   = UDim2.new(1, -SIDE_W, 1, 0),
    Position               = UDim2.new(0, SIDE_W, 0, 0),
    BackgroundColor3       = Theme.Content,
    BackgroundTransparency = CONTENT_ALPHA,
    BorderSizePixel        = 0,
    ZIndex                 = 10,
}, Body)

-- ----------------------------------
--  PAGES
-- ----------------------------------
local function MakePage(name)
    return New("Frame", {
        Name = name, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Visible = false,
        BorderSizePixel = 0, ClipsDescendants = false, ZIndex = 10,
    }, Content)
end

local Pages = {
    Main_Tokyo = MakePage("Main_Tokyo"),
    Utility = MakePage("Utility"),
    Setting = MakePage("Setting"),
}

-- ----------------------------------
--  DRAG WINDOW VIA HEADER
-- ----------------------------------
MakeDraggable(Header, Main)

-- ----------------------------------
--  KEYBIND  RightShift = toggle
-- ----------------------------------
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if minimized then DoRestore() else DoMinimize() end
    end
end)

-- Export untuk dipakai modul lain
return {
    Gui       = Gui,
    Main      = Main,
    Header    = Header,
    Body      = Body,
    Sidebar   = Sidebar,
    Content   = Content,
    Pages     = Pages,
    Indicator = Indicator,
    Theme     = Theme,
    Tween     = Tween,
    New       = New,
    Corner    = Corner,
    Stroke    = Stroke,
    -- Konstanta
    WIN_W   = WIN_W,
    WIN_H   = WIN_H,
    HDR_H   = HDR_H,
    SIDE_W  = SIDE_W,
    TAB_H   = TAB_H,
    TAB_PAD = TAB_PAD,
}
