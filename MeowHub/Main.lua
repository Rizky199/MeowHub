-- ============================================================
--  MEOW HUB | Main.lua
--  Game Detector - cek GameId lalu load tab Main sesuai game
--  Tab Utility & Setting sudah diload oleh Loader (shared)
-- ============================================================

local ctx = _G.MeowCtx
if not ctx then warn("[Main.lua] ctx NIL!"); return end

local Theme    = ctx.Theme
local Tween    = ctx.Tween
local New      = ctx.New
local Corner   = ctx.Corner
local Stroke   = ctx.Stroke
local PageMain = ctx.Pages.Main

-- ============================================================
--  DAFTAR GAME SUPPORT
--  Tambah game baru di sini
-- ============================================================
local GameList = {
    [6764231380] = {
        name = "Anime Tokyo",
        base = "https://raw.githubusercontent.com/Rizky199/MeowHub/main/Tokyo/",
        file = "Tab_Main_Tokyo.lua",
    },
    [9043175850] = {
        name = "Bee Hive Kingdom",
        base = "https://raw.githubusercontent.com/Rizky199/MeowHub/main/Bee_Hive_Kingdom/",
        file = "Main_Bee.lua",
    },
    [9164570436] = {
        name = "Anime Monster Collect",
        base = "https://raw.githubusercontent.com/Rizky199/MeowHub/main/Anime_Monster_Collect/",
        file = "Main_Animo.lua",
    },
}

-- ============================================================
--  DETEKSI GAME
-- ============================================================
local ok, rawId     = pcall(function() return game.GameId end)
local currentGameId = (ok and rawId) or 0
local gameData      = GameList[currentGameId]

print("[Main.lua] GameId: " .. tostring(currentGameId))

-- ============================================================
--  UI: GAME TERDETEKSI
-- ============================================================
if gameData then

    print("[Main.lua] Game: " .. gameData.name)

    -- Info game
    New("TextLabel", {
        Text     = "Script  [ " .. gameData.name .. " ]  tersedia!",
        Size     = UDim2.new(1,-16,0,18),
        Position = UDim2.new(0,8,0,12),
        BackgroundTransparency = 1,
        TextColor3 = Theme.Accent,
        TextSize = 11, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, PageMain)

    New("TextLabel", {
        Text     = "Game terdeteksi  |  GameId: " .. tostring(currentGameId),
        Size     = UDim2.new(1,-16,0,12),
        Position = UDim2.new(0,8,0,32),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextDim,
        TextSize = 9, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, PageMain)

    New("Frame", {
        Size     = UDim2.new(1,-16,0,1),
        Position = UDim2.new(0,8,0,48),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0, ZIndex = 11,
    }, PageMain)

    -- Tombol START
    local scriptRunning = false
    local StartBtn = New("TextButton", {
        Text     = utf8.char(9654) .. "  Start " .. gameData.name,
        Size     = UDim2.new(1,-16,0,36),
        Position = UDim2.new(0,8,0,56),
        BackgroundColor3 = Color3.fromRGB(0,38,28),
        BackgroundTransparency = 0.1,
        TextColor3 = Theme.Accent,
        TextSize = 12, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0, ZIndex = 12,
        AutoButtonColor = false,
    }, PageMain)
    Corner(StartBtn, 7)
    local StartStroke = New("UIStroke", {
        Color = Theme.Accent, Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, StartBtn)

    local StartStatus = New("TextLabel", {
        Text     = "Klik untuk memuat script",
        Size     = UDim2.new(1,-16,0,12),
        Position = UDim2.new(0,8,0,96),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextDim,
        TextSize = 9, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, PageMain)

    -- Pulsing glow
    local glowing = true
    task.spawn(function()
        while glowing do
            Tween(StartStroke, {Color=Theme.Accent},    0.9, Enum.EasingStyle.Sine)
            task.wait(0.9)
            Tween(StartStroke, {Color=Theme.AccentDim}, 0.9, Enum.EasingStyle.Sine)
            task.wait(0.9)
        end
    end)

    -- Klik START → load Tab_Main game dari GitHub
    StartBtn.MouseButton1Click:Connect(function()
        if scriptRunning then return end
        scriptRunning = true
        glowing = false

        StartBtn.Text   = "... Memuat " .. gameData.name .. "..."
        StartBtn.Active = false
        Tween(StartBtn,    {BackgroundColor3=Color3.fromRGB(0,20,14), TextColor3=Color3.fromRGB(0,200,130)})
        Tween(StartStroke, {Color=Color3.fromRGB(0,200,130)})
        StartStatus.Text = "Mengunduh dari GitHub..."
        Tween(StartStatus, {TextColor3=Theme.Accent})

        task.spawn(function()
            -- Bersihkan info awal dari PageMain
            for _, child in ipairs(PageMain:GetChildren()) do
                child:Destroy()
            end

            -- Load tab game
            local loadOk, loadErr = pcall(function()
                loadstring(game:HttpGet(gameData.base .. gameData.file))()
            end)

            if loadOk then
                print("[Main.lua] " .. gameData.name .. " berhasil dimuat!")
            else
                warn("[Main.lua] Gagal: " .. tostring(loadErr))
                -- Tampilkan error di PageMain
                New("TextLabel", {
                    Text     = "Gagal memuat script!",
                    Size     = UDim2.new(1,-16,0,20),
                    Position = UDim2.new(0,8,0,12),
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(255,80,80),
                    TextSize = 11, Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11,
                }, PageMain)
                New("TextLabel", {
                    Text     = tostring(loadErr):sub(1,60),
                    Size     = UDim2.new(1,-16,0,30),
                    Position = UDim2.new(0,8,0,36),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.TextDim,
                    TextSize = 9, Font = Enum.Font.Code,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    ZIndex = 11,
                }, PageMain)
            end
        end)
    end)

    StartBtn.MouseEnter:Connect(function()
        if not scriptRunning then Tween(StartBtn, {BackgroundTransparency=0.0}) end
    end)
    StartBtn.MouseLeave:Connect(function()
        if not scriptRunning then Tween(StartBtn, {BackgroundTransparency=0.1}) end
    end)

-- ============================================================
--  UI: GAME TIDAK SUPPORT
-- ============================================================
else

    print("[Main.lua] Game tidak didukung")

    New("TextLabel", {
        Text     = "Game ini tidak didukung!",
        Size     = UDim2.new(1,-16,0,18),
        Position = UDim2.new(0,8,0,12),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255,80,80),
        TextSize = 11, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, PageMain)

    New("TextLabel", {
        Text     = "GameId: " .. tostring(currentGameId) .. "  |  Belum didukung",
        Size     = UDim2.new(1,-16,0,12),
        Position = UDim2.new(0,8,0,32),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextDim,
        TextSize = 9, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, PageMain)

    New("Frame", {
        Size     = UDim2.new(1,-16,0,1),
        Position = UDim2.new(0,8,0,48),
        BackgroundColor3 = Color3.fromRGB(255,80,80),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0, ZIndex = 11,
    }, PageMain)

    local NoBtn = New("TextButton", {
        Text     = "X  Tidak Tersedia",
        Size     = UDim2.new(1,-16,0,36),
        Position = UDim2.new(0,8,0,56),
        BackgroundColor3 = Color3.fromRGB(20,12,30),
        BackgroundTransparency = 0.1,
        TextColor3 = Color3.fromRGB(120,80,160),
        TextSize = 12, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0, ZIndex = 12,
        AutoButtonColor = false, Active = false,
    }, PageMain)
    Corner(NoBtn, 7)
    New("UIStroke", {
        Color = Color3.fromRGB(80,40,120), Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, NoBtn)

    New("TextLabel", {
        Text     = "404",
        Size     = UDim2.new(1,-16,0,50),
        Position = UDim2.new(0,8,0,100),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(60,30,90),
        TextSize = 44, Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 11,
    }, PageMain)

    New("TextLabel", {
        Text     = "Game tidak ada dalam daftar support",
        Size     = UDim2.new(1,-16,0,14),
        Position = UDim2.new(0,8,0,152),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextDim,
        TextSize = 9, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 11,
    }, PageMain)

end

print("[Main.lua] OK")
