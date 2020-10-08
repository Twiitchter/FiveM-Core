------------------------------------------------------------------------------
--@Node
_client = List:New()
---
math.randomseed(_shared:ReturnGameSeed())

--[[
===============================================================================
NOTES:

This table should never be called/iterated over as it handles the data in and 
the client uses within the game, these can be booleans, flags or other import-
ant informaiton.

These do not include the decorators as they are handled within the _decorator
node.

===============================================================================
]]--

--	Character Loaded boolean and data from the server to populate the below.
_client:Add(client_loaded, false)
_client:Add(client_cashe, {})

function _client:SetClientStatus(bool)
	if type(bool) == 'boolean' then
		_client:Set(client_loaded, bool)
	else
		error(_shared:Print('Error',_shared:TransalteLocale(['not_boolean'])),2)
	end
end

-- Return the data.
function _client:GetClientStatus()
	return _client:Get(client_loaded)
end

--- To remove based on a new character selection, send {__size=0} as the data to replace it.
--@data/table from server
function _client:SetClientCashe(t)
	if type(t) == 'table' then
		_client:Set(client_cashe, t)
	else
		error(_shared:Print('Error',_shared:TransalteLocale(['not_table'])),2)
	end
end

-- Return the data.
function _client:GetClientCashe()
	return _client:Get(client_cashe)
end

RegisterNetEvent('_client:loaded')
AddEventHandler('_client:loaded', function(data)
	_client:SetClientCashe(data)
	-- Giving the client some time to recieve the data packet/table
	Wait(250)
	_client:ClientStarted()
end)


------------------------------------------------------------------------------
