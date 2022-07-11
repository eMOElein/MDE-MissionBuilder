MDM_CallbackObjectiveTest = {}

function MDM_CallbackObjectiveTest.UnitTest()
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
