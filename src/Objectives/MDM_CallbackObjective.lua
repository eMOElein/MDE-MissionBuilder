--- Exexutes a given callback on each update cycle and succeeds the objective if the callback returns true.
MDM_CallbackObjective = {}
MDM_CallbackObjective = MDM_Objective:class()

function MDM_CallbackObjective:new (args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if not args.callback then
    error("callback not set",2)
  end

  objective.callback = args.callback
  return objective
end

function MDM_CallbackObjective.Update(self)
  MDM_Objective.Update(self)

  local result = self.callback()
  if result then
    self:Succeed()
  end
end

function MDM_CallbackObjective.UnitTest()
  local mission = MDM_Mission:new({
    title = "m"
  })

  local obj = MDM_CallbackObjective:new({
    mission = mission,
    callback = function()  return true end
  })

  local obj2 = MDM_CallbackObjective:new({
    mission = mission,
    callback = function()  return true end
  })

  mission:AddObjective(obj)
  mission:AddObjective(obj2)


  mission:Start()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
end
