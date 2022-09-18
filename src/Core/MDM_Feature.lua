MDM_Feature = {}

function MDM_Feature:class()
  local feature = {}
  setmetatable(feature, self)
  self.__index = self
  return feature
end

function MDM_Feature:new (args)
  local feature = MDM_Feature:class()

  if not args then
    error("args not set",2)
  end
 
  feature.enabled = false
  feature.onEnabledCallbacks = MDM_List:new()
  feature.onDisabledCallbacks = MDM_List:new()
  feature.onUpdateCallbacks = MDM_List:new()

  if args.onEnabled then
    feature:OnEnabled(args.onEnabled)
  end

  if args.onDisabled then
    feature:OnDisabled(args.onDisabled)
  end

  return feature
end

function MDM_Feature.Enable(self)
  if self.enabled then
    return
  end

  self.enabled = true

  if not self._onUpdate then
    self._onUpdate = function(args) self:Update() end
    MDM_Core.callbackSystem.RegisterCallback("on_update", self._onUpdate)
  end

  MDM_Utils.ForEach(self.onEnabledCallbacks,function(callback) callback(self) end)
end

function MDM_Feature.IsEnabled(self)
  return self.enabled
end

function MDM_Feature.Disable(self)
  if not self:IsEnabled() then
    return
  end

  self.enabled = false

  if self._onUpdate then
    MDM_Core.callbackSystem.UnregisterCallback("on_update", self._onUpdate)
    self._onUpdate = nil
  end

  for i,callback in ipairs(self.onDisabledCallbacks) do
    callback(self)
  end

end

function MDM_Feature.OnDisabled(self,callback)
  self.onDisabledCallbacks:Add(callback)
end

function MDM_Feature.OnEnabled(self,callback)
  self.onEnabledCallbacks:Add(callback)
end

function MDM_Feature.OnUpdate(self,callback)
  self.onUpdateCallbacks:Add(callback)
end


function MDM_Feature.Update(self)
  if not self:IsEnabled() then
    return
  end

  self.onUpdateCallbacks:ForEach(function(callback) callback(self) end)
end
