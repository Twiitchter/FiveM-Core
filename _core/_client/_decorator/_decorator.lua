------------------------------------------------------------------------------
--@Node
_decorator = List:New()

--[[
===============================================================================
NOTES:

This table should never be called/iterated over.
Contains and stores all listed decorators within scripts via a register and 
sorts them into tables to be found later with a loop like GET Function.

All decorators are automatically synced across the client scape as per R* code
and therefore are useful enough to be an independant node.

===============================================================================
]]--

---@Add stores for strings/names to find later for type management.
_decorator:Add(Float, {})
_decorator:Add(Bool, {})
_decorator:Add(Integer, {})

--- Register the Decor
--@str
--@int
function _decorator:DecorRegister(str, int)
    if type(int) == 'number' then
        local bool = DecorIsRegisteredAsType(str, int)
        if not bool then
            DecorRegister(str, int)
            if int == 1 then
                 table.insert(_decorator.Float, str)
            elseif int == 2 then 
                 table.insert(_decorator.Bool, str)
            elseif int == 3 then
                 table.insert(_decorator.Integer, str)
            end
        else
            _Shared:Print('Debug', 'Issue with '..str..'; Decor registration, its probably already registered. Type was '..int)
        end        
    else
        _Shared:Print('Debug', 'Number not passed for Decor Registration. Its invalid.')
    end

end

--- Set
--@Entity
--@str
--@int
--@value
function _decorator:DecorSet(entity, str, int, val)
    if type(int) == 'number' then
        if int == 1 then
            DecorSetFloat(entity, str, val) 
        elseif int == 2 then
            DecorSetBool(entity, str, val) 
        elseif int == 3 then
            DecorSetInt(entity, str, val)
        else
            _Shared:Print('Error', 'Decor not set because its not a float, bool or integer.')
        end       
    else 
        _Shared:Print('Error', 'Decor not set because the int was not a valid number')
    end
end

--- Get
--This one can be improved upon, another way to think of doing it would be to make a single table with the int value..

--@Entity
--@str
function _decorator:DecorGet(entity, str) 
    local exist = DecorExistOn(entity, str)
    local data = nil
    if type(str) == 'string' then
        if exist then
        -- CrossCheck what type it is prior to requesting the value.
            -- Find the str in the tables and return what int it should be,
            repeat
                for _,v in pairs(__C.Dec.Float) do
                    if v == str then
                        data = DecorGetFloat(entity, str) 
                        break
                    end
                end
                for _,v in pairs(__C.Dec.Bool) do 
                    if v == str then
                        data = DecorGetBool(entity, str) 
                        break
                    end
                end
                for _,v in pairs(__C.Dec.Integer) do 
                    if v == str then
                        data = DecorGetInt(entity, str) 
                        break
                    end
                end
            until data ~= nil
        end
    else
        _Shared:Print('Debug', 'No String Detected : "__C.Dec.Get".')
    end
    return data
end

