-- =====================
-- Actions_Cremation.lua
-- Task: ruang kremasi
-- =====================

_G.TVG = _G.TVG or {}
_G.TVG.Actions = _G.TVG.Actions or {}
_G.TVG.Actions.Cremation = {}

local Utils = _G.TVG.Utils
local State = _G.TVG.State

local function FirePrompt(path) Utils.FirePrompt(path) end
local function TeleportTo(x, y, z) Utils.TeleportTo(x, y, z) end

function _G.TVG.Actions.Cremation.GoCrematory()
	task.spawn(function()
		TeleportTo(32.79, 4.65, -61.00)
		task.wait(0.3)
		FirePrompt({"RuangKremasi","Trolli","ProximityPrompt"})
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Cremation.GoCremationRoom()
	task.spawn(function()
		TeleportTo(77.86, 17.65, -43.75)
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
		task.wait(0.3)
		TeleportTo(32.45, 4.65, -61.07)
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Cremation.OpenCrematorDoor()
	task.spawn(function()
		if State.openCrematorCount == 0 then
			TeleportTo(37.52, 4.65, -58.23)
			task.wait(0.3)
			FirePrompt({"RuangKremasi","Mesin","Panel","Display","Open"})
			print("[Cremator] Open door pertama")
		else
			FirePrompt({"RuangKremasi","Mesin","Panel","Display","Open2"})
			print("[Cremator] Open door kedua")
		end
		if State.openCrematorCount >= 1 then
			State.openCrematorCount = 0
			print("[Cremator] Open counter direset")
		else
			State.openCrematorCount = State.openCrematorCount + 1
		end
	end)
end

function _G.TVG.Actions.Cremation.MoveBodyCrematorRails()
	FirePrompt({"Story","ActiveTrolley","Jenazah","Base","ProximityPrompt"})
end

function _G.TVG.Actions.Cremation.CloseCrematorDoor()
	task.spawn(function()
		if State.closeCrematorCount == 0 then
			FirePrompt({"RuangKremasi","Mesin","Panel","Display","Close"})
			print("[Cremator] Close door pertama")
		else
			FirePrompt({"RuangKremasi","Mesin","Panel","Display","Close2"})
			print("[Cremator] Close door kedua")
		end
		if State.closeCrematorCount >= 1 then
			State.closeCrematorCount = 0
			print("[Cremator] Close counter direset")
		else
			State.closeCrematorCount = State.closeCrematorCount + 1
		end
	end)
end

function _G.TVG.Actions.Cremation.TurnOnCremator()
	FirePrompt({"RuangKremasi","Mesin","Panel","Display","On"})
end

function _G.TVG.Actions.Cremation.CollectBones()
	FirePrompt({"RuangKremasi","Mesin","Jenazah","ProximityPrompt"})
end

function _G.TVG.Actions.Cremation.PlaceBoneGrind()
	task.spawn(function()
		TeleportTo(40.90, 4.65, -62.88)
		task.wait(0.3)
		FirePrompt({"RuangKremasi","Grinder","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Cremation.TakeCrematorUrn()
	FirePrompt({"RuangKremasi","Urn","ProximityPrompt"})
end

function _G.TVG.Actions.Cremation.TakeOutAshes()
	FirePrompt({"RuangKremasi","Grinder","ProximityPrompt2"})
end

function _G.TVG.Actions.Cremation.PlaceUrnStretcher()
	task.spawn(function()
		TeleportTo(36.53, 4.65, -60.20)
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Urn","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Cremation.TakeUrn()
	task.spawn(function()
		TeleportTo(86.07, 17.65, -41.75)
		task.wait(0.3)
		FirePrompt({"RuangPenyimpanan","Urn","ProximityPrompt"})
	end)
end
