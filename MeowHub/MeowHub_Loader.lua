-- ╔══════════════════════════════════════════╗
-- ║        MEOW HUB | Loader.lua            ║
-- ╚══════════════════════════════════════════╝

local BASE = "https://raw.githubusercontent.com/Rizky199/MeowHub/main/MeowHub/"

local function Load(file)
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(BASE .. file))()
    end)
    if not ok then
        warn("[MeowHub] GAGAL: " .. file .. " -> " .. tostring(result))
        return nil
    end
    print("[MeowHub] OK: " .. file)
    return result
end

-- Step 1 & 2
local guiModule  = Load("GUI.lua")
if not guiModule then return end
local utilModule = Load("Utility.lua")
if not utilModule then return end

local ctx = {
    Theme     = guiModule.Theme,
    Tween     = guiModule.Tween,
    New       = guiModule.New,
    Corner    = guiModule.Corner,
    Stroke    = guiModule.Stroke,
    Pages     = guiModule.Pages,
    Main      = guiModule.Main,
    Indicator = guiModule.Indicator,
    Sidebar   = guiModule.Sidebar,
    TAB_H     = guiModule.TAB_H,
    TAB_PAD   = guiModule.TAB_PAD,
    MakeToggleCard   = utilModule.MakeToggleCard,
    SectionLabel     = utilModule.SectionLabel,
    SetInfiniteJump  = utilModule.SetInfiniteJump,
    SetNoclip        = utilModule.SetNoclip,
    SetEsp           = utilModule.SetEsp,
    ApplyWalkSpeed   = utilModule.ApplyWalkSpeed,
    TeleportToPlayer = utilModule.TeleportToPlayer,
    CreateLight      = utilModule.CreateLight,
    RemoveLight      = utilModule.RemoveLight,
    StartSpectate    = utilModule.StartSpectate,
    StopSpectate     = utilModule.StopSpectate,
}

-- DEBUG: cek ukuran semua frame
local function DebugFrame(name, frame)
    if not frame then print("[DEBUG] "..name..": NIL!"); return end
    print("[DEBUG] "..name.." Size:"..tostring(frame.Size).." Visible:"..tostring(frame.Visible).." AbsSize:"..tostring(frame.AbsoluteSize))
end

task.wait(0.5) -- tunggu GUI render
DebugFrame("Main",          ctx.Main)
DebugFrame("Pages.Main",    ctx.Pages.Main)
DebugFrame("Pages.Utility", ctx.Pages.Utility)
DebugFrame("Pages.Setting", ctx.Pages.Setting)

-- Step 3: Load tabs
local function LoadTab(file)
    local ok, fn = pcall(loadstring, game:HttpGet(BASE .. file))
    if not ok then warn("[MeowHub] loadstring gagal "..file..": "..tostring(fn)); return end
    local ok2, err = pcall(fn, ctx)
    if not ok2 then warn("[MeowHub] eksekusi gagal "..file..": "..tostring(err)); return end
    print("[MeowHub] Tab OK: "..file)
end

LoadTab("Main.lua")
LoadTab("Utility_Page.lua")
LoadTab("Setting.lua")

-- DEBUG: cek child count setelah load
task.wait(0.3)
print("[DEBUG] Pages.Main children: "..#ctx.Pages.Main:GetChildren())
print("[DEBUG] Pages.Utility children: "..#ctx.Pages.Utility:GetChildren())
print("[DEBUG] Pages.Setting children: "..#ctx.Pages.Setting:GetChildren())

-- Step 4: Sidebar
local TweenService = game:GetService("TweenService")
local Theme     = ctx.Theme
local Indicator = ctx.Indicator
local Sidebar   = ctx.Sidebar
local Pages     = ctx.Pages
local TAB_H     = ctx.TAB_H
local TAB_PAD   = ctx.TAB_PAD

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

local TabList = {
    { label = "Main",    icon = "🏠", page = Pages.Main    },
    { label = "Utility", icon = "🔧", page = Pages.Utility },
    { label = "Setting", icon = "⚙️", page = Pages.Setting },
}

local ActiveBtn  = nil
local ActivePage = nil

local function SelectTab(btn, page, idx)
    if ActiveBtn and ActiveBtn ~= btn then
        Tween(ActiveBtn, { BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = 1 })
        for _, c in ipairs(ActiveBtn:GetChildren()) do
            if c:IsA("TextLabel") then Tween(c, { TextColor3 = Theme.TextDim }) end
        end
    end
    if ActivePage then ActivePage.Visible = false end
    ActiveBtn  = btn
    ActivePage = page
    page.Visible = true
    -- DEBUG
    print("[DEBUG] SelectTab: "..page.Name.." children:"..#page:GetChildren().." AbsSize:"..tostring(page.AbsoluteSize))
    Tween(btn, { BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.2 })
    for _, c in ipairs(btn:GetChildren()) do
        if c:IsA("TextLabel") then Tween(c, { TextColor3 = Theme.Accent }) end
    end
    local iy = TAB_PAD + idx * TAB_H + 4
    Tween(Indicator, { Position = UDim2.new(0, 0, 0, iy) }, 0.2, Enum.EasingStyle.Quad)
end

for i, def in ipairs(TabList) do
    local idx   = i - 1
    local slotY = TAB_PAD + idx * TAB_H
    local btn = New("TextButton", {
        Text = "", Size = UDim2.new(1,-6,0,TAB_H-4),
        Position = UDim2.new(0,3,0,slotY+2),
        BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = 1,
        BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 11,
    }, Sidebar)
    Corner(btn, 6)
    New("TextLabel", {
        Text = def.icon, Size = UDim2.new(1,0,0,22),
        Position = UDim2.new(0,0,0,4), BackgroundTransparency = 1,
        TextSize = 15, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextColor3 = Theme.TextDim, ZIndex = 12,
    }, btn)
    New("TextLabel", {
        Text = def.label, Size = UDim2.new(1,0,0,12),
        Position = UDim2.new(0,0,0,26), BackgroundTransparency = 1,
        TextColor3 = Theme.TextDim, TextSize = 9,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 12,
    }, btn)
    btn.MouseEnter:Connect(function()
        if ActiveBtn ~= btn then
            Tween(btn, {BackgroundColor3=Theme.Card,BackgroundTransparency=0.4})
            for _, c in ipairs(btn:GetChildren()) do
                if c:IsA("TextLabel") then Tween(c,{TextColor3=Theme.TextMain}) end
            end
        end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveBtn ~= btn then
            Tween(btn, {BackgroundColor3=Theme.Sidebar,BackgroundTransparency=1})
            for _, c in ipairs(btn:GetChildren()) do
                if c:IsA("TextLabel") then Tween(c,{TextColor3=Theme.TextDim}) end
            end
        end
    end)
    btn.MouseButton1Click:Connect(function()
        SelectTab(btn, def.page, idx)
    end)
    def.btn = btn
end

SelectTab(TabList[1].btn, TabList[1].page, 0)
print("[MeowHub] Selesai!")
