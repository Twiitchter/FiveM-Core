-------------------------------------------------------------------------------
--@Node
_server = List:New()
---
math.randomseed(_shared:ReturnGameSeed())

--[[
===============================================================================
NOTES:

This table should never be called/iterated over.
Contains server side control fucntions that run in a structured manner.

To Add:
CRON / Scheduler

===============================================================================
]]--

-------------------------------------------------------------------------------
--	Status

_server:Add(running, false)

function _server:FrameworkStarted()
	self.running = true
end

function _server:FrameworkStopped()
	self.running = false
end

function _server:FrameworkStatus()
	return self.running
end

-------------------------------------------------------------------------------
--	User Handle - Joining;

function _server:UserConnecting(src)
	-- Add users dynamic server id to a table enable their datastore server side.
	if _data[src] == nil then
		_data:CreatePlayerData(src)
		-- 
		_sql:UserConnected(src)
	else
		DropPlayer(source, 'Your Server ID # was already used, This is extremely odd. Please reconnect.')
	end
end


-------------------------------------------------------------------------------
--	FUNCTIONS


--@source
function _server:ID(source)
	local src = source
	local license = nil
	for k,v in ipairs(GetPlayerIdentifiers(src)) do
		if string.match(v, "license:") then
			license = v
		end
	end
	return license
end

--@source
function _server:IDs(source)
	local src = source
	local steam, license, discord, ip = nil, nil, nil, nil
	for k,v in ipairs(GetPlayerIdentifiers(src)) do
		if string.match(v, "steam:") then
			steam = v
		elseif string.match(v, "license:") then
			license = v
		elseif string.match(v, "discord:") then
			discord = v
		elseif string.match(v, "ip:") then
			ip = v
		end
	end
	return steam, license, discord, ip
end


function _server:NumberGenerator(x, y)
	local u = 0 
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x +(math.random(math.randomseed(_shared.RandomSeed+u))*999999 %y))
    else
        return math.floor((math.random(math.randomseed(_shared.RandomSeed+u))*100))
    end
end

function _server:SeedGenerator()
	local RandomNumber = nil
	local Length = 8
	local Temp = {}

	if RandomNumber == nil then	
		
		for i = 1, Length do
			if math.random(0,9) > 4 then
				table.insert(Temp, math.random(0,9))
			else
				table.insert(Temp, math.random(0,9))
			end
		end
		
		RandomNumber = tostring(table.concat(Temp))
	end

	local seed = __C.NumDecimal(RandomNumber + _server:NumberGenerator(00000000,99999999), 0)

	_shared:Set(RandomSeed, seed)
end

--Server issued seed to work with.
function _server:SeedSync(ms)
	SetTimeout(ms, function()
		Citizen.CreateThread(function()
			_server:SeedGenerator()
			_server:SeedSync()
		end)
	end)
end

--Server to DB routine.
function _server:DatabaseSync(ms)
	local function Async()
		_sql:SaveData()
		--
		SetTimeout(ms, Async)
	end
	SetTimeout(ms, Async)
end