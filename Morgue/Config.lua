-- =====================
-- Config.lua
-- Berisi semua konstanta (posisi teleport & nama task) + state bersama
-- =====================

_G.TVG = _G.TVG or {}

_G.TVG.Config = {
	TELEPORT_POS    = Vector3.new(55.22, 4.65, -61.20),

	TASK_WAITING    = "Waiting...",
	TASK_PHONE      = "Pick up the phone!",
	TASK_CLEAN      = "Clean the area",
	TASK_NURSE      = "Return to lobby",
	TASK_STRETCHER  = "Take and put stretcher to the lift",
	TASK_STERILIZE  = "Go to sterilization area",
	TASK_STERILIZE2 = "Go to Sterilization Room",
	TASK_MOVEBODY   = "Move body to the washing table",
	TASK_TURNON     = "Turn on the water",
	TASK_SOAP       = "Take the soap",
	TASK_CLEANBODY  = "Clean the body with soap",
	TASK_TURNOFF    = "Turn off the water",
	TASK_SHROUDTAKE = "Take the shroud sheet",
	TASK_SHROUDPLACE= "Place shroud sheet to the table",
	TASK_MOVETABLE  = "Move body to the table",
	TASK_CHANGESHEET= "Change the sheet",
	TASK_SHROUDBODY = "Shroud the body",
	TASK_MOVESTRETCH= "Move body to the stretcher",
}

-- State bersama (flag & counter yang dipakai lintas file)
_G.TVG.State = _G.TVG.State or {
	hasStorageRoom     = false,
	hasDoAutopsy       = false,
	lastFreezerNum     = 0,
	openCrematorCount  = 0,
	closeCrematorCount = 0,
	cleanHandled       = false,
	soulHandled        = false,
}
