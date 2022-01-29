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
  director.onEnabledCallbacks = {}
  director.onDisabledCallbacks = {}

  if args.mission then
    args.mission:AddDirector(director)
  end

  return director
end

function MDM_Director.Enable(self)
  if self.enabled then
    return
  end

  self.enabled = true
  MDM_Utils.ForEach(self.onEnabledCallbacks,function(callback) callback() end)
end

function MDM_Director.IsEnabled(self)
  return self.enabled
end

function MDM_Director.Disable(self)
  self.enabled = false

  for i,callback in ipairs(self.onDisabledCallbacks) do
    callback()
  end
  --  MDM_Utils.CallbacksWith1Param(self.onDisabledCallbacks,nil)
end

function MDM_Director.OnDisabled(self,callbacks)
  MDM_Utils.AddAll(self.onDisabledCallbacks,callbacks)
end

function MDM_Director.OnEnabled(self,callbacks)
  MDM_Utils.AddAll(self.onEnabledCallbacks,callbacks)
end

--@Overwrite
function MDM_Director.Update(self)
  return self:IsEnabled()
end

--@Overwrite
function MDM_Director.Destroy(self)
end

function MDM_Director.UnitTest()
  print("---------------MDM_Director Unit Test")
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
