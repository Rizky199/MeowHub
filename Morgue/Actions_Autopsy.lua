-- =====================
-- Actions_Autopsy.lua
-- Task: ruang otopsi
-- =====================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.TVG = _G.TVG or {}
_G.TVG.Actions = _G.TVG.Actions or {}
_G.TVG.Actions.Autopsy = {}

local Utils = _G.TVG.Utils
local State = _G.TVG.State

local function FirePrompt(path) Utils.FirePrompt(path) end
local function TeleportTo(x, y, z) Utils.TeleportTo(x, y, z) end

function _G.TVG.Actions.Autopsy.PickUpStretcher()
	task.spawn(function()
		TeleportTo(56.41, 4.65, -74.81)
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Autopsy.GoAutopsyRoom()
	task.spawn(function()
		State.hasDoAutopsy = true
		TeleportTo(70.02, 4.65, -63.20)
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Autopsy.MoveBodyAutopsyTable()
	FirePrompt({"Story","ActiveTrolley","Jenazah","Base","ProximityPrompt"})
end

function _G.TVG.Actions.Autopsy.MoveStretcher()
	task.spawn(function()
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Autopsy.StartAutopsy()
	task.spawn(function()
		TeleportTo(67.21, 8.01, -64.01)
		task.wait(0.3)
		FirePrompt({"RuangDokter","TempatOtopsi","Jenazah","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Autopsy.AddDataCallPolice()
	task.spawn(function()
		TeleportTo(74.70, 4.65, -56.90)
		task.wait(0.3)
		FirePrompt({"RuangDokter","FrontTable","Computer","Mesh","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Autopsy.AddDataComputer()
	task.spawn(function()
		TeleportTo(74.26, 4.65, -58.43)
		task.wait(0.3)
		FirePrompt({"RuangDokter","FrontTable","Computer","Mesh","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Autopsy.TakeStretcher()
	FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
end

function _G.TVG.Actions.Autopsy.PlaceStretcherBesideBody()
	task.spawn(function()
		FirePrompt({"RuangDokter","Trolli","ProximityPrompt"})
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Autopsy.MoveBodyStretcher2()
	FirePrompt({"RuangDokter","TempatOtopsi","Jenazah","ProximityPrompt2"})
end

function _G.TVG.Actions.Autopsy.FinishAutopsyMinigame()
	task.spawn(function()
		local ok, err = pcall(function()
			game:GetService("ReplicatedStorage"):WaitForChild("Gameplay"):WaitForChild("MinigamesHandler"):FireServer("Autopsy", "Finished")
			print("[FinishAutopsy] FireServer Autopsy Finished dikirim")
		end)
		if not ok then warn("[FinishAutopsy] FireServer error: " .. tostring(err)) end

		task.wait(0.3)

		local ok2, err2 = pcall(function()
			local autopsyGui = LocalPlayer.PlayerGui:WaitForChild("Minigames", 10):WaitForChild("Autopsy", 10)
			autopsyGui.Visible = false
			print("[FinishAutopsy] Autopsy GUI disembunyikan")
		end)
		if not ok2 then warn("[FinishAutopsy] GUI error: " .. tostring(err2)) end
	end)
end
