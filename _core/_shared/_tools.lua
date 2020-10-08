-----------------------------------------------------------------------------------------------------
--	TOOLBOX FUNCTIONS
-----------------------------------------------------------------------------------------------------

function Clone(t)
	local u = setmetatable({}, getmetatable(t))
	for i,v in pairs(t) do
		u[i] = v
	end
	return u
end

function Merge(t,u)
	local r = clone(t)
	for i, v in pairs(u) do
		r[i] = v
	end
	return r
end

function Rearrange(p,t)
	local r = clone(t)
	for i,v in pairs(p) do
		r[v] = t[i]
		r[i] = nil
	end
	return r
end

-----------------------------------------------------------------------------------------------------
--	GENERIC DATA STRUCTURES WITH METAMETHODS
-----------------------------------------------------------------------------------------------------
---	Basic Table :: New, Get, Set, Add, Remove and Size.
--	LIST

List = {}
List.__index = List

function List:New()
	return setmetatable({ __size = 0}, self)
end

function List:Get(i)
	return self[i]
end

function List:Set(i, e)
	return self[i] = e
end

function List:Add(i, e)
	table.insert(self, i, e)
	self.__size = self.__size + 1
end

function List:Remove(i)
	table.remove(self, i)
	self.__size = self.__size - 1
end

function List:Size()
	return self.__size
end

---------------------------------------------------------------------------------------------------
---	Node Table :: New, First, Last, Set, Next, Previous, AddFirst, AddLast, AddBefore, AddAfter, Remove and Size.
--	NODE LIST

NList = {}
NList.__index = NList

function NList:New()
	local l = {head = {}, tail = {}, __size = 0}
	l.head.__next, l.tail.__prev = l.tail, l.head
	return setmetatable(l, self)
end

function NList:First()
	if self.__size > 0 then
		return self.head.__next
	else
		return nil
	end
end

function NList:Last()
	if self.__size > 0 then
		return self.tail.__prev
	else
		return nil
	end
end

function NList:Set(node, elem)
	node.value = elem
end

function NList:Next()
	if node.__next ~= self.tail then
		return node.__next
	else
		return nil
	end
end

function NList:Prev(node)
	if node.__prev ~= self.head then
		return node.__prev
	else
		return nil
	end
end

function NList:AddFirst(elem)
	local node = { __prev = self.head, value = elem, __next = self.head.__next }
	node.__next.__prev = node
	self.head.__next = node
	self.__size = self.__size + 1
end

function NList:AddLast(elem)
	local node = { __prev = self.tail.__prev, value = elem, __next = self.tail }
	node.__prev.__next = node
	self.tail.__prev = node
	self.__size = self.__size + 1
end

function NList:AddBefore(node, elem)
	local new_node = { __prev = node.__prev, value = elem, __next = node }
	new_node.__prev.__next = new_node
	node.__prev = new_node
	self.__size = self.__size + 1
end

function NList:AddAfter(node, elem)
	local new_node = { __prev = node, value = elem, __next = node.__next }
	node.__next = new_node
	new_node.__next.__prev = new_node
	self.__size = self.__size + 1
end

function NList:Remove(node)
	node.__prev.__next = node.__next
	node.__next.__prev = node.__prev
	self.__size = self.__size - 1
end

function NList:Size()
	return self.__size
end

------------------------------------------------------------------------------------------------------------------
---	Node based Dequeue :: New, AddFirst, AddLast, GetFirst, GetLast, First, Last and Size.
--	NODE DEQUEUE (Double Ended Queue Handler)

NDequeue = {}
NDequeue.__index = NDequeue

function NDequeue:New()
	local l = {nlist = NList:New()}
	return setmetatable{l, self}
end

function NDequeue:AddFirst(elem)
	self.nlist:AddFirst(elem)
end

function NDequeue:AddLast(elem)
	self.nlist:AddLast(elem)
end

function NDequeue:GetFirst()
	local result = self.nlist:First()
	if result then
		self.nlist:Remove(result)
		return result.value
	else
		return nil
	end
end

function NDequeue:GetLast()
	local result = self.nlist:Last()
	if result then
		self.nlist:Remove(result)
		return result.value
	else
		return nil
	end
end

function NDequeue:First()
	return self.nlist:First().value
end

function NDequeue:Last()
	return self.nlist:Last().value
end

function NDequeue:Size()
	return self.nlist:Size()
end

------------------------------------------------------------------------------------------------------------------
---	Node Based Tree :: New, Root, AddRoot, IsRoot, Parent, Left, Right, InsertLeft, InsertRight, IsInternal, IsExternal, Replace, Remove and Size.
--	NODE TREE (Similar to Binary)

NTree = {}
NTree.__index = NTree

function NTree:New()
	return setmetatable({ __size = 0}, self)
end

function NTree:Root()
	return self.__root
end

function NTree:AddRoot(elem)
	self.__root = {value = elem}
	self.__size = 1
	return self.__root
end

function NTree:Parent(node)
	return node.__parent
end

function NTree:Left(node)
	return node.__left
end

function NTree:Right(node)
	return node.__right
end

function NTree:InsertLeft(node, elem)
	local new_node = {value = elem, __parent = node}
	node.__left = new_node
	self.size = self.__size + 1
	return new_node
end

function NTree:InsertRight(node, elem)
	local new_node = {value = elem, __parent = node}
	node.__right = new_node
	self.size = self.__size + 1
	return new_node
end

function NTree:IsInternal(node)
	return node.__left or node.__right
end

function NTree:IsExternal(node)
	return not self:IsInternal(node)
end

function NTree:IsRoot(node)
	return (node == self.__root)
end

function NTree:Replace(node, elem)
	node.value = elem
end

function NTree:Remove(node)
	local parent = node.__parent
	local left_child = (parent.__left == node)
	if left_child then
		parent.__left = nil
	else
		parent.__right = nil
	end
	self.__size = self.__size - 1
end

function NTree:Size()
	return self.__size
end

------------------------------------------------------------------------------------------------------------------
---	Array Based Tree :: New, Root, AddRoot, IsRoot, Parent, Left, Right, InsertLeft, InsertRight, IsInternal, IsExternal, SubSize, Replace, Remove and Size.
--	ARRAY TREE (Similar to Binary)

ATree = {}
ATree.__index = ATree

function ATree:New()
	return setmetatable({__size = 0}, self)
end

function ATree:Root()
	return self.[1]
end

function ATree:AddRoot(elem)
	self[1] = elem
	self.__size = 1
end

function ATree:Parent(node)
	return math.floor(node/2)
end

function ATree:Left(node)
	return 2 * node
end

function ATree:Right(node)
	return 2 * node + 1
end

function ATree:InsertLeft(node, elem)
	self[2*node] = elem
	self.__size = self.__size + 1
end

function ATree:InsertLeft(node, elem)
	self[2*node+1] = elem
	self.__size = self.__size + 1
end

function ATree:IsInternal(node)
	return (self[2*node] ~= nil or self[2*node+1] ~= nil)
end

function ATree:IsExternal(node)
	return not self:IsInternal(node)
end

function ATree:IsRoot(node)
	return (node == 1)
end

function ATree:Replace(node, elem)
	self[node] = elem
end

function ATree:Subsize(node)
	if self[node] == nil then
		return 0
	else
		return 1 + self:Subsize(self:Left(node))
				 + self:Subsize(self:Right(node))
	end
end

function ATree:Rem(node)
	local count = self:Subsize(node)
	self[node] = nil
	self.__size = self.__size - count
end

function ATree:Size()
	return self.__size
end