------------------------------------------------------------------------------
--@Node
_animation = List:New()
---

--[[
===============================================================================
NOTES:

This table should never be called/iterated over as it handles the functions that
store and generate the animation events and event handlers for the useage within
other sources/scripts.

===============================================================================
]]--

--- Add Animations.
------ Command Registration Encapsulation.
--@IsCommand - Boolean T/F
--@CommandName - str
--@CommandDescription - str
--@CommandControlerType - str
--@CommandDefaultKey - str
------
--@EventName
--@Directory
--@Animation
function _animation:AnimRegister(IsCommand, CommandName, CommandDescription, CommandControlerType, CommandDefaultKey, EventName, Directory, Animation)
	-- Generate the event name as per the prefix.
	local Event = 'Anim:%s':format(EventName)

	RegisterNetEvent(Event)
	AddEventHandler(Event, function(Bool, Ped)
		--	localize the Ped variable incase it is not passed.
		local function GetPed(Ped) 
			if Ped == nil then 
				Ped = GetPlayerPed(-1) 
				return Ped
			else 
				return Ped 
			end 	 
		end 
		--
		local ped = GetPed(Ped)
		local dict = Directory
		local anim = Animation
		--
		RequestAnimDict(dict) -- request the animaiton directory
		Wait(150)
		--
		if Bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then --if not playing the animation already
			TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false) -- play the animaiton
			RemoveAnimDict(dict)  -- unload the dict to lessen ram useage.
		else
			ClearPedTasks(ped)
			RemoveAnimDict(dict)  -- unload the dict to lessen ram useage.
		end
	end)
	---
	if IsCommand then
		RegisterCommand('+'..CommandName..'', function() TriggerEvent(Event, true, GetPlayerPed(-1)) end, false)
		RegisterCommand('-'..CommandName..'', function() TriggerEvent(Event, false, GetPlayerPed(-1)) end, false) 
		RegisterKeyMapping('+'..CommandName..'', CommandDescription, CommandControlerType, CommandDefaultKey)
	end
end