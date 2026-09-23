-- =====================
-- Utils.lua
-- Fungsi umum: teleport, fire prompt, ambil teks task
-- =====================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.TVG = _G.TVG or {}
_G.TVG.Utils = {}

function _G.TVG.Utils.TeleportPlayer()
	local character = LocalPlayer.Character
	if character then
		local root = character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = CFrame.new(_G.TVG.Config.TELEPORT_POS)
		end
	end
end

function _G.TVG.Utils.TeleportTo(x, y, z)
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = CFrame.new(Vector3.new(x, y, z))
		print("[Teleport] -> " .. x .. ", " .. y .. ", " .. z)
	end
end

function _G.TVG.Utils.FirePrompt(path)
	task.spawn(function()
		local ok, err = pcall(function()
			local obj = workspace
			for _, part in ipairs(path) do
				obj = obj:WaitForChild(part, 10)
			end
			if obj then
				print("[FirePrompt] Firing: " .. path[#path])
				fireproximityprompt(obj)
			else
				warn("[FirePrompt] Tidak ditemukan: " .. tostring(path[#path]))
			end
		end)
		if not ok then warn("[FirePrompt] error: " .. tostring(err)) end
	end)
end

function _G.TVG.Utils.GetTaskText()
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local ok, result = pcall(function()
		local obj = PlayerGui.TaskUi.Task.Task
		if obj:IsA("TextLabel") or obj:IsA("TextBox") then
			return obj.Text
		elseif obj:IsA("StringValue") then
			return obj.Value
		end
		return tostring(obj)
	end)
	return ok and result or "Error: " .. tostring(result)
end
