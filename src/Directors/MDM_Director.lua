MDM_Director = {}

local args = {
  mission = nil
}

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

  MDM_Utils.ForEach(self.onEnabledCallbacks,function(callback) callback() end)
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
    callback()
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

  self.onUpdateCallbacks:ForEach(function(callback) callback() end)
end

--@Overwrite
function MDM_Director.Destroy(self)
end

function MDM_Director.UnitTest()
  local m = MDM_Mission:new({title = "Director Testmission"})

  local o1 = MDM_MockObjective:new({mission = m, ttl = 1})
  MDM_Mission.AddObjective(m,o1)

  local updated, enabled, disabled
  local director = MDM_Director:new(m)

  director.Enable = function(self) enabled = true  end
  director.Update = function(self) updated = true end
  director.Disable = function(self) disabled = true end


  MDM_ActivatorUtils.EnableOnObjectiveStart(director,o1)
  MDM_ActivatorUtils.DisableOnObjectiveStop(director,o1)

  m:Start()
  m:Update()
  if not enabled then error("enabled should be set") end
  if disabled then error("disabled shoud not be set") end
  m:Update()
  m:Update()
  if not disabled then error("disabled should be set") end
end
