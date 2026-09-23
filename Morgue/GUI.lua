-- =====================
-- GUI.lua
-- Membuat seluruh interface (ScreenGui, MainFrame, dsb)
-- =====================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

_G.TVG = _G.TVG or {}
_G.TVG.GUI = {}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TaskViewerGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 175)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -87)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(90, 90, 200)
Stroke.Thickness = 1.5

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 34)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local Fix = Instance.new("Frame")
Fix.Size = UDim2.new(1, 0, 0.5, 0)
Fix.Position = UDim2.new(0, 0, 0.5, 0)
Fix.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
Fix.BorderSizePixel = 0
Fix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Task Viewer"
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 28, 0, 22)
MinBtn.Position = UDim2.new(1, -62, 0.5, -11)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
MinBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 28, 0, 22)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

-- Content Frame (Task)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 0, 82)
ContentFrame.Position = UDim2.new(0, 10, 0, 38)
ContentFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

local SubLabel = Instance.new("TextLabel")
SubLabel.Text = "TASK"
SubLabel.Size = UDim2.new(1, -12, 0, 16)
SubLabel.Position = UDim2.new(0, 10, 0, 6)
SubLabel.BackgroundTransparency = 1
SubLabel.TextColor3 = Color3.fromRGB(100, 100, 180)
SubLabel.TextSize = 10
SubLabel.Font = Enum.Font.GothamBold
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = ContentFrame

local TaskText = Instance.new("TextLabel")
TaskText.Text = "Memuat..."
TaskText.Size = UDim2.new(1, -20, 1, -28)
TaskText.Position = UDim2.new(0, 10, 0, 24)
TaskText.BackgroundTransparency = 1
TaskText.TextColor3 = Color3.fromRGB(240, 240, 255)
TaskText.TextSize = 13
TaskText.Font = Enum.Font.Gotham
TaskText.TextXAlignment = Enum.TextXAlignment.Left
TaskText.TextYAlignment = Enum.TextYAlignment.Top
TaskText.TextWrapped = true
TaskText.Parent = ContentFrame

-- Soul Frame
local SoulFrame = Instance.new("Frame")
SoulFrame.Size = UDim2.new(1, -20, 0, 46)
SoulFrame.Position = UDim2.new(0, 10, 0, 128)
SoulFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
SoulFrame.BorderSizePixel = 0
SoulFrame.Parent = MainFrame
Instance.new("UICorner", SoulFrame).CornerRadius = UDim.new(0, 8)

local SoulSubLabel = Instance.new("TextLabel")
SoulSubLabel.Text = "JUMPSCARE SOUL"
SoulSubLabel.Size = UDim2.new(1, -12, 0, 16)
SoulSubLabel.Position = UDim2.new(0, 10, 0, 5)
SoulSubLabel.BackgroundTransparency = 1
SoulSubLabel.TextColor3 = Color3.fromRGB(100, 100, 180)
SoulSubLabel.TextSize = 10
SoulSubLabel.Font = Enum.Font.GothamBold
SoulSubLabel.TextXAlignment = Enum.TextXAlignment.Left
SoulSubLabel.Parent = SoulFrame

local SoulStatus = Instance.new("TextLabel")
SoulStatus.Text = "Memeriksa..."
SoulStatus.Size = UDim2.new(1, -20, 0, 22)
SoulStatus.Position = UDim2.new(0, 10, 0, 20)
SoulStatus.BackgroundTransparency = 1
SoulStatus.TextColor3 = Color3.fromRGB(240, 240, 255)
SoulStatus.TextSize = 13
SoulStatus.Font = Enum.Font.GothamBold
SoulStatus.TextXAlignment = Enum.TextXAlignment.Left
SoulStatus.Parent = SoulFrame

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 10, 0, 10)
Dot.Position = UDim2.new(1, -20, 0.5, -5)
Dot.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
Dot.BorderSizePixel = 0
Dot.Parent = SoulStatus
Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

-- Simpan referensi supaya bisa dipakai file lain (Main.lua, Soul.lua)
_G.TVG.GUI.ScreenGui    = ScreenGui
_G.TVG.GUI.MainFrame    = MainFrame
_G.TVG.GUI.TaskText     = TaskText
_G.TVG.GUI.SoulStatus   = SoulStatus
_G.TVG.GUI.Dot          = Dot
_G.TVG.GUI.MinBtn       = MinBtn
_G.TVG.GUI.CloseBtn     = CloseBtn
_G.TVG.GUI.ContentFrame = ContentFrame
_G.TVG.GUI.SoulFrame    = SoulFrame

-- =====================
-- Minimize
-- =====================
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		ContentFrame.Visible = false
		SoulFrame.Visible = false
		MainFrame.Size = UDim2.new(0, 340, 0, 34)
		MinBtn.Text = "+"
	else
		ContentFrame.Visible = true
		SoulFrame.Visible = true
		MainFrame.Size = UDim2.new(0, 340, 0, 175)
		MinBtn.Text = "-"
	end
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Hover
CloseBtn.MouseEnter:Connect(function() CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 70) end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 60) end)
MinBtn.MouseEnter:Connect(function() MinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120) end)
MinBtn.MouseLeave:Connect(function() MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90) end)
