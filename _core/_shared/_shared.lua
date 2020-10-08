------------------------------------------------------------------------------
--@Node
_shared = List:New()
---

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

------------------------------------------------------------------------------
--	SEED GENERATOR

_shared:Add(RandomSeed, GetGameTimer())

function _shared:ReturnGameSeed()
	return _shared.RandomSeed
end

math.randomseed(_shared:ReturnGameSeed())

------------------------------------------------------------------------------
--	LOCALE SUPPORT

locale = Config.Locale

--@locale[en][key]
function _shared:TransalteLocale(k)
	local found = Locale[locale][k]
	if found ~= nil then
		return Locale[locale][k]
	else
		return Locale['en']['missing_locale']
	end
end

--@locale
function _shared:SetLocale(new_locale)
	locale = new_locale
end

--@locale[en][key]
function _shared:L_(k)
	if type(k) == 'string' then
		return _shared:TransalteLocale(k)
	else
		error(_shared:Print('Error',_shared:TransalteLocale(['not_string'])),2)
	end
end

-- _C:L_('string_as_key') will print 'Value as String'

------------------------------------------------------------------------------
--	MISC FUNCS

--- Function replacement if returning value
--@type :: as string
function _shared:PrintType(prefix)
	-- Style for Alerts in Console
	if (prefix == 'Alert') then
		prefix = tostring('	^0[^1Alert^0] :: ')
	end
	-- Style for Errors in Console
	if (prefix == 'Error') then
		prefix = tostring('	^0[^3Error^0] :: ')
	end
	-- Style for Debugging in Console
	if (prefix == 'Debug') then
		prefix = tostring('	^0[^5Debug^0] :: ')
	end
	-- Style for Start in Console
	if (prefix == 'Start') then
		prefix = tostring('	^0[^2Start^0] :: ')
	end
	-- Style for Saved in Console
	if (prefix == 'Saved') then
		prefix = tostring('	^0[^2Saved^0] :: ')
	end
	-- Style for anything else...
	if (prefix == nil) then
		prefix = tostring('	^0[^2UNDEFINED^0] :: ')
	end 
	-- Return the sent information
	return prefix	
end

--- Function replacement if returning value
--@text :: as string
function _shared:PrintText(str)
	if (str ~= nil) then
		str = tostring(str)
	else
		str = tostring('Error No Call Back | Wrap The Text In : " " ')
	end	return str
end

--- Function replacement if returning value
--@prefix of print
--@string to print with it
function _shared:Print(prefix, str)
	local val = print(_shared:PrintType(prefix),_shared:PrintText(str))
	return val
end

--- Function replacement if returning value
--@func,params
function _shared:func(...)
	local arg = {...}
	local status, val = _shared:err(table.unpack(arg))
	-- Return the value of the function, not the status
	return val
end

--- Wrapper for xpcall to debug.
--@func and params as array.
function _shared:err(func, ...)
	local arg = {...}
	return xpcall(
		-- function wrapper to pass function arguments
		function()
			return _shared:func(table.unpack(arg))
		end,
		-- error function
		function(err)
			return _shared:_error(err)
		end
	)
end

--- Error Printing
--@err generated by lua.
function _shared:error(err)
	if type(err) == 'string' then
		--print(err) -- Not required as running via cfx event.
		_shared:Print('Error', err)
		print(debug.traceback(_,2))
	else
		--print("	[ERROR] :: _error() :: Unable to define type(err) as it was not a string. [Data] :: "..err..".")  -- Not required as running via cfx event.
		_shared:Print('Error', 'Unable to define type(err) as it was not a string. [Data] ::')
		print(debug.traceback(_,2))
	end
end

--- Numbers into decimals.
--@number :: to be converted.
--@decimals  :: how many? 2,3?
function _shared:DecimalPlaces(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

--- Table dump and contents.
--@table 
--@# to begin dump. Leave blank for entire t dump.
function _shared:TableDump(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. _shared:TableDump(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

--- https://stackoverflow.com/questions/656199/search-for-an-item-in-a-lua-list
--- Table search to find x value with additional search params.
--@Table to search, 
--@value to find, 
--@if the value is a table/search it, 
--@any metatable referance, 
--@key in both valuetable and metadata table, 
--@if the value is a bool in the table.
function _shared:TableFind (t, val, recursive, metatables, keys, returnBool)
    if (type(t) ~= "table") then
        return nil
    end

    local checked = {}
    local _findInTable
    local _checkValue
    _checkValue(v)
        if (not checked[v]) then
            if (v == val) then
                return v
            end
            if (recursive and type(v) == "table") then
                local r = _findInTable(v)
                if (r ~= nil) then
                    return r
                end
            end
            if (metatables) then
                local r = _checkValue(getmetatable(v))
                if (r ~= nil) then
                    return r
                end
            end
            checked[v] = true
        end
        return nil
    end
    _findInTable(t)
        for k,v in pairs(t) do
            local r = _checkValue(t, v)
            if (r ~= nil) then
                return r
            end
            if (keys) then
                r = _checkValue(t, k)
                if (r ~= nil) then
                    return r
                end
            end
        end
        return nil
    end

    local r = _findInTable(t)
    if (returnBool) then
        return r ~= nil
    end
    return r
end

--- RetVal Random Number
function _shared:RandNumber() 
	local Rand = math.random(0,9)
	return Rand
end

--- RetVal Random Letter
function _shared:RandLetter()
	local Rand = string.char(math.random(97, 122))
	return Rand
end
	
--- RetVal Random Number or Letter
function _shared:RandCharacter()
	local Rand = nil
	local RandLet =_shared:RandLetter()
	local RandNum =_shared:RandNumber()
	
	if math.random (0,9) > 4 then
		Rand = RandNum
	else 
		Rand = RandLet
	end

	return Rand
end

--- RetVal Random Numbers as a string.
--@length of string.
function _shared:RandNumberString(Length)
	local RandomString = nil
	local Length = Length
	local Temp = {}

	if RandomString == nil then	
		
		for i = 1, Length do
			if math.random(0,9) > 4 then
				table.insert(Temp,_shared:RandNumber())
			else
				table.insert(Temp,_shared:RandNumber())
			end
		end
		
		RandomString = tostring(table.concat(Temp))
	end

	return RandomString
end

--- RetVal Random Letters as a string.
--@length of string.
function _shared:RandLetterString(Length)
	local RandomString = nil
	local Length = Length
	local Temp = {}

	if RandomString == nil then	
		
		for i = 1, Length do
			if math.random(0,9) > 4 then
				table.insert(Temp,_shared:RandLetter())
			else
				table.insert(Temp,_shared:RandLetter())
			end
		end
		
		RandomString = tostring(table.concat(Temp))
	end

	return RandomString
end

--- RetVal Random Numbers or Letters as a string.
--@length of string.
function _shared:RandCharacterString(Length)
	local RandomString = nil
	local Length = Length
	local Temp = {}

	if RandomString == nil then	
		
		for i = 1, Length do
			if math.random(0,9) > 4 then
				table.insert(Temp,_shared:RandCharacter())
			else
				table.insert(Temp,_shared:RandCharacter())
			end
		end
		
		RandomString = tostring(table.concat(Temp))
	end

	return RandomString
end

