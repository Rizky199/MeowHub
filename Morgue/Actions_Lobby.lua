-- =====================
-- Actions_Lobby.lua
-- Task: Pick up the phone!, Return to lobby, Clean the area,
--       Take and put stretcher to the lift
-- =====================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.TVG = _G.TVG or {}
_G.TVG.Actions = _G.TVG.Actions or {}
_G.TVG.Actions.Lobby = {}

function _G.TVG.Actions.Lobby.PickUpPhone()
	task.spawn(function()
		local character = LocalPlayer.Character
		if character then
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then
				local Lobby = workspace:WaitForChild("Lobby", 10)
				local Table = Lobby:WaitForChild("FrontTable", 10)
				local Phone = Table:WaitForChild("Phone", 10)
				local Base  = Phone:WaitForChild("Base", 10)
				root.CFrame = CFrame.new(Base.Position + Vector3.new(0, 3, 0))
				print("[PickUpPhone] Teleport ke phone berhasil")
			end
		end

		task.wait(0.3)

		local ok, err = pcall(function()
			local Lobby  = workspace:WaitForChild("Lobby", 10)
			local Table  = Lobby:WaitForChild("FrontTable", 10)
			local Phone  = Table:WaitForChild("Phone", 10)
			local Base   = Phone:WaitForChild("Base", 10)
			local prompt = Base:WaitForChild("ProximityPrompt", 10)
			if prompt then
				print("[PickUpPhone] ProximityPrompt ditemukan, firing...")
				fireproximityprompt(prompt)
			else
				warn("[PickUpPhone] ProximityPrompt TIDAK ditemukan!")
			end
		end)
		if not ok then
			warn("[PickUpPhone] prompt error: " .. tostring(err))
		end

		task.wait(0.5)

		local ok2, err2 = pcall(function()
			local args = { "Accept" }
			game:GetService("ReplicatedStorage"):WaitForChild("Gameplay"):WaitForChild("PhoneHandler"):FireServer(unpack(args))
			print("[PickUpPhone] FireServer berhasil dikirim!")
		end)
		if not ok2 then
			warn("[PickUpPhone] FireServer error: " .. tostring(err2))
		end
	end)
end

function _G.TVG.Actions.Lobby.CallNurse()
	task.spawn(function()
		local ok0, err0 = pcall(function()
			local trolley = workspace:WaitForChild("Story", 10):WaitForChild("ActiveTrolley", 10)
			local prompt0 = trolley:WaitForChild("Part", 10):WaitForChild("ProximityPrompt", 10)
			if prompt0 then
				print("[CallNurse] Klik ActiveTrolley ProximityPrompt...")
				fireproximityprompt(prompt0)
			else
				warn("[CallNurse] ActiveTrolley ProximityPrompt tidak ditemukan!")
			end
		end)
		if not ok0 then warn("[CallNurse] trolley error: " .. tostring(err0)) end

		task.wait(0.3)

		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = CFrame.new(Vector3.new(52.81, 4.65, -70.19))
			print("[CallNurse] Teleport ke lobby berhasil")
		end

		task.wait(0.3)

		local ok, err = pcall(function()
			local Lobby   = workspace:WaitForChild("Lobby", 10)
			local Table   = Lobby:WaitForChild("FrontTable", 10)
			local Phone   = Table:WaitForChild("Phone", 10)
			local Base    = Phone:WaitForChild("Base", 10)
			local prompt2 = Base:WaitForChild("ProximityPrompt2", 10)
			if prompt2 then
				print("[CallNurse] ProximityPrompt2 ditemukan, firing...")
				fireproximityprompt(prompt2)
			else
				warn("[CallNurse] ProximityPrompt2 TIDAK ditemukan!")
			end
		end)
		if not ok then warn("[CallNurse] error: " .. tostring(err)) end
	end)
end

function _G.TVG.Actions.Lobby.CleanArea()
	local State = _G.TVG.State
	if State.cleanHandled then return end
	State.cleanHandled = true
	task.spawn(function()
		local ok, err = pcall(function()
			local broom = LocalPlayer.Backpack:WaitForChild("Broom", 10)
			local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid and broom then
				humanoid:EquipTool(broom)
				print("[CleanArea] Broom equipped")
			end
		end)
		if not ok then warn("[CleanArea] Equip error: " .. tostring(err)) end

		task.wait(0.5)

		local stainFolder = workspace:WaitForChild("Stain", 10)
		if not stainFolder then
			warn("[CleanArea] Folder Stain tidak ditemukan!")
			State.cleanHandled = false
			return
		end

		while true do
			local stains = stainFolder:GetChildren()
			if #stains == 0 then
				print("[CleanArea] Semua stain sudah bersih!")
				break
			end

			local stain = stains[1]
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if root and stain then
				root.CFrame = CFrame.new(stain.Position + Vector3.new(0, 3, 0))
				print("[CleanArea] Teleport ke stain: " .. stain.Name)
				local timeout = 0
				repeat
					task.wait(0.2)
					timeout = timeout + 0.2
				until not stain.Parent or timeout >= 5
			end
		end

		State.cleanHandled = false
	end)
end

function _G.TVG.Actions.Lobby.StretcherToLift()
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = CFrame.new(Vector3.new(56.62, 4.65, -75.38))
	end
end
