------------------------------------------------------------------------------
AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	--
	_C:Print('Start', _C:L_('server_onResourceStart'))
	-- Run function..
	OnStart()
	--
end)

------------------------------------------------------------------------------
-- Queued funcitons to begin on start up.

function OnStart()
	-- Wrapped in OnReady, to reset all active characters to false on failover
	_C:DBResetActiveCaracters()
	-- Time in ms to sync server and database data. 2 minutes.
	_C:DatabaseSync(120000)
	-- Time in ms to generate a new seed. 0.5 seconds.
	_C:SeedSync(500)
	-- Return self.running = true
	_C:FrameworkStarted()
end

------------------------------------------------------------------------------
-- Server cleanup on client disconnection.

AddEventHandler('playerDropped', function()
	local src = source
	local data = _C:GetPlayerData(src)
	--
	if data then
		_C:SaveUser(data, function()
			_C:RemovePlayerData(src)
			_C:Print('Saved', _C:L_('server_disconnection_saved'))
		end)
		_C:DBSetCharacterInActive(data.Character_ID)
	end
end)

RegisterNetEvent('Core:UserConnecting')
AddEventHandler('Core:UserConnecting')
	local src = source
	_C:UserConnecting(src)
end

RegisterNetEvent('Core:UpdatePlayerCoords')
AddEventHandler('Core:UpdatePlayerCoords', function(data)
	local src = source
	_C:UpdatePlayerCoords(src, data)
end)