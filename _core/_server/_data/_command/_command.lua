------------------------------------------------------------------------------
--@Node
_command = List:New()
---

--[[
===============================================================================
NOTES:

This table should never be called/iterated over as it handles creation and ace
permission level  of commands for the server to control for the users.

===============================================================================
]]--

-- Cross Arms
_animation:AnimRegister(true, 'cross', 'Cross arms', 'keyboard', '1', 'CrossedArms', 'amb@world_human_hang_out_street@female_arms_crossed@base', 'base')
-- Hands Up
_animation:AnimRegister(true, 'handsup', 'Hands Up', 'keyboard', '2', 'HandsUp', 'missminuteman_1ig_2', 'handsup_enter')
-- Hold Arm
_animation:AnimRegister(true, 'holdarm', 'Hold arm', 'keyboard', '3', 'HoldArm', 'amb_world_human_hang_out_street_female_hold_arm_idle_b', 'anim@amb@nightclub@peds@')

