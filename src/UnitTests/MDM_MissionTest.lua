MDM_MissionTest = {}

function MDM_MissionTest.UnitTest()
  local onMissionEndCalled = 0

  local  m = MDM_Mission:new({title = "Missiontest",
    onMissionEnd = function() onMissionEndCalled = onMissionEndCalled +1 end
  })

  local  o1 = MDM_MockObjective:new({mission = m})
  local  o2 = MDM_MockObjective:new({mission = m})

  m:AddObjective(o1)
  m:AddObjective(o2)


  m:OnMissionEnd(function() onMissionEndCalled = onMissionEndCalled +1 end)


  m:Start()
  m:Update()
  if not m:IsRunning() then error("mission sould still be running") end
  m:Update()
  m:Update()
  m:Update()
  m:Update()
  m:Update()
  m:Update()
  if m:IsRunning() then error("mission should not be running anymore") end

  m:OnMissionEnd(function() onMissionEndCalled = true end)

  m:Stop()

  if onMissionEndCalled ~= 2 then
    error("onMissionEnd should have been called 2 times")
  end
end
