------------------------------------------------------------------------------
--@Node
_sql = List:New()
---

--[[
===============================================================================
NOTES:

This table should never be called/iterated over as it handles the functions that
keep the game nd database in sync.

The functions are to be called Server side only and represent the volitile data
that is consistantly changing or may be out of sync since their last save.
===============================================================================
]]--

--@local id for async store & Store Query
local SaveData = -1
MySQL.Async.store("UPDATE `characters` SET `Coords` = @Coords, `Inventory` = @Inventory WHERE `Character_ID` = @Character_ID;", function(id) SaveData = id end)

--@local id for async store & Store Query
--local SaveData = -1
--MySQL.Async.store("UPDATE `characters` SET `Coords` = @Coords, `Inventory` = @Inventory WHERE `Character_ID` = @Character_ID;", function(id) SaveData = id end)

--- Save Single User/Character
--@source
--@callback
function _sql:SaveUser(src, cb)
	-- Get the _data store of that character..
	local data = _data:GetPlayerData(src)
	-- Insert Statement to update character row with information here.
	MySQL.Async.insert(SaveData, { 
		['@Coords'] = data.Coords, ['@Inventory'] = data.Inventory, ['@Character_ID'] = data.Character_ID
	}, function(r)
		--
		if cb then
			cb()
		end
	end)
	--
end

--- Save ALL Users/Characters
--@callback
function _sql:SaveData(cb)
	local players = GetPlayers()
	-- For every active player src/id do..
	for i, _ in ipairs(players) do
		-- Get the _data store of that character..
		local data = _data:GetPlayerData(players[i])	
		-- Insert Statement to update character row with information here.
		MySQL.Async.insert(SaveData, { 
			['@Coords'] = data.Coords, ['@Inventory'] = data.Inventory, ['@Character_ID'] = data.Character_ID
		}, function(r)
			-- These will all be completed prior to cb being run.
		end)
	end
	-- upon the entire loop of saving/pasing data to the DB via a stored query, run the cb passed.
	if cb then
		cb()
	end
end

--- On User Connection.
--@source
function _sql:UserConnected(source)
	local src = source
	local Steam_ID, FiveM_ID, Discord_ID, IP_Address = _server:IDs(src)
	--
	if FiveM_ID then
		MySQL.Async.fetchScalar('SELECT `FiveM_ID` FROM users WHERE `FiveM_ID` = @FiveM_ID LIMIT 1;', {['@FiveM_ID'] = FiveM_ID}, 
		function(r)
			if (r ~= nil) then
				-- Update their steam, discord if they do not exist in the db and their ip address upon every login.
				MySQL.Async.execute('UPDATE users SET `Steam_ID` = IFNULL(`Steam_ID`,@Steam_ID), `Discord_ID` = IFNULL(`Discord_ID`,@Discord_ID), `IP_Address` = @IP_Address, `Last_Login` = current_timestamp() WHERE `FiveM_ID` = @FiveM_ID;', {FiveM_ID = FiveM_ID, Steam_ID = Steam_ID, Discord_ID = Discord_ID, IP_Address = IP_Address}, 
				function(r)
					-- User Found and Updated, Now ...

					--
				end)
			else
				-- Create user info to add to the db if they dont already exist.
				local User = {Steam_ID = Steam_ID, FiveM_ID = FiveM_ID, Discord_ID = Discord_ID, IP_Address = IP_Address, Group = Config.Group, Ban_Status = 0, Language_Key = Config.Language}
				MySQL.Async.execute('INSERT INTO users (`Steam_ID`, `FiveM_ID`, `Discord_ID`, `Group`, `Language_Key`, `Ban_Status`, `IP_Address`) VALUES (@Steam_ID, @FiveM_ID, @Discord_ID, @Group, @Language_Key, @Ban_Status, @IP_Address);', {Steam_ID = User.Steam_ID, FiveM_ID = User.FiveM_ID, Discord_ID = User.Discord_ID, Group = User.Group, Language_Key = User.Language_Key, Ban_Status = User.Ban_Status, IP_Address = User.IP_Address}, 
				function(r)
					-- New User Created, Now ...

					--
				end)
			end
		end)
	else
		DropPlayer(src, 'Your FiveM_ID could not be found, This is extremely odd...')
	end
end
--========================================================================================================================================================--
-- EACH TABLE WITHIN THE DB HAS ITS OWN SET OF FUNCTIONS TO ACCESS OR CHANGE DATA WITHIN SAID DATABASE IS CONTAINED WITH THIS DOCUMENT.
--========================================================================================================================================================--

------------------------------------------------------------------------------
--- USERS TABLE
------------------------------------------------------------------------------

--- Get - `Language_Key` from the users FiveM_ID
--@FiveM_ID
function _sql:DBGetLanguageKey(FiveM_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Language_Key` FROM users WHERE `FiveM_ID` = @FiveM_ID LIMIT 1;', {['@FiveM_ID'] = FiveM_ID},
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

--- Set - Prefered locale or `Language_Key` for the users FiveM_ID
--@FiveM_ID
function _sql:DBSetLanguageKey(Language_Key, FiveM_ID, cb)
	local Language_Key = Language_Key
	MySQL.Async.execute('UPDATE users SET `Language_Key` = @Language_Key WHERE `FiveM_ID` = @FiveM_ID;', {['@Language_Key'] = Language_Key, ['@FiveM_ID'] = FiveM_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end

--- Get - `Group` from the users FiveM_ID identifier
--@FiveM_ID
function _sql:DBGetAceGroup(FiveM_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Group` FROM users WHERE `FiveM_ID` = @FiveM_ID LIMIT 1;', {['@FiveM_ID'] = FiveM_ID},
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

--- Get - `Ban_Status` from the users FiveM_ID identifier
--@FiveM_ID
function _sql:DBGetBanStatus(FiveM_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Ban_Status` FROM users WHERE `FiveM_ID` = @FiveM_ID LIMIT 1;', {['@FiveM_ID'] = FiveM_ID},
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

--- Set - `Ban_Status` = TRUE from the users FiveM_ID identifier
--@FiveM_ID
function _sql:DBSetBanned(FiveM_ID, cb)
	MySQL.Async.execute('UPDATE users SET `Ban_Status` = 0 WHERE `FiveM_ID` = @FiveM_ID LIMIT 1;', {['@FiveM_ID'] = FiveM_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end

--- Set - `Ban_Status` = FALSE from the users FiveM_ID identifier
--@FiveM_ID
function _sql:DBSetUnBanned(FiveM_ID, cb)
	MySQL.Async.execute('UPDATE users SET `Ban_Status` = 1 WHERE `FiveM_ID` = @FiveM_ID LIMIT 1;', {['@FiveM_ID'] = FiveM_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end

------------------------------------------------------------------------------
--- CHARACTERS TABLE
------------------------------------------------------------------------------

--- Get - Info on the characters owned to prefill the multicharacter selection
--@FiveM_ID
function _sql:DBGetCharacters(FiveM_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT DISTINCT `Character_ID`, `First_Name`, `Last_Name`, `Created`, `Status` FROM characters WHERE `FiveM_ID` = @FiveM_ID LIMIT 100;', {['@FiveM_ID'] = FiveM_ID },
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

--- Get - # of characters owned = FALSE
--@FiveM_ID
function _sql:DBGetCharacterCount(FiveM_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT COUNT(`FiveM_ID`) AS "Count" FROM characters WHERE `FiveM_ID` = @FiveM_ID;', {['@FiveM_ID'] = FiveM_ID}, 
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
	-- Always return a value.
	if result == nil then
		result = 0 
	end
	--
    return result
end

--- Get - The entire ROW of data from Characters table where the Character_ID is the character id.
--@FiveM_ID
function _sql:DBGetCharacterRow(Character_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT * FROM characters WHERE `Character_ID` = @Character_ID LIMIT 1;', {['@Character_ID'] = Character_ID},
	function(data)
        result = data[1]
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

--- Get - All `Character_ID` that are currently marked as `Active` IS TRUE
function _sql:DBGetActiveCharacters(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT `Character_ID` FROM characters WHERE `Active` IS TRUE', {},
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

--- Get - The `Active` = TRUE `Character_ID` from the FiveM_ID identifier
--@FiveM_ID
function _sql:DBGetActiveCharacter(FiveM_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Character_ID` FROM characters WHERE `Active` IS TRUE AND `FiveM_ID` = @FiveM_ID' , {['@FiveM_ID'] = FiveM_ID}, 
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

--- SET - The `Active` = FALSE `Character_ID` from the FiveM_ID identifier
--@`Character_ID`
function _sql:DBSetCharacterInActive(Character_ID, cb)
	MySQL.Async.execute('UPDATE characters SET `Active` = FALSE WHERE `Character_ID` = @Character_ID', {['@Character_ID'] = Character_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end

--- SET - The `Active` = TRUE `Character_ID` from the FiveM_ID identifier
--@`Character_ID`
function _sql:DBSetCharacterActive(Character_ID, cb)
	MySQL.Async.execute('UPDATE characters SET `Active` = TRUE WHERE `Character_ID` = @Character_ID', {['@Character_ID'] = Character_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end

-- Should the Server crash, this one is to reset all Active Characters Just incasethe Active Column is used to data identify users/characters in data pulls.
function _sql:DBResetActiveCharacters()
	MySQL.ready(function ()
		MySQL.Sync.execute('UPDATE characters SET `Active` = FALSE;')
	end)
end


function _sql:DBGetWantedCharacters(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Character_ID` FROM characters WHERE `Wanted` IS TRUE', {},
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

function _sql:DBSetCharacterWanted(Character_ID, cb)
	MySQL.Async.execute('UPDATE characters SET `Wanted` IS TRUE WHERE `Character_ID` = @Character_ID', {['@Character_ID'] = Character_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end

function _sql:DBSetCharacterUnWanted(Character_ID, cb)
	MySQL.Async.execute('UPDATE characters SET `Wanted` IS FALSE WHERE `Character_ID` = @Character_ID', {['@Character_ID'] = Character_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end

--- Get - The `City_ID` from the `Character_ID`
--@`Character_ID`
function _sql:DBGetCityIdFromCharacter(Character_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `City_ID` FROM characters WHERE `Character_ID` = @Character_ID LIMIT 1;', {['@Character_ID'] = Character_ID},
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

--- Get - The `Character_ID` from the `City_ID`
--@`City_ID`
function _sql:DBGetCharacterFromCityId(City_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Character_ID` FROM characters WHERE `City_ID` = @City_ID LIMIT 1;', {['@City_ID'] = City_ID}, 
	function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
    return result
end

--- Get - The `Coords` from the `Character_ID`
--@`Character_ID`
function _sql:DBGetCharacterCoords(Character_ID, cb)
    local IsBusy = true
    local result = nil
	MySQL.Async.fetchScalar('SELECT `Coords` FROM characters WHERE `Character_ID` = @Character_ID LIMIT 1;', {['@Character_ID'] = Character_ID},
	function(data)
		if data then
			result = json.decode(data)
			IsBusy = false
		end
	end)
	while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
	return result
end

--- SET - The `Coords` from the `Character_ID`
--@`Character_ID`
--@Table of coords. {x=32.2,y=etc}
--cb if any.
function _sql:DBSetCharacterCoords(Character_ID, Vector3, cb)
	local Coords = json.encode(Vector3)
	MySQL.Async.execute('UPDATE characters SET `Coords` = @Coords WHERE `Character_ID` = @Character_ID;', {['@Coords'] = Coords, ['@Character_ID'] = Character_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end

--- Get - The `Appearance` from the `Character_ID`
--@`Character_ID`
--cb if any.
function _sql:DBGetCharacterAppearance(Character_ID, cb)
    local IsBusy = true
    local result = nil
	MySQL.Async.fetchScalar('SELECT `Appearance` FROM characters WHERE `Character_ID` = @Character_ID;', {['@Character_ID'] = Character_ID},
	function(data)
		if data then
			result = json.decode(data)
			IsBusy = false
		end
	end)
	while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
	return result
end

--- SET - The `Appearance` from the `Character_ID`
--@`Character_ID`
--@style - TABLE VALUE
--cb if any.
function _sql:DBSetCharacterAppearance(Character_ID, style, cb)
	local Appearance = json.encode(style)
	MySQL.Async.execute('UPDATE characters SET `Appearance` = @Appearance WHERE `Character_ID` = @Character_ID;', {['@Appearance'] = Appearance, ['@Character_ID'] = Character_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end

--- GET - The `Inventory` from the `Character_ID`
--@`Character_ID`
function _sql:DBGetCharacterInventory(Character_ID, cb)
    local IsBusy = true
    local result = nil
	MySQL.Async.fetchScalar('SELECT `Inventory` FROM characters WHERE `Character_ID` = @Character_ID;', {['@Character_ID'] = Character_ID},
	function(data)
		if data then
			result = json.decode(data)
			IsBusy = false
		end
	end)
	while IsBusy do
        Wait(0)
    end
	if cb ~= nil then
		cb()
	end
	return result
end

--- SET - The `Inventory` from the `Character_ID`
--@`Character_ID`
function _sql:DBSetCharacterInventory(Character_ID, inv, cb)
	local Style = json.encode(inv)
	MySQL.Async.execute('UPDATE characters SET `Inventory` = @Inventory WHERE `Character_ID` = @Character_ID;', {['@Inventory'] = Inventory, ['@Character_ID'] = Character_ID},
	function(data)
		if data then
			--
		end
		if cb ~= nil then
			cb()
		end
	end)
end