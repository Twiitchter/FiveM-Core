--====================================================================================--
--
--	THIS WILL ENABLE COLON CALLS WITHIN FUNCTIONS AS SIMPLE AS _C:FUNCITONNAME WITHIN
--	THE SERVER, CLIENT OR SHARED SCRIPTS, SO LONG AS THE FUNCTIONS ARE USED WITHIN
--	THEIR RESPECTIVE FEILDS OF OPERATION.
--	TO DO - ENABLE FUNCITON FUCKING WITH PCALL PRIOR TO EXECUTING TO CHECK WHAT 
--	BRANCH OF THE TREE THEY ARE IN BEFORE RUNNING.
--
--	Rules to follow while working with this framework:
--	1: All functions within nodes need to be uniquely named.
--	2: All OOP methods will be done within the _scripts.
--	3: All front end code will use the prefix: "_C:<FUNCTION NAME>"
--	4: All back end code (marked with _FOLDER/_FILE.lua) will call the node required: "_shared:<FUNCTION NAME>"
--	5: All required data sources should be secured within the self table level and only modifiable via OOP.
--	6: All functions within the core, should have type and error handles built in if parseing data to them.
--
--====================================================================================--
--- Globals
--@NodeTree
_C = NTree:New()

--[[	Connect the nodes to the main tree	]]--

-- Designate the Shred NODE to be the Parent of both the Client and Server.
_C:AddRoot(_shared)

-- Add the Client Node to the tree
_C:InsertLeft(_shared, _client)

-- Add the Server Node to the tree.
_C:InsertRight(_shared, _server)

-- Client Node is parent of the _decor and _animation Nodes.
_C:InsertLeft(_client, _decorator)
_C:InsertRIght(_client, _animation)

-- Server Node is parent of the _data and _sql Nodes.
_C:InsertLeft(_server, _data)
_C:InsertRight(_server, _sql)

-- Data is the parent of commands
_C:InsertLeft(_data, _command)


---@Call the core into other scripts.
------------------------------------------------------------------------------
exports('_C', function(cb)
	cb = _C
	return cb
end)
------------------------------------------------------------------------------