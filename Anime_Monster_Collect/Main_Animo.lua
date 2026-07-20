-- ============================================================
--  ANIME MONSTER COLLECT | Main_Animo.lua
-- ============================================================

local ctx = _G.MeowCtx
if not ctx then warn("[Main_Animo] ctx NIL!"); return end

local Theme    = ctx.Theme
local Tween    = ctx.Tween
local New      = ctx.New
local Corner   = ctx.Corner
local Stroke   = ctx.Stroke
local PageMain = ctx.Pages.Main

local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Icons
local IC_SPIRIT = utf8.char(128123)  -- hantu
local IC_SUN    = utf8.char(11088)   -- bintang
local IC_ALL    = utf8.char(9889)    -- petir

-- ============================================================
--  LOGIC: FREEZE MODEL
-- ============================================================
local function FreezeModel(model)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = true
            part.AssemblyLinearVelocity  = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

local function GetHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- Collect Yukibun
local function CollectYukibun()
    local folder = workspace:FindFirstChild("ActiveSpirits")
    if not folder then warn("[Animo] ActiveSpirits tidak ditemukan"); return end
    local hrp = GetHRP()
    local count = 0
    for _, v in ipairs(folder:GetDescendants()) do
        if v.Name == "YukibunFace" then
            local model = v:FindFirstAncestorOfClass("Model")
            if model then
                local root = model:FindFirstChild("HumanoidRootPart")
                    or model:FindFirstChildWhichIsA("BasePart")
                if root then
                    root.CFrame = hrp.CFrame
                    FreezeModel(model)
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- Collect Sunnybun
local function CollectSunnybun()
    local folder = workspace:FindFirstChild("ActiveSpirits")
    if not folder then warn("[Animo] ActiveSpirits tidak ditemukan"); return end
    local hrp = GetHRP()
    local count = 0
    for _, v in ipairs(folder:GetDescendants()) do
        if v.Name == "Sunnybun_Roaming" then
            local model = v:FindFirstAncestorOfClass("Model")
            if model then
                local root = model:FindFirstChild("HumanoidRootPart")
                    or model:FindFirstChildWhichIsA("BasePart")
                if root then
                    root.CFrame = hrp.CFrame
                    FreezeModel(model)
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- Collect ALL
local function CollectAll()
    local folder = workspace:FindFirstChild("ActiveSpirits")
    if not folder then warn("[Animo] ActiveSpirits tidak ditemukan"); return end
    local hrp = GetHRP()
    local count = 0
    for _, v in ipairs(folder:GetChildren()) do
        if v:IsA("Model") then
            local root = v:FindFirstChild("HumanoidRootPart")
                or v:FindFirstChildWhichIsA("BasePart")
            if root then
                root.CFrame = hrp.CFrame
                FreezeModel(v)
                count = count + 1
            end
        end
    end
    return count
end

-- ============================================================
--  HELPER: Buat tombol aksi (bukan toggle)
-- ============================================================
local function MakeActionBtn(parent, yPos, icon, label, color, onClick)
    local btn = New("TextButton", {
        Text = icon .. "  " .. label,
        Size = UDim2.new(1,-16,0,36),
        Position = UDim2.new(0,8,0,yPos),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.1,
        TextColor3 = Theme.Accent,
        TextSize = 11, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0, ZIndex = 12,
        AutoButtonColor = false,
    }, parent)
    Corner(btn, 7)
    local btnStroke = New("UIStroke", {
        Color = Theme.AccentDim, Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, btn)

    local status = New("TextLabel", {
        Text = "Klik untuk mengumpulkan",
        Size = UDim2.new(1,-16,0,12),
        Position = UDim2.new(0,8,0,yPos+40),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextDim,
        TextSize = 9, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, parent)

    btn.MouseButton1Click:Connect(function()
        status.Text = "... Memproses..."
        Tween(status, {TextColor3=Theme.Accent})
        Tween(btn, {BackgroundTransparency=0.0})
        task.spawn(function()
            local ok, result = pcall(onClick)
            if ok then
                local n = result or 0
                status.Text = "OK  Berhasil: " .. tostring(n) .. " spirit"
                Tween(status, {TextColor3=Color3.fromRGB(0,220,130)})
            else
                status.Text = "X  " .. tostring(result):sub(1,35)
                Tween(status, {TextColor3=Color3.fromRGB(255,80,80)})
            end
            task.delay(3, function()
                status.Text = "Klik untuk mengumpulkan"
                Tween(status, {TextColor3=Theme.TextDim})
                Tween(btn, {BackgroundTransparency=0.1})
            end)
        end)
    end)
    btn.MouseEnter:Connect(function() Tween(btn,{BackgroundTransparency=0.0}) end)
    btn.MouseLeave:Connect(function() Tween(btn,{BackgroundTransparency=0.1}) end)

    -- Pulsing glow
    task.spawn(function()
        while btn and btn.Parent do
            Tween(btnStroke,{Color=Theme.Accent},    0.9, Enum.EasingStyle.Sine)
            task.wait(0.9)
            Tween(btnStroke,{Color=Theme.AccentDim}, 0.9, Enum.EasingStyle.Sine)
            task.wait(0.9)
        end
    end)

    return btn, status
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
    CanvasSize             = UDim2.new(0,0,0,330),
    ScrollingDirection     = Enum.ScrollingDirection.Y,
    ZIndex                 = 10,
}, PageMain)

-- ============================================================
--  UI: SECTION SPIRIT COLLECTOR
-- ============================================================
New("TextLabel", {
    Text = "SPIRIT COLLECTOR",
    Size = UDim2.new(1,-16,0,12), Position = UDim2.new(0,8,0,8),
    BackgroundTransparency = 1, TextColor3 = Theme.AccentDim,
    TextSize = 9, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
}, MainScroll)
New("Frame", {
    Size = UDim2.new(1,-16,0,1), Position = UDim2.new(0,8,0,22),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 11,
}, MainScroll)

-- Tombol Yukibun
MakeActionBtn(
    MainScroll, 30,
    IC_SPIRIT, "Collect YukibunFace",
    Color3.fromRGB(18, 10, 36),
    CollectYukibun
)

-- Divider
New("Frame", {
    Size = UDim2.new(1,-16,0,1), Position = UDim2.new(0,8,0,90),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 11,
}, MainScroll)

-- Tombol Sunnybun
MakeActionBtn(
    MainScroll, 98,
    IC_SUN, "Collect Sunnybun",
    Color3.fromRGB(36, 28, 8),
    CollectSunnybun
)

-- Divider
New("Frame", {
    Size = UDim2.new(1,-16,0,1), Position = UDim2.new(0,8,0,158),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 11,
}, MainScroll)

-- Tombol ALL
MakeActionBtn(
    MainScroll, 166,
    IC_ALL, "Collect ALL Spirits",
    Color3.fromRGB(36, 10, 10),
    CollectAll
)

-- Info
New("TextLabel", {
    Text = "Semua spirit di ActiveSpirits akan ditarik ke player",
    Size = UDim2.new(1,-16,0,24), Position = UDim2.new(0,8,0,214),
    BackgroundTransparency = 1, TextColor3 = Theme.TextDim,
    TextSize = 9, Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextWrapped = true, ZIndex = 11,
}, MainScroll)

print("[Main_Animo] OK - children: " .. #PageMain:GetChildren())
