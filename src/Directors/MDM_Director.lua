MDM_Director = {}

function MDM_Director:class()
  local director = {}
  setmetatable(director, self)
  self.__index = self
  return director
end

function MDM_Director:new (args)
  local director = MDM_Director:class()

  if not args then
    error("args not set",2)
  end
 
  director.enabled = false
  director.onEnabledCallbacks = MDM_List:new()
  director.onDisabledCallbacks = MDM_List:new()
  director.onUpdateCallbacks = MDM_List:new()

  if args.onEnabled then
    director:OnEnabled(args.onEnabled)
  end

  if args.onDisabled then
    director:OnDisabled(args.onDisabled)
  end

  return director
end

function MDM_Director.Enable(self)
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

function MDM_Director.IsEnabled(self)
  return self.enabled
end

function MDM_Director.Disable(self)
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

function MDM_Director.OnDisabled(self,callback)
  self.onDisabledCallbacks:Add(callback)
end

function MDM_Director.OnEnabled(self,callback)
  self.onEnabledCallbacks:Add(callback)
end

function MDM_Director.OnUpdate(self,callback)
  self.onUpdateCallbacks:Add(callback)
end


function MDM_Director.Update(self)
  if not self:IsEnabled() then
    return
  end

  self.onUpdateCallbacks:ForEach(function(callback) callback(self) end)
end
