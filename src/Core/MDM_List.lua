MDM_List = {}

function MDM_List.Add(self, element)
  table.insert(self,element)
end

function MDM_List.AddAll(self, elements)
  for _,e in elements do
    MDM_List.Add(self,e)
  end
end

function MDM_List.Get(self, index)
  for i,e in ipairs(self) do
    if i == index then
      return e
    end
  end
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
