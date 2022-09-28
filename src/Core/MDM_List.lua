MDM_List = {}

--function MDM_List.CreateObject(class)
--  local object = {}
--  setmetatable(object,class)
--  class.__index = class
--  return object
--end

function MDM_List:new(table)
  local list =  {}
  setmetatable(list, self)
  self.__index = self

  if table then
    list:AddAll(table)
  end

  return list
end

function MDM_List.Add(self, element)
  if not element then
    error("element not set",2)
  end

  MDM_List.AddAll(self,{element})
  return self
end

function MDM_List.AddAll(self, elements)
  if not elements then
    error("elements not set",2)
  end

  for _,e in ipairs(elements) do
    table.insert(self,e)
  end

  return self
end

function MDM_List.Contains(self, object)
  for _,o in ipairs(self) do
    if o == object then
      return true
    end
  end
  return false
end

function MDM_List.ForEach(self, consumer)
  for _,e in ipairs(self) do
    consumer(e)
  end
end

function MDM_List.Get(self, index)
  for i,e in ipairs(self) do
    if i == index then
      return e
    end
  end
end

function MDM_List.IndexOf(self,object)
  for index,element in ipairs(self) do
    if element == object then
      return index
    end
  end
end

function MDM_List.Map(self, mapper)
  if not mapper then
    error("mapper not set",2)
  end

  local newList = MDM_List:new()

  for _,o in ipairs(self) do
    newList:Add(mapper(o))
  end

  return newList
end

function MDM_List.Remove(self,toRemove)
  local index = MDM_List.IndexOf(self,toRemove)
  if (index) then
    table.remove(self,index)
  end
end

function MDM_List.Size(self)
  return #self
end

function MDM_List.GetRandom(self)
  local count = #self

  local random = math.random(1,count)

  -- create 100 randoms as the first random numbers don't seem to be that random at all
  for i=1,100 do
    random = math.random(1,count)
  end

  return MDM_List.Get(self, random)
end
