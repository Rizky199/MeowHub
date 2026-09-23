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
				-- Sementara nonaktif: tidak teleport & tidak fire ProximityPrompt ke Suster,
				-- cukup ditandai "handled" supaya tidak spam tiap detik.
				print("[Suster] Terdeteksi, tapi auto teleport/fire dinonaktifkan sementara")
			end
		end)
		if not ok then warn("[Suster] error: " .. tostring(err)) end
	end)
end
