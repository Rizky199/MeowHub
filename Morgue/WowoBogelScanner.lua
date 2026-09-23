--// WowoBogel Scanner v6
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

pcall(function()
	local old = game:GetService("CoreGui"):FindFirstChild("WowoBogelScanner")
	if old then old:Destroy() end
end)

-- WalkSpeed 25
local function applyWalkSpeed()
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	hum.WalkSpeed = 25
end
applyWalkSpeed()
player.CharacterAdded:Connect(function() task.wait(1) applyWalkSpeed() end)

-- ========================
-- HELPER
-- ========================
local function getJumpscare()
	local story = workspace:FindFirstChild("Story")
	local trolley = story and story:FindFirstChild("ActiveTrolley")
	return trolley and trolley:FindFirstChild("Jumpscare")
end

local function getGenderuwoFolder()
	local jumpscare = getJumpscare()
	if not jumpscare then return nil end
	for _, obj in ipairs(jumpscare:GetChildren()) do
		if obj.Name:lower():find("^doctor") then return obj end
	end
	for _, obj in ipairs(jumpscare:GetDescendants()) do
		if obj.Name:lower():find("^doctor") then return obj end
	end
	return nil
end

local function findWowoBogel()
	local jumpscare = getJumpscare()
	if not jumpscare then return nil end
	for _, obj in ipairs(jumpscare:GetDescendants()) do
		if obj.Name == "WowoBogel" then return obj end
	end
	return nil
end

-- ========================
-- GOD MODE DOCTOR
-- ========================
local godDoctorEnabled = false
local godDoctorConn = nil

local function setGodDoctor(enabled)
	godDoctorEnabled = enabled
	if enabled then
		if godDoctorConn then godDoctorConn:Disconnect() end
		godDoctorConn = RunService.Heartbeat:Connect(function()
			local char = player.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
			local g = getGenderuwoFolder()
			if g then
				for _, v in ipairs(g:GetDescendants()) do
					if v:IsA("BasePart") then v.CanTouch = false end
				end
			end
		end)
	else
		if godDoctorConn then godDoctorConn:Disconnect() godDoctorConn = nil end
		local g = getGenderuwoFolder()
		if g then
			for _, v in ipairs(g:GetDescendants()) do
				if v:IsA("BasePart") then v.CanTouch = true end
			end
		end
	end
end

-- ========================
-- GOD MODE PATROL (auto aktif jika Patrol ada isinya)
-- ========================
local godPatrolEnabled = false
local godPatrolConn = nil

local function setGodPatrol(enabled)
	godPatrolEnabled = enabled
	if enabled then
		if godPatrolConn then godPatrolConn:Disconnect() end
		godPatrolConn = RunService.Heartbeat:Connect(function()
			local char = player.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
			local patrol = workspace:FindFirstChild("Patrol")
			if patrol then
				for _, v in ipairs(patrol:GetDescendants()) do
					if v:IsA("BasePart") then v.CanTouch = false end
				end
			end
		end)
	else
		if godPatrolConn then godPatrolConn:Disconnect() godPatrolConn = nil end
		local patrol = workspace:FindFirstChild("Patrol")
		if patrol then
			for _, v in ipairs(patrol:GetDescendants()) do
				if v:IsA("BasePart") then v.CanTouch = true end
			end
		end
	end
end

-- Alias untuk kompatibilitas host
local godModeEnabled = false
local function setGodMode(enabled)
	godModeEnabled = enabled
	setGodDoctor(enabled)
end

-- ========================
-- GOD MODE POCI
-- ========================
local function getPociFolder()
	local jumpscare = getJumpscare()
	if not jumpscare then return nil end
	for _, obj in ipairs(jumpscare:GetChildren()) do
		if obj.Name:lower():find("^poci") then return obj end
	end
	for _, obj in ipairs(jumpscare:GetDescendants()) do
		if obj.Name:lower():find("^poci") then return obj end
	end
	return nil
end

local godPociEnabled = false
local godPociConn = nil

local function setGodPoci(enabled)
	godPociEnabled = enabled
	if enabled then
		if godPociConn then godPociConn:Disconnect() end
		godPociConn = RunService.Heartbeat:Connect(function()
			local char = player.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
			local p = getPociFolder()
			if p then
				for _, v in ipairs(p:GetDescendants()) do
					if v:IsA("BasePart") then v.CanTouch = false end
				end
			end
		end)
	else
		if godPociConn then godPociConn:Disconnect() godPociConn = nil end
		local p = getPociFolder()
		if p then
			for _, v in ipairs(p:GetDescendants()) do
				if v:IsA("BasePart") then v.CanTouch = true end
			end
		end
	end
end

-- ========================
-- GOD MODE SUSTER
-- ========================
local function getSusterFolder()
	local jumpscare = getJumpscare()
	if not jumpscare then return nil end
	for _, obj in ipairs(jumpscare:GetChildren()) do
		if obj.Name:lower():find("^suster") then return obj end
	end
	for _, obj in ipairs(jumpscare:GetDescendants()) do
		if obj.Name:lower():find("^suster") then return obj end
	end
	return nil
end

local godSusterEnabled = false
local godSusterConn = nil

local function setGodSuster(enabled)
	godSusterEnabled = enabled
	if enabled then
		if godSusterConn then godSusterConn:Disconnect() end
		godSusterConn = RunService.Heartbeat:Connect(function()
			local char = player.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
			local s = getSusterFolder()
			if s then
				for _, v in ipairs(s:GetDescendants()) do
					if v:IsA("BasePart") then v.CanTouch = false end
				end
			end
		end)
	else
		if godSusterConn then godSusterConn:Disconnect() godSusterConn = nil end
		local s = getSusterFolder()
		if s then
			for _, v in ipairs(s:GetDescendants()) do
				if v:IsA("BasePart") then v.CanTouch = true end
			end
		end
	end
end

-- ========================
-- INSTANT PROXIMITY
-- ========================
local proxConns = {}
local proxActive = true

local function patchProximityPrompts()
	for _, c in ipairs(proxConns) do c:Disconnect() end
	proxConns = {}
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end
	end
	local conn = workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end
	end)
	table.insert(proxConns, conn)
end
patchProximityPrompts()

-- ========================
-- TELEPORT + FIRE PROXIMITY DI WOWOBOGEL
-- ========================
local function teleportAndClickWowo(wowo)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local targetCF = nil
	if wowo:IsA("BasePart") then
		targetCF = wowo.CFrame
	else
		local part = wowo:FindFirstChildWhichIsA("BasePart", true)
		if part then targetCF = part.CFrame end
	end

	if targetCF then
		root.CFrame = targetCF * CFrame.new(0, 0, 2)
		task.wait(0.2)
	end

	for _, obj in ipairs(wowo:GetDescendants()) do
		if obj:IsA("ProximityPrompt") then
			obj.HoldDuration = 0
			pcall(function() fireproximityprompt(obj) end)
		end
	end
	if wowo.Parent then
		for _, obj in ipairs(wowo.Parent:GetChildren()) do
			if obj:IsA("ProximityPrompt") then
				obj.HoldDuration = 0
				pcall(function() fireproximityprompt(obj) end)
			end
		end
	end
end

-- Teleport ke Genderuwo
local function teleportToGenderuwo()
	local g = getGenderuwoFolder()
	if not g then return end
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local targetCF = nil
	if g:IsA("BasePart") then
		targetCF = g.CFrame
	else
		local part = g:FindFirstChildWhichIsA("BasePart", true)
		if part then targetCF = part.CFrame end
	end

	if targetCF then
		root.CFrame = targetCF * CFrame.new(0, 0, 2)
	end
end

-- ========================
-- GUI
-- ========================
local GUI_HEIGHT = 254

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WowoBogelScanner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, GUI_HEIGHT)
Main.Position = UDim2.new(1, -275, 0, 60)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(70, 70, 110)
Stroke.Thickness = 1
Stroke.Parent = Main

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)
local TBFix = Instance.new("Frame")
TBFix.Size = UDim2.new(1, 0, 0, 10)
TBFix.Position = UDim2.new(0, 0, 1, -10)
TBFix.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TBFix.BorderSizePixel = 0
TBFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "WowoBogel Scanner"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 230)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 22, 0, 22)
Minimize.Position = UDim2.new(1, -52, 0, 5)
Minimize.BackgroundColor3 = Color3.fromRGB(180, 130, 20)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 11
Minimize.Parent = TitleBar
Instance.new("UICorner", Minimize)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 22, 0, 22)
Close.Position = UDim2.new(1, -26, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
Close.Text = "✕"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 11
Close.Parent = TitleBar
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function()
	for _, c in ipairs(proxConns) do c:Disconnect() end
	ScreenGui:Destroy()
end)

local minimized = false
local fullHeight = GUI_HEIGHT
Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		Main.Size = UDim2.new(0, 260, 0, 32)
		Minimize.Text = "+"
	else
		Main.Size = UDim2.new(0, 260, 0, fullHeight)
		Minimize.Text = "—"
	end
end)

-- Status WowoBogel
local WowoStatus = Instance.new("TextLabel")
WowoStatus.Size = UDim2.new(1, -16, 0, 22)
WowoStatus.Position = UDim2.new(0, 8, 0, 36)
WowoStatus.BackgroundTransparency = 1
WowoStatus.Font = Enum.Font.Gotham
WowoStatus.TextSize = 11
WowoStatus.Text = "● Scanning..."
WowoStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
WowoStatus.TextXAlignment = Enum.TextXAlignment.Left
WowoStatus.Parent = Main

-- Status Doctor
local GenderuwoStatus = Instance.new("TextLabel")
GenderuwoStatus.Size = UDim2.new(1, -16, 0, 18)
GenderuwoStatus.Position = UDim2.new(0, 8, 0, 57)
GenderuwoStatus.BackgroundTransparency = 1
GenderuwoStatus.Font = Enum.Font.Gotham
GenderuwoStatus.TextSize = 11
GenderuwoStatus.Text = "● Doctor: Tidak Ada"
GenderuwoStatus.TextColor3 = Color3.fromRGB(140, 140, 140)
GenderuwoStatus.TextXAlignment = Enum.TextXAlignment.Left
GenderuwoStatus.Parent = Main

-- Status Patrol
local PatrolStatus = Instance.new("TextLabel")
PatrolStatus.Size = UDim2.new(1, -16, 0, 18)
PatrolStatus.Position = UDim2.new(0, 8, 0, 73)
PatrolStatus.BackgroundTransparency = 1
PatrolStatus.Font = Enum.Font.Gotham
PatrolStatus.TextSize = 11
PatrolStatus.Text = "● Patrol: Kosong"
PatrolStatus.TextColor3 = Color3.fromRGB(140, 140, 140)
PatrolStatus.TextXAlignment = Enum.TextXAlignment.Left
PatrolStatus.Parent = Main

-- Status Poci
local PociStatus = Instance.new("TextLabel")
PociStatus.Size = UDim2.new(1, -16, 0, 18)
PociStatus.Position = UDim2.new(0, 8, 0, 89)
PociStatus.BackgroundTransparency = 1
PociStatus.Font = Enum.Font.Gotham
PociStatus.TextSize = 11
PociStatus.Text = "● Poci: Tidak Ada"
PociStatus.TextColor3 = Color3.fromRGB(140, 140, 140)
PociStatus.TextXAlignment = Enum.TextXAlignment.Left
PociStatus.Parent = Main

-- Status Suster
local SusterStatus = Instance.new("TextLabel")
SusterStatus.Size = UDim2.new(1, -16, 0, 18)
SusterStatus.Position = UDim2.new(0, 8, 0, 105)
SusterStatus.BackgroundTransparency = 1
SusterStatus.Font = Enum.Font.Gotham
SusterStatus.TextSize = 11
SusterStatus.Text = "● Suster: Tidak Ada"
SusterStatus.TextColor3 = Color3.fromRGB(140, 140, 140)
SusterStatus.TextXAlignment = Enum.TextXAlignment.Left
SusterStatus.Parent = Main

-- ========================
-- ROW 1: Doctor | Patrol | Prox
-- ROW 2: Poci | Suster
-- ========================
local rowY = 129

-- GOD DOCTOR pill
local GodPill = Instance.new("TextButton")
GodPill.Size = UDim2.new(0, 78, 0, 24)
GodPill.Position = UDim2.new(0, 8, 0, rowY)
GodPill.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
GodPill.Text = "Doctor: OFF"
GodPill.TextColor3 = Color3.new(1,1,1)
GodPill.Font = Enum.Font.GothamBold
GodPill.TextSize = 10
GodPill.Parent = Main
Instance.new("UICorner", GodPill).CornerRadius = UDim.new(0, 6)

-- GOD PATROL pill
local PatrolPill = Instance.new("TextButton")
PatrolPill.Size = UDim2.new(0, 78, 0, 24)
PatrolPill.Position = UDim2.new(0, 90, 0, rowY)
PatrolPill.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
PatrolPill.Text = "Patrol: OFF"
PatrolPill.TextColor3 = Color3.new(1,1,1)
PatrolPill.Font = Enum.Font.GothamBold
PatrolPill.TextSize = 10
PatrolPill.Parent = Main
Instance.new("UICorner", PatrolPill).CornerRadius = UDim.new(0, 6)

-- INSTANT PROXIMITY label
local ProxPill = Instance.new("Frame")
ProxPill.Size = UDim2.new(0, 76, 0, 24)
ProxPill.Position = UDim2.new(0, 172, 0, rowY)
ProxPill.BackgroundColor3 = Color3.fromRGB(25, 90, 40)
ProxPill.Parent = Main
Instance.new("UICorner", ProxPill).CornerRadius = UDim.new(0, 6)

local ProxLabel = Instance.new("TextLabel")
ProxLabel.Size = UDim2.new(1, 0, 1, 0)
ProxLabel.BackgroundTransparency = 1
ProxLabel.Text = "Prox: ON"
ProxLabel.TextColor3 = Color3.new(1,1,1)
ProxLabel.Font = Enum.Font.GothamBold
ProxLabel.TextSize = 10
ProxLabel.Parent = ProxPill

-- GOD POCI pill (row 2, kiri)
local PociPill = Instance.new("TextButton")
PociPill.Size = UDim2.new(0.5, -12, 0, 24)
PociPill.Position = UDim2.new(0, 8, 0, rowY + 28)
PociPill.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
PociPill.Text = "Poci: OFF"
PociPill.TextColor3 = Color3.new(1,1,1)
PociPill.Font = Enum.Font.GothamBold
PociPill.TextSize = 10
PociPill.Parent = Main
Instance.new("UICorner", PociPill).CornerRadius = UDim.new(0, 6)

-- GOD SUSTER pill (row 2, kanan)
local SusterPill = Instance.new("TextButton")
SusterPill.Size = UDim2.new(0.5, -12, 0, 24)
SusterPill.Position = UDim2.new(0.5, 4, 0, rowY + 28)
SusterPill.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
SusterPill.Text = "Suster: OFF"
SusterPill.TextColor3 = Color3.new(1,1,1)
SusterPill.Font = Enum.Font.GothamBold
SusterPill.TextSize = 10
SusterPill.Parent = Main
Instance.new("UICorner", SusterPill).CornerRadius = UDim.new(0, 6)

local function refreshGodPill()
	if godDoctorEnabled then
		GodPill.Text = "Doctor: ON"
		GodPill.BackgroundColor3 = Color3.fromRGB(20, 110, 50)
	else
		GodPill.Text = "Doctor: OFF"
		GodPill.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
	end
end

local function refreshPatrolPill()
	if godPatrolEnabled then
		PatrolPill.Text = "Patrol: ON"
		PatrolPill.BackgroundColor3 = Color3.fromRGB(20, 110, 50)
	else
		PatrolPill.Text = "Patrol: OFF"
		PatrolPill.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
	end
end

local function refreshPociPill()
	if godPociEnabled then
		PociPill.Text = "Poci: ON"
		PociPill.BackgroundColor3 = Color3.fromRGB(20, 110, 50)
	else
		PociPill.Text = "Poci: OFF"
		PociPill.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
	end
end

local function refreshSusterPill()
	if godSusterEnabled then
		SusterPill.Text = "Suster: ON"
		SusterPill.BackgroundColor3 = Color3.fromRGB(20, 110, 50)
	else
		SusterPill.Text = "Suster: OFF"
		SusterPill.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
	end
end

GodPill.MouseButton1Click:Connect(function()
	local g = getGenderuwoFolder()
	if not g then return end
	godDoctorEnabled = not godDoctorEnabled
	godModeEnabled = godDoctorEnabled
	setGodDoctor(godDoctorEnabled)
	refreshGodPill()
end)

PatrolPill.MouseButton1Click:Connect(function()
	godPatrolEnabled = not godPatrolEnabled
	setGodPatrol(godPatrolEnabled)
	refreshPatrolPill()
end)

PociPill.MouseButton1Click:Connect(function()
	local p = getPociFolder()
	if not p then return end
	godPociEnabled = not godPociEnabled
	setGodPoci(godPociEnabled)
	refreshPociPill()
end)

SusterPill.MouseButton1Click:Connect(function()
	local s = getSusterFolder()
	if not s then return end
	godSusterEnabled = not godSusterEnabled
	setGodSuster(godSusterEnabled)
	refreshSusterPill()
end)

-- ========================
-- HOST BUTTON
-- ========================
local hostEnabled = false
local hostWowoHandled = false

local HostBtn = Instance.new("TextButton")
HostBtn.Size = UDim2.new(1, -16, 0, 34)
HostBtn.Position = UDim2.new(0, 8, 0, 186)
HostBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
HostBtn.Text = "👾  HOST: OFF"
HostBtn.TextColor3 = Color3.fromRGB(180, 180, 220)
HostBtn.Font = Enum.Font.GothamBold
HostBtn.TextSize = 14
HostBtn.Parent = Main
Instance.new("UICorner", HostBtn).CornerRadius = UDim.new(0, 8)

local function refreshHostBtn()
	if hostEnabled then
		HostBtn.Text = "👾  HOST: ON"
		HostBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 130)
		HostBtn.TextColor3 = Color3.fromRGB(220, 180, 255)
	else
		HostBtn.Text = "👾  HOST: OFF"
		HostBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
		HostBtn.TextColor3 = Color3.fromRGB(180, 180, 220)
		hostWowoHandled = false
	end
end

HostBtn.MouseButton1Click:Connect(function()
	hostEnabled = not hostEnabled
	hostWowoHandled = false
	refreshHostBtn()

	if hostEnabled then
		-- Langsung aktifkan god mode + proximity saat Host ON
		local g = getGenderuwoFolder()
		if g then
			if not godModeEnabled then
				setGodMode(true)
				refreshGodPill()
			end
			if not proxActive then
				proxActive = true
				patchProximityPrompts()
			end
			teleportToGenderuwo()
		end
	end
end)

-- Action status
local ActionStatus = Instance.new("TextLabel")
ActionStatus.Size = UDim2.new(1, -16, 0, 18)
ActionStatus.Position = UDim2.new(0, 8, 0, 228)
ActionStatus.BackgroundTransparency = 1
ActionStatus.Font = Enum.Font.Gotham
ActionStatus.TextSize = 11
ActionStatus.Text = ""
ActionStatus.TextColor3 = Color3.fromRGB(255, 220, 80)
ActionStatus.TextXAlignment = Enum.TextXAlignment.Left
ActionStatus.Parent = Main

-- ========================
-- CLEAN AREA (dijalankan saat Host ON & task = "Clean the area")
-- ========================
local cleanHandled = false

local function CleanArea()
	if cleanHandled then return end
	cleanHandled = true
	ActionStatus.Text = "🧹 Cleaning area..."
	task.spawn(function()
		-- 1. Equip broom
		local ok, err = pcall(function()
			local broom = player.Backpack:WaitForChild("Broom", 10)
			local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid and broom then
				humanoid:EquipTool(broom)
			end
		end)
		if not ok then warn("[CleanArea] Equip error: " .. tostring(err)) end

		task.wait(0.5)

		-- 2. Tunggu folder Stain
		local stainFolder = workspace:WaitForChild("Stain", 10)
		if not stainFolder then
			warn("[CleanArea] Folder Stain tidak ditemukan!")
			cleanHandled = false
			ActionStatus.Text = ""
			return
		end

		-- 3. Teleport ke setiap stain satu per satu
		while true do
			local stains = stainFolder:GetChildren()
			if #stains == 0 then
				ActionStatus.Text = "✔ Area bersih!"
				task.wait(2)
				ActionStatus.Text = ""
				break
			end
			local stain = stains[1]
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root and stain then
				local pos = stain:IsA("BasePart") and stain.Position
					or (stain:FindFirstChildWhichIsA("BasePart") and stain:FindFirstChildWhichIsA("BasePart").Position)
				if pos then
					root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
					ActionStatus.Text = "🧹 " .. stain.Name
				end
				local timeout = 0
				repeat
					task.wait(0.2)
					timeout = timeout + 0.2
				until not stain.Parent or timeout >= 5
			end
		end

		cleanHandled = false
	end)
end

-- ========================
-- UPDATE LOOP
-- ========================
local genderuwoWasPresent = false

-- Loop CleanArea (hanya jalan jika Host ON)
task.spawn(function()
	while true do
		if hostEnabled then
			local ok, text = pcall(function()
				return player.PlayerGui.TaskUi.Task.Task.Text
			end)
			if ok and text then
				if text:find("Clean the area") then
					CleanArea()
				else
					cleanHandled = false
				end
			end
		end
		task.wait(1)
	end
end)

task.spawn(function()
	while ScreenGui.Parent do
		local wowo = findWowoBogel()
		local genderuwo = getGenderuwoFolder()
		local poci = getPociFolder()
		local suster = getSusterFolder()
		local patrol = workspace:FindFirstChild("Patrol")
		local patrolHasContent = patrol and #patrol:GetChildren() > 0

		-- Status WowoBogel
		if wowo then
			WowoStatus.Text = "● WowoBogel: Ditemukan"
			WowoStatus.TextColor3 = Color3.fromRGB(80, 255, 120)
		else
			WowoStatus.Text = "● WowoBogel: Tidak Ada"
			WowoStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
			hostWowoHandled = false
		end

		-- Status Doctor
		if genderuwo then
			GenderuwoStatus.Text = "● " .. genderuwo.Name .. " ditemukan"
			GenderuwoStatus.TextColor3 = Color3.fromRGB(80, 200, 255)
		else
			GenderuwoStatus.Text = "● Doctor: Tidak Ada"
			GenderuwoStatus.TextColor3 = Color3.fromRGB(140, 140, 140)
			if godDoctorEnabled then
				setGodDoctor(false)
				godModeEnabled = false
				refreshGodPill()
			end
		end

		-- Status Patrol + auto aktif/mati
		if patrolHasContent then
			PatrolStatus.Text = "● Patrol: Ada (" .. #patrol:GetChildren() .. ")"
			PatrolStatus.TextColor3 = Color3.fromRGB(255, 200, 80)
			if not godPatrolEnabled then
				setGodPatrol(true)
				refreshPatrolPill()
			end
		else
			PatrolStatus.Text = "● Patrol: Kosong"
			PatrolStatus.TextColor3 = Color3.fromRGB(140, 140, 140)
			if godPatrolEnabled then
				setGodPatrol(false)
				refreshPatrolPill()
			end
		end

		-- Status Poci
		if poci then
			PociStatus.Text = "● " .. poci.Name .. " ditemukan"
			PociStatus.TextColor3 = Color3.fromRGB(255, 150, 220)
			if not godPociEnabled then
				setGodPoci(true)
				refreshPociPill()
			end
		else
			PociStatus.Text = "● Poci: Tidak Ada"
			PociStatus.TextColor3 = Color3.fromRGB(140, 140, 140)
			if godPociEnabled then
				setGodPoci(false)
				refreshPociPill()
			end
		end

		-- Status Suster + auto aktif/mati
		if suster then
			SusterStatus.Text = "● " .. suster.Name .. " ditemukan"
			SusterStatus.TextColor3 = Color3.fromRGB(255, 120, 120)
			if not godSusterEnabled then
				setGodSuster(true)
				refreshSusterPill()
			end
		else
			SusterStatus.Text = "● Suster: Tidak Ada"
			SusterStatus.TextColor3 = Color3.fromRGB(140, 140, 140)
			if godSusterEnabled then
				setGodSuster(false)
				refreshSusterPill()
			end
		end

		-- HOST logic: saat Doctor pertama muncul & host ON
		if not genderuwoWasPresent and genderuwo then
			genderuwoWasPresent = true
			if hostEnabled then
				if not godDoctorEnabled then
					setGodDoctor(true)
					godModeEnabled = true
					refreshGodPill()
				end
				teleportToGenderuwo()
			end
		end
		if not genderuwo then genderuwoWasPresent = false end

		-- HOST: auto teleport + fire proximity WowoBogel saat muncul
		if hostEnabled and wowo and not hostWowoHandled then
			hostWowoHandled = true
			ActionStatus.Text = "👾 Host: teleport & fire prox..."
			task.spawn(function()
				task.wait(0.15)
				teleportAndClickWowo(wowo)
				task.wait(0.5)
				ActionStatus.Text = "✔ Host: selesai"
				task.wait(2)
				ActionStatus.Text = ""
			end)
		end

		task.wait(0.25)
	end
end)

-- ========================
-- DRAG
-- ========================
local dragging, dragStart, startPos = false, nil, nil
Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
