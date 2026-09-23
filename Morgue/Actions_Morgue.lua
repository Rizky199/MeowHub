-- =====================
-- Actions_Morgue.lua
-- Task: ruang mayat / kulkas jenazah
-- =====================

_G.TVG = _G.TVG or {}
_G.TVG.Actions = _G.TVG.Actions or {}
_G.TVG.Actions.Morgue = {}

local Utils = _G.TVG.Utils
local State = _G.TVG.State

local function FirePrompt(path) Utils.FirePrompt(path) end
local function TeleportTo(x, y, z) Utils.TeleportTo(x, y, z) end

function _G.TVG.Actions.Morgue.GoMorgueRoom()
	task.spawn(function()
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
		task.wait(0.3)
		TeleportTo(26.52, 4.65, -39.05)
		print("[GoMorgue] Teleport ke morgue room")
		task.wait(0.3)
		FirePrompt({"RuangMayat","Trolli","ProximityPrompt"})
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Morgue.GoTheMorgueRoom()
	task.spawn(function()
		TeleportTo(26.52, 4.65, -39.05)
		print("[GoTheMorgue] Teleport ke morgue room")
		task.wait(0.3)
		FirePrompt({"RuangMayat","Trolli","ProximityPrompt"})
		task.wait(0.3)
		FirePrompt({"Story","ActiveTrolley","Part","ProximityPrompt"})
	end)
end

function _G.TVG.Actions.Morgue.OpenFreezer(num)
	task.spawn(function()
		local ok, err = pcall(function()
			local kulkas = workspace:WaitForChild("RuangMayat",10):WaitForChild("KulkasMayat",10)
			local slot   = kulkas:WaitForChild(tostring(num), 10)
			local prompt = slot:WaitForChild("Door",10):WaitForChild("ProximityPrompt",10)
			if prompt then
				print("[OpenFreezer] Membuka freezer no: " .. num)
				fireproximityprompt(prompt)
			else
				warn("[OpenFreezer] ProximityPrompt tidak ditemukan untuk no: " .. num)
			end
		end)
		if not ok then warn("[OpenFreezer] error: " .. tostring(err)) end
	end)
end

function _G.TVG.Actions.Morgue.PlaceBodyFreezer()
	if State.hasDoAutopsy then
		FirePrompt({"Story","ActiveTrolley","Jenazah","Base","ProximityPrompt2"})
	else
		FirePrompt({"Story","ActiveTrolley","Jenazah","Base","ProximityPrompt"})
	end
end

function _G.TVG.Actions.Morgue.CloseFreezer()
	if State.lastFreezerNum == 0 then
		warn("[CloseFreezer] Nomor freezer tidak diketahui!")
		return
	end
	task.spawn(function()
		local ok, err = pcall(function()
			local kulkas = workspace:WaitForChild("RuangMayat",10):WaitForChild("KulkasMayat",10)
			local slot   = kulkas:WaitForChild(tostring(State.lastFreezerNum), 10)
			local prompt = slot:WaitForChild("Door",10):WaitForChild("ProximityPrompt2",10)
			if prompt then
				print("[CloseFreezer] Menutup freezer no: " .. State.lastFreezerNum)
				fireproximityprompt(prompt)
			else
				warn("[CloseFreezer] ProximityPrompt2 tidak ditemukan untuk no: " .. State.lastFreezerNum)
			end
		end)
		if not ok then warn("[CloseFreezer] error: " .. tostring(err)) end
	end)
end

function _G.TVG.Actions.Morgue.MoveBodyFromFreezer()
	if State.lastFreezerNum == 0 then
		warn("[MoveBodyFromFreezer] Nomor freezer tidak diketahui!")
		return
	end
	task.spawn(function()
		local ok, err = pcall(function()
			local kulkas = workspace:WaitForChild("RuangMayat",10):WaitForChild("KulkasMayat",10)
			local slot   = kulkas:WaitForChild(tostring(State.lastFreezerNum), 10)
			local prompt = slot:WaitForChild("Jenazah",10):WaitForChild("ProximityPrompt",10)
			if prompt then
				print("[MoveBodyFromFreezer] Memindahkan jenazah dari freezer no: " .. State.lastFreezerNum)
				fireproximityprompt(prompt)
			else
				warn("[MoveBodyFromFreezer] ProximityPrompt tidak ditemukan untuk no: " .. State.lastFreezerNum)
			end
		end)
		if not ok then warn("[MoveBodyFromFreezer] error: " .. tostring(err)) end
	end)
end
