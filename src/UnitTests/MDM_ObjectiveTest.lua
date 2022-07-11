MDM_ObjectiveTest = {}

function MDM_ObjectiveTest.UnitTest()
  local cnt = 0
  local m = MDM_Mission:new({title = "test"})
  local o1 = MDM_MockObjective:new({mission = m, ttl = 1})

  local o2 = MDM_MockObjective:new({mission = m, ttl = 1})
  o2:OnObjectiveStart(function() cnt = cnt+1 end)

  m:AddObjective(o1)
  m:AddObjective(o2)

  m:Start()
  m:Update()
  m:Update()
  m:Update()

  if cnt == 0 then
    error("cnt should be > 0")
  end

  m:Stop()
end
