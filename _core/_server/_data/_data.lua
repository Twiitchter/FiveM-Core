------------------------------------------------------------------------------
--@Node
_data = List:New()
---
math.randomseed(_shared:ReturnGameSeed())

--[[
===============================================================================
NOTES:

This table should never be called/iterated over as it handles the data in and 
out of the store per character connected, their dynamic server id as issued
upon connection.

What data is kept within it is up to the people who run the show see fit.
Generally Identifiers, Dynamic Data types, and things that regularly change
should be stored within it and provide auth as its server side info.

===============================================================================
]]--

--- Add the Character/Players table to the data table.
--@source
function _data:CreatePlayerData(source)
	_data:Add(source, List:New())
end

function _data:LoadPlayerData(source, id)
	-- Get selected character row and user information.
	local char = _sql:DBGetCharacterRow(id)
	local lang = _sql:DBGetLanguageKey(char.FiveM_ID)
	local ace = _sql:DBGetAceGroup(char.FiveM_ID)
	-- combine tabled data
	char = Merge(char, lang)
	char = Merge(char, ace)
	-- call the existing list created when the user joined.
	local data = _data:Get(source)
	-- Set the values.
	for k,v in iparis(char) do
		data:Add(k,v)
	end
	-- Set users ace perms based on the db.
	ExecuteCommand(('add_principal identifier.%s group.%s'):format(char.FiveM_ID, char.Group))
	-- Send the tabled data to the user.
	TriggerClientEvent('_client:loaded', source, data)
end

--- Return the Character/Players K containing a table of user data.
--@source
function _data:GetPlayerData(source)
	return _data:Get(source)
end

--- Set Data with Key/Vale to Character/Player
--@source
--@key
--@value
function _data:SetPlayerData(source, k ,v)
	local data = _data:Get(source)
	--Set the values.
	data:Set(k,v)
end

--- Add Data with Key/Vale to Character/Player
--@source
--@key
--@value
function _data:AddPlayerData(source, k ,v)
	local data = _data:Get(source)
	--Set the values.
	data:Add(k,v)
end

--- Clean table
--@source
function _data:RemovePlayerData(source)
	_data:Remove(source)
end

function _data:GetDataSize()
	return _data:Size()
end

------------------------------------------------------------------------------

function _data:UpdatePlayerCoords(src, data)
	local data = _data:Get(src)
	local k = Coords
	local v = data
	data:Set(k,v)
end

