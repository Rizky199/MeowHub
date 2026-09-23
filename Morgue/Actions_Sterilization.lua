-- =====================
-- Actions_Sterilization.lua
-- Task: sterilisasi, ruang cuci jenazah, kain kafan
-- =====================

_G.TVG = _G.TVG or {}
_G.TVG.Actions = _G.TVG.Actions or {}
_G.TVG.Actions.Sterilization = {}

local Utils = _G.TVG.Utils
local State = _G.TVG.State

local function FirePrompt(path) Utils.FirePrompt(path) end
local function TeleportTo(x, y, z) Utils.TeleportTo(x, y, z) end

function _G.TVG.Actions.Sterilization.GoSterilize()
	task.spawn(function()
		TeleportTo(95.26, 4.65, -40.69)
		task.wait(0.3)
		FirePrompt({"RuangMandi","Trolli1","Trolli","ProximityPrompt"})
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Sterilization.GoSterilizeRoom()
	task.spawn(function()
		if State.hasStorageRoom then
			TeleportTo(79.17, 17.65, -42.57)
			task.wait(0.3)
			FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
			task.wait(0.3)
			TeleportTo(82.33, 4.65, -39.59)
			task.wait(0.3)
			FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
		else
			FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
			task.wait(0.3)
			TeleportTo(95.26, 4.65, -40.69)
			task.wait(0.3)
			FirePrompt({"RuangMandi","Trolli1","Trolli","ProximityPrompt"})
			task.wait(0.3)
			FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
		end
	end)
end

function _G.TVG.Actions.Sterilization.GoStorageRoom()
	task.spawn(function()
		State.hasStorageRoom = true
		TeleportTo(79.39, 17.65, -40.98)
		task.wait(0.3)
		FirePrompt({"RuangPenyimpanan","Trolli","ProximityPrompt"})
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Sterilization.MoveBodyWash()
	FirePrompt({"Story","ActiveTrolley","Jenazah","Base","ProximityPrompt"})
end

function _G.TVG.Actions.Sterilization.TurnOnWater()
	task.spawn(function()
		TeleportTo(99.56, 4.65, -41.73)
		task.wait(0.3)
		FirePrompt({"RuangMandi","TempatMandi","Shower","Tombol","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Sterilization.TakeSoap()
	FirePrompt({"RuangMandi","Sabun","Sabun","ProximityPrompt"})
end

function _G.TVG.Actions.Sterilization.CleanBodySoap()
	FirePrompt({"RuangMandi","TempatMandi","Jenazah","ProximityPrompt"})
end

function _G.TVG.Actions.Sterilization.TurnOffWater()
	FirePrompt({"RuangMandi","TempatMandi","Shower","Tombol","ProximityPrompt2"})
end

function _G.TVG.Actions.Sterilization.TakeShroud()
	task.spawn(function()
		if State.hasStorageRoom then
			TeleportTo(84.60, 17.65, -40.77)
			task.wait(0.3)
			FirePrompt({"RuangPenyimpanan","KainKafan","Kafan","ProximityPrompt"})
		else
			TeleportTo(81.90, 4.65, -44.68)
			task.wait(0.3)
			FirePrompt({"RuangMandi","KainKafan","Kafan","ProximityPrompt"})
		end
	end)
end

function _G.TVG.Actions.Sterilization.RefillShroud()
	FirePrompt({"Story","ActiveTrolley","Keranjang","Part","ProximityPrompt"})
end

function _G.TVG.Actions.Sterilization.TakeSoapBar()
	task.spawn(function()
		TeleportTo(84.95, 17.78, -40.21)
		task.wait(0.3)
		FirePrompt({"RuangPenyimpanan","Sabun","Sabun","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Sterilization.PlaceShroud()
	task.spawn(function()
		TeleportTo(92.71, 4.65, -40.79)
		task.wait(0.3)
		FirePrompt({"RuangMandi","TempatKafan","Kafan","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Sterilization.MoveBodyTable()
	task.spawn(function()
		TeleportTo(96.97, 4.65, -40.80)
		task.wait(0.3)
		FirePrompt({"RuangMandi","TempatMandi","Jenazah","ProximityPrompt2"})
	end)
end

function _G.TVG.Actions.Sterilization.ChangeSheet()
	FirePrompt({"RuangMandi","TempatKafan","Jenazah","ProximityPrompt"})
end

function _G.TVG.Actions.Sterilization.ShroudBody()
	FirePrompt({"RuangMandi","TempatKafan","Jenazah","ProximityPrompt2"})
end

function _G.TVG.Actions.Sterilization.MoveBodyStretcher()
	FirePrompt({"RuangMandi","TempatKafan","Pocong","ProximityPrompt"})
end
