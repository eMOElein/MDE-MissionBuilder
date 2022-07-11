MDM_Property = {}

function MDM_Property:new()
  local property = {}
  setmetatable(property, self)
  self.__index = self

  property.onPropertyChangedCallbacks = MDM_List:new()

  return property
end

function MDM_Property.Get(self)
  return self.value
end

function MDM_Property.Set(self, value)
  if self.value ~= value then
    local old = self.value
    self.value = value
    self.onPropertyChangedCallbacks:ForEach(
      function(callback) callback({
        source = self,
        old = old,
        new = self.value
      })
      end)
  end
end

function MDM_Property.onPropertyChanged(self, callback)
  self.onPropertyChangedCallbacks:Add(callback)
end

function MDM_Property.removeOnPropertyChanged(self, callback)
  self.onPropertyChangedCallbacks:Remove(callback)
end
