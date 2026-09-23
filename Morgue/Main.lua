-- =====================
-- Main.lua
-- Loader + Main Loop untuk TaskViewerGui
-- =====================
-- CARA PAKAI:
-- 1. Upload semua file (Config.lua, Utils.lua, GUI.lua, Soul.lua,
--    Actions_Lobby.lua, Actions_Sterilization.lua, Actions_Autopsy.lua,
--    Actions_Morgue.lua, Actions_Cremation.lua, Actions_Misc.lua)
--    ke folder repo GitHub kamu (contoh: Rizky199/MeowHub, folder "Morgue").
--    Isinya sama persis dengan file .txt yang kamu download, tinggal
--    di-rename ekstensinya jadi .lua saat upload.
-- 2. Jalankan HANYA script ini (Main.txt) lewat executor — file ini
--    otomatis mengambil semua file lain lewat game:HttpGet()+loadstring().
-- =====================

local BASE_URL = "https://raw.githubusercontent.com/Rizky199/MeowHub/main/Morgue/"

local FILES = {
	"Config.lua",
	"Utils.lua",
	"GUI.lua",
	"Soul.lua",
	"Actions_Lobby.lua",
	"Actions_Sterilization.lua",
	"Actions_Autopsy.lua",
	"Actions_Morgue.lua",
	"Actions_Cremation.lua",
	"Actions_Misc.lua",
	"WowoBogelScanner.lua",
}

for _, fileName in ipairs(FILES) do
	local ok, err = pcall(function()
		local source = game:HttpGet(BASE_URL .. fileName)
		loadstring(source)()
	end)
	if not ok then
		warn("[Loader] Gagal memuat " .. fileName .. ": " .. tostring(err))
	end
end

-- =====================
-- Shortcut Referensi (dengan pengecekan modul gagal load)
-- =====================
local function requireModule(name, tbl)
	if not tbl then
		warn("[Main] Modul '" .. name .. "' GAGAL dimuat / tidak ditemukan! Cek nama file & link raw GitHub-nya.")
	end
	return tbl
end

local Config    = requireModule("Config", _G.TVG.Config)
local State     = requireModule("State", _G.TVG.State)
local Utils     = requireModule("Utils", _G.TVG.Utils)
local GUI       = requireModule("GUI", _G.TVG.GUI)
local Soul      = requireModule("Soul", _G.TVG.Soul)
local Lobby     = requireModule("Actions_Lobby", _G.TVG.Actions and _G.TVG.Actions.Lobby)
local Steril    = requireModule("Actions_Sterilization", _G.TVG.Actions and _G.TVG.Actions.Sterilization)
local Autopsy   = requireModule("Actions_Autopsy", _G.TVG.Actions and _G.TVG.Actions.Autopsy)
local Morgue    = requireModule("Actions_Morgue", _G.TVG.Actions and _G.TVG.Actions.Morgue)
local Cremation = requireModule("Actions_Cremation", _G.TVG.Actions and _G.TVG.Actions.Cremation)

if not (GUI and GUI.TaskText) then
	warn("[Main] GUI.lua tidak lengkap/gagal dimuat — script dihentikan. Perbaiki GUI.lua dulu.")
	return
end

-- Update awal (dibungkus pcall supaya tidak menghentikan script kalau Utils/Soul gagal)
local ok1, taskText = pcall(function() return Utils.GetTaskText() end)
GUI.TaskText.Text = ok1 and taskText or "Error: Utils.lua gagal"

local ok2 = pcall(function() Soul.CheckSoul() end)
if not ok2 then
	GUI.SoulStatus.Text = "Error: Soul.lua gagal"
end

-- =====================
-- Auto-refresh + Action
-- =====================
local lastTeleport         = 0
local phoneHandled         = false
local nurseHandled         = false
local stretcherHandled     = false
local sterilizeHandled     = false
local sterilizeHandled2    = false
local storageroomHandled   = false
local movebodyHandled      = false
local turnonHandled        = false
local soapHandled          = false
local cleanbodyHandled     = false
local turnoffHandled       = false
local takeshroudHandled    = false
local refillshroudHandled  = false
local takesoapbarHandled   = false
local placeshroudHandled   = false
local movetableHandled     = false
local changesheetHandled   = false
local shroudbodyHandled    = false
local movestretchHandled   = false
local pickstretcherH       = false
local goautopsyH           = false
local movebodyautopsyH     = false
local movestretcherH       = false
local startautopsyH        = false
local autopsyMinigameH     = false
local adddataH             = false
local adddatacomputerH     = false
local takestretcherH       = false
local placestretcherH      = false
local movebodystretch2H    = false
local gomorgueH            = false
local openfreezerH         = false
local placebodyH           = false
local closefreezerH        = false
local movebodyfreezerH     = false
local gocrematoryH         = false
local gocremationroomH     = false
local opencrematorH        = false
local movebodyrailsH       = false
local closecrematorH       = false
local turnonH              = false
local collectbonesH        = false
local placebonegrindH      = false
local takeurnH             = false
local takeurnstorageH      = false
local refillurnH           = false
local takeashesH           = false
local placeurnH            = false

local function StepOnce()
		local text = Utils.GetTaskText()
		GUI.TaskText.Text = text
		Soul.CheckSoul()

		-- *** PRIORITAS: Handle Soul jika ada, skip semua task lain ***
		if Soul.IsSoulPresent() then
			Soul.HandleSoul()
			return
		else
			State.soulHandled = false
		end

		local now = tick()

		-- Waiting... -> teleport + reset flag storage room
		if text == Config.TASK_WAITING then
			if now - lastTeleport >= 3 then
				lastTeleport = now
				Utils.TeleportPlayer()
			end
			State.hasStorageRoom = false
		end

		-- Pick up the phone!
		if text == Config.TASK_PHONE then
			if not phoneHandled then phoneHandled = true; Lobby.PickUpPhone() end
		else phoneHandled = false end

		-- Clean the area
		if text:find("Clean the area") then
			Lobby.CleanArea()
		end

		-- Return to lobby
		if text:find("Return to lobby") or text:find("Go to lobby and make a call") then
			if not nurseHandled then nurseHandled = true; Lobby.CallNurse() end
		else nurseHandled = false end

		-- Take and put stretcher to the lift
		if text:find("Take and put stretcher to the lift") then
			if not stretcherHandled then stretcherHandled = true; Lobby.StretcherToLift() end
		else stretcherHandled = false end

		-- Go to sterilization area
		if text:find("Go to sterilization area") then
			if not sterilizeHandled then sterilizeHandled = true; Steril.GoSterilize() end
		else sterilizeHandled = false end

		-- Go to Sterilization Room
		if text:find("Go to Sterilization Room") then
			if not sterilizeHandled2 then sterilizeHandled2 = true; Steril.GoSterilizeRoom() end
		else sterilizeHandled2 = false end

		-- Go to the storage room
		if text:find("Go to the storage room") then
			if not storageroomHandled then storageroomHandled = true; Steril.GoStorageRoom() end
		else storageroomHandled = false end

		-- Move body to the washing table
		if text:find("Move body to the washing table") then
			if not movebodyHandled then movebodyHandled = true; Steril.MoveBodyWash() end
		else movebodyHandled = false end

		-- Turn on the water
		if text:find("Turn on the water") then
			if not turnonHandled then turnonHandled = true; Steril.TurnOnWater() end
		else turnonHandled = false end

		-- Take the soap
		if text:find("Take the soap") then
			if not soapHandled then soapHandled = true; Steril.TakeSoap() end
		else soapHandled = false end

		-- Clean the body with soap
		if text:find("Clean the body with soap") then
			if not cleanbodyHandled then cleanbodyHandled = true; Steril.CleanBodySoap() end
		else cleanbodyHandled = false end

		-- Turn off the water
		if text:find("Turn off the water") then
			if not turnoffHandled then turnoffHandled = true; Steril.TurnOffWater() end
		else turnoffHandled = false end

		-- Take the shroud sheet
		if text:find("Take the shroud sheet") then
			if not takeshroudHandled then takeshroudHandled = true; Steril.TakeShroud() end
		else takeshroudHandled = false end

		-- Refill the shroud sheet to the basket
		if text:find("Refill the shroud sheet to the basket") then
			if not refillshroudHandled then refillshroudHandled = true; Steril.RefillShroud() end
		else refillshroudHandled = false end

		-- Take the soap bar
		if text:find("Take the soap bar") then
			if not takesoapbarHandled then takesoapbarHandled = true; Steril.TakeSoapBar() end
		else takesoapbarHandled = false end

		-- Place shroud sheet to the table
		if text:find("Place shroud sheet to the table") then
			if not placeshroudHandled then placeshroudHandled = true; Steril.PlaceShroud() end
		else placeshroudHandled = false end

		-- Move body to the table
		if text:find("Move body to the table") then
			if not movetableHandled then movetableHandled = true; Steril.MoveBodyTable() end
		else movetableHandled = false end

		-- Change the sheet
		if text:find("Change the sheet") then
			if not changesheetHandled then changesheetHandled = true; Steril.ChangeSheet() end
		else changesheetHandled = false end

		-- Shroud the body
		if text:find("Shroud the body") then
			if not shroudbodyHandled then shroudbodyHandled = true; Steril.ShroudBody() end
		else shroudbodyHandled = false end

		-- Move body to the stretcher
		if text:find("Move body to the stretcher") then
			if not movestretchHandled then movestretchHandled = true; Steril.MoveBodyStretcher() end
		else movestretchHandled = false end

		-- Pick up the stretcher
		if text:find("Pick up the stretcher") then
			if not pickstretcherH then pickstretcherH = true; Autopsy.PickUpStretcher() end
		else pickstretcherH = false end

		-- Go to the autopsy room
		if text:find("Go to the autopsy room") then
			if not goautopsyH then goautopsyH = true; Autopsy.GoAutopsyRoom() end
		else goautopsyH = false end

		-- Move body to the autopsy table
		if text:find("Move body to the autopsy table") then
			if not movebodyautopsyH then movebodyautopsyH = true; Autopsy.MoveBodyAutopsyTable() end
		else movebodyautopsyH = false end

		-- Move stretcher
		if text:find("Move stretcher") or text:find("Move the stretcher") then
			if not movestretcherH then movestretcherH = true; Autopsy.MoveStretcher() end
		else movestretcherH = false end

		-- Start autopsy
		if text:find("Start autopsy") then
			if not startautopsyH then startautopsyH = true; Autopsy.StartAutopsy() end
		else startautopsyH = false end

		-- (nama player) is performing an autopsy...
		if text:find("is performing an autopsy") then
			if not autopsyMinigameH then autopsyMinigameH = true; Autopsy.FinishAutopsyMinigame() end
		else autopsyMinigameH = false end

		-- Add data on computer and call police
		if text:find("Add data on computer and call police") then
			if not adddataH then adddataH = true; Autopsy.AddDataCallPolice() end
		else adddataH = false end

		-- Add data on computer
		if text:find("Add data on computer") and not text:find("call police") then
			if not adddatacomputerH then adddatacomputerH = true; Autopsy.AddDataComputer() end
		else adddatacomputerH = false end

		-- Take the stretcher
		if text:find("Take the stretcher") then
			if not takestretcherH then takestretcherH = true; Autopsy.TakeStretcher() end
		else takestretcherH = false end

		-- Place stretcher beside the body
		if text:find("Place stretcher beside the body") then
			if not placestretcherH then placestretcherH = true; Autopsy.PlaceStretcherBesideBody() end
		else placestretcherH = false end

		-- Move body to the stretcher (autopsy)
		if text:find("Move body to the stretcher") then
			if not movebodystretch2H then movebodystretch2H = true; Autopsy.MoveBodyStretcher2() end
		else movebodystretch2H = false end

		-- Go to morgue room / Go to the morgue room
		if text:find("Go to morgue room") and not text:find("Go to the morgue room") then
			if not gomorgueH then gomorgueH = true; Morgue.GoMorgueRoom() end
		elseif text:find("Go to the morgue room") then
			if not gomorgueH then gomorgueH = true; Morgue.GoTheMorgueRoom() end
		else gomorgueH = false end

		-- Open the freezer No: X
		local freezerMatch = text:match("Open the freezer No: (%d+)")
		if freezerMatch then
			if not openfreezerH then
				openfreezerH = true
				State.lastFreezerNum = tonumber(freezerMatch)
				Morgue.OpenFreezer(State.lastFreezerNum)
			end
		else openfreezerH = false end

		-- Place the body to the freezer
		if text:find("Place the body to the freezer") then
			if not placebodyH then placebodyH = true; Morgue.PlaceBodyFreezer() end
		else placebodyH = false end

		-- Close freezer
		if text:find("Close freezer") then
			if not closefreezerH then closefreezerH = true; Morgue.CloseFreezer() end
		else closefreezerH = false end

		-- Move the body to the stretcher (dari freezer)
		if text:find("Move the body to the stretcher") then
			if not movebodyfreezerH then movebodyfreezerH = true; Morgue.MoveBodyFromFreezer() end
		else movebodyfreezerH = false end

		-- Go to crematory room
		if text:find("Go to crematory room") then
			if not gocrematoryH then gocrematoryH = true; Cremation.GoCrematory() end
		else gocrematoryH = false end

		-- Go to cremation room (via storage room)
		if text:find("Go to cremation room") and not text:find("Go to crematory room") then
			if not gocremationroomH then gocremationroomH = true; Cremation.GoCremationRoom() end
		else gocremationroomH = false end

		-- Open the cremator door
		if text:find("Open the cremator door") then
			if not opencrematorH then opencrematorH = true; Cremation.OpenCrematorDoor() end
		else opencrematorH = false end

		-- Move body to the cremator rails
		if text:find("Move body to the cremator rails") then
			if not movebodyrailsH then movebodyrailsH = true; Cremation.MoveBodyCrematorRails() end
		else movebodyrailsH = false end

		-- Close the cremator door / Close cremator door
		if text:find("Close the cremator door") or text:find("Close cremator door") then
			if not closecrematorH then closecrematorH = true; Cremation.CloseCrematorDoor() end
		else closecrematorH = false end

		-- Turn on the cremator
		if text:find("Turn on the cremator") then
			if not turnonH then turnonH = true; Cremation.TurnOnCremator() end
		else turnonH = false end

		-- Collect the bones
		if text:find("Collect the bones") then
			if not collectbonesH then collectbonesH = true; Cremation.CollectBones() end
		else collectbonesH = false end

		-- Place bone and start grinding
		if text:find("Place bone and start grinding") then
			if not placebonegrindH then placebonegrindH = true; Cremation.PlaceBoneGrind() end
		else placebonegrindH = false end

		-- Take the cremation urn
		if text:find("Take the cremation urn") then
			if not takeurnH then takeurnH = true; Cremation.TakeCrematorUrn() end
		else takeurnH = false end

		-- Take the urn (dari storage)
		if text:find("Take the urn") and not text:find("Take the cremation urn") then
			if not takeurnstorageH then takeurnstorageH = true; Cremation.TakeUrn() end
		else takeurnstorageH = false end

		-- Refill the urn to the shelf
		if text:find("Refill the urn to the shelf") then
			if not refillurnH then refillurnH = true
				Utils.FirePrompt({"Story","ActiveTrolley","Keranjang","Urn","UrnMiddle","ProximityPrompt"})
			end
		else refillurnH = false end

		-- Take out ashes
		if text:find("Take out ashes") then
			if not takeashesH then takeashesH = true; Cremation.TakeOutAshes() end
		else takeashesH = false end

		-- Place cremation urn to the stretcher
		if text:find("Place cremation urn to the stretcher") then
			if not placeurnH then placeurnH = true; Cremation.PlaceUrnStretcher() end
		else placeurnH = false end
end

task.spawn(function()
	while GUI.ScreenGui and GUI.ScreenGui.Parent do
		local ok, err = pcall(StepOnce)
		if not ok then
			warn("[MainLoop] Error: " .. tostring(err))
		end
		task.wait(1)
	end
end)
