-- =====================
-- Actions_Misc.lua
-- Fungsi tambahan yang di script asli sudah didefinisikan
-- tapi belum dipanggil di loop utama (Fix the electrical circuit!)
-- =====================

_G.TVG = _G.TVG or {}
_G.TVG.Actions = _G.TVG.Actions or {}
_G.TVG.Actions.Misc = {}

local Utils = _G.TVG.Utils

function _G.TVG.Actions.Misc.FixElectrical()
	task.spawn(function()
		Utils.TeleportTo(29.14, 17.78, -57.36)
		task.wait(0.3)
		Utils.FirePrompt({"RuangElektrikal","ElectricPanel","model","ProximityPrompt"})
	end)
end
