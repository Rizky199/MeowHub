-- =====================
-- Soul.lua
-- Deteksi & handle "Jumpscare Soul"
-- =====================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.TVG = _G.TVG or {}
_G.TVG.Soul = {}

-- Helper: cari folder Jumpscare
local function getJumpscare()
	local story = workspace:FindFirstChild("Story")
	local trolley = story and story:FindFirstChild("ActiveTrolley")
	return trolley and trolley:FindFirstChild("Jumpscare")
end

-- Helper: cari objek "Suster" di dalam Jumpscare (nama diawali "suster", tidak case-sensitive)
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

function _G.TVG.Soul.CheckSoul()
	local GUI = _G.TVG.GUI
	local suster = getSusterFolder()
	if suster then
		GUI.SoulStatus.Text = "ADA di Workspace"
		GUI.SoulStatus.TextColor3 = Color3.fromRGB(80, 255, 120)
		GUI.Dot.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
	else
		GUI.SoulStatus.Text = "TIDAK ADA di Workspace"
		GUI.SoulStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
		GUI.Dot.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	end
end

function _G.TVG.Soul.IsSoulPresent()
	return getSusterFolder() ~= nil
end

function _G.TVG.Soul.HandleSoul()
	local State = _G.TVG.State
	if State.soulHandled then return end
	task.spawn(function()
		local ok, err = pcall(function()
			local suster = getSusterFolder()
			if suster then
				State.soulHandled = true
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				local part = suster:IsA("BasePart") and suster or suster:FindFirstChildWhichIsA("BasePart", true)
				if root and part then
					root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
					print("[Suster] Teleport ke Suster")
				end
				task.wait(0.3)
				local prompt = suster:FindFirstChildOfClass("ProximityPrompt")
					or (part and part:FindFirstChildOfClass("ProximityPrompt"))
				if prompt then
					fireproximityprompt(prompt)
					print("[Suster] ProximityPrompt diklik")
				end
			end
		end)
		if not ok then warn("[Suster] error: " .. tostring(err)) end
	end)
end
