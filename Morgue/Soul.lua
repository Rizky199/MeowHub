-- =====================
-- Soul.lua
-- Deteksi & handle "Jumpscare Soul"
-- =====================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.TVG = _G.TVG or {}
_G.TVG.Soul = {}

function _G.TVG.Soul.CheckSoul()
	local GUI = _G.TVG.GUI
	local ok, result = pcall(function()
		local soul = workspace.Story.ActiveTrolley.Jumpscare.Soul
		return soul ~= nil
	end)
	if ok and result then
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
	local ok, result = pcall(function()
		local soul = workspace.Story.ActiveTrolley.Jumpscare.Soul
		return soul ~= nil
	end)
	return ok and result
end

function _G.TVG.Soul.HandleSoul()
	local State = _G.TVG.State
	if State.soulHandled then return end
	task.spawn(function()
		local ok, err = pcall(function()
			local soul = workspace:WaitForChild("Story",10)
				:WaitForChild("ActiveTrolley",10)
				:WaitForChild("Jumpscare",10)
				:WaitForChild("Soul",10)
			if soul then
				State.soulHandled = true
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if root then
					root.CFrame = CFrame.new(soul.Position + Vector3.new(0, 3, 0))
					print("[Soul] Teleport ke Soul")
				end
				task.wait(0.3)
				local prompt = soul:FindFirstChildOfClass("ProximityPrompt")
				if prompt then
					fireproximityprompt(prompt)
					print("[Soul] ProximityPrompt diklik")
				end
			end
		end)
		if not ok then warn("[Soul] error: " .. tostring(err)) end
	end)
end
