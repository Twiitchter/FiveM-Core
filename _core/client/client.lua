-- Once the user is connected and confirmed in the Network Session start join and enable pvp.
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerServerEvent('Core:UserConnecting')
			SetCanAttackFriendly(PlayerPedId(), true, false)
			NetworkSetFriendlyFireOption(true)
			return
		end
	end
end)

-- Clean up UI.
Citizen.CreateThread(function()
	RemoveMultiplayerHudCash()
    while true do
		Wait(0)
		HideAreaAndVehicleNameThisFrame()
	end
end)

-- Set minimap to only open once in a vehicle.
Citizen.CreateThread(function()
	while true do
		Wait(333)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			Wait(2000)
			Radar(true)
		else
			Wait(500)
			Radar(false)
		end
	end
end)

function Radar(bool)
	local oldbool = nil
	if bool then
		oldbool = bool
	end
	if not bool then
		oldbool = bool
	end
	if oldbool == true then
		DisplayRadar(true)
	end
	if oldbool == false then
		DisplayRadar(false)
	end
end

-- Only save once the character has loaded from the server.
Citizen.CreateThread(function()
	while true do
		-- Loop until the client is flagged as ready.
		while not _C:ClientReady() do
			Wait(5000)
		end
		--
		Wait(15000) -- Every 15 Seconds. Update the contents of SendClientData()
		ClientSync()
		--
	end
end)

function ClientSync()
	-- Add other fucntions here to trigger after a character has loaded. Sync functions or event triggers etc.
	Coords()	
	--

	--

	--

	--
end

function Coords()
	local loc = GetEntityCoords(PlayerPedId())
	local arg = {x = _C:DecimalPlaces(loc.x, 2), y = _C:DecimalPlaces(loc.y, 2), z = _C:DecimalPlaces(loc.z, 2)}
	local t = json.encode(arg)
	TriggerServerEvent('Core:UpdatePlayerCoords', t)
end

------------------------------------------------------------------------------

RegisterNetEvent('__C:CharacterLoaded')
AddEventHandler('__C:CharacterLoaded', function(C)
	__C.CharacterData = C
	__C.Loaded = true
	-- Set the locale for the user.
	_L.SetLocale(__C.CharacterData.Language)
	-- Is the client reciving the data from the server correctly?
	__C.pPrint('Debug', 'Character Data is loaded from the server, Toggle is set too: '.. __C.CharacterData.Character_ID)
	-- Display Loaded Language.
	__C.pPrint('Debug', _L("LanguageChanged"))
	-- Request perms
	TriggerServerEvent('AceRequest:Commands')
end)

------------------------------------------------------------------------------

RegisterNetEvent('__C:CharacterIsAlive')
AddEventHandler('__C:CharacterIsAlive', function() 
   	__C.pPrint('Debug', 'Character is ALIVE')
	--
	Wait(3333)
	TriggerServerEvent('skin:LoadSkin')
end)

------------------------------------------------------------------------------

RegisterNetEvent('__C:CharacterIsDead')
AddEventHandler('__C:CharacterIsDead', function() 
	__C.pPrint('Debug', 'Character is DEAD')
	--
	Wait(3333) -- Wait for the spawn manager
	--
	TriggerServerEvent('skin:LoadSkin')
	TriggerEvent('__C:CharacterIsAlive')
end)

------------------------------------------------------------------------------
-- FROM ESX - Death Script, Quite Useful.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local IsDead = false
		local player = PlayerId()
		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()
			if IsPedFatallyInjured(playerPed) and not IsDead then
				IsDead = true
				local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
				local killerServerId = NetworkGetPlayerIndexFromPed(killer)
				if killer ~= playerPed and killerServerId ~= nil and NetworkIsPlayerActive(killerServerId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
				else
					PlayerKilled()
				end
				-- Adding wait to not repeat call the reskin of the revived ped from spawn manager.
				Wait(10000)
			elseif not IsPedFatallyInjured(playerPed) then
				IsDead = false
			end
		end
	end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance     = GetDistanceBetweenCoords(victimCoords, killerCoords, true)
	local data = {
		victimCoords = { x = __C.NumDecimal(victimCoords.x, 1), y = __C.NumDecimal(victimCoords.y, 1), z = __C.NumDecimal(victimCoords.z, 1) },
		killerCoords = { x = __C.NumDecimal(killerCoords.x, 1), y = __C.NumDecimal(killerCoords.y, 1), z = __C.NumDecimal(killerCoords.z, 1) },

		killedByPlayer = true,
		deathCause     = killerWeapon,
		distance       = __C.NumDecimal(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}
	TriggerEvent('__C:CharacterIsDead')
end

function PlayerKilled()
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(PlayerPedId())
	local data = {
		victimCoords = { x = __C.NumDecimal(victimCoords.x, 1), y = __C.NumDecimal(victimCoords.y, 1), z = __C.NumDecimal(victimCoords.z, 1) },

		killedByPlayer = false,
		deathCause     = GetPedCauseOfDeath(playerPed)
	}
	TriggerEvent('__C:CharacterIsDead')
end
