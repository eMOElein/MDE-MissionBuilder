MDM_Feature_Test = {}

function MDM_Feature_Test.UnitTest()
  local m = MDM_Mission:new({title = "Director Testmission"})

  local o1 = MDM_MockObjective:new({mission = m, ttl = 1})
  MDM_Mission.AddObjective(m,o1)

  local updated, enabled, disabled
  local director = MDM_Feature:new(m)

  director.Enable = function(self) enabled = true  end
  director.Update = function(self) updated = true end
  director.Disable = function(self) disabled = true end


  MDM_FeatureUtils.EnableOnObjectiveStart(director,o1)
  MDM_FeatureUtils.DisableOnObjectiveStop(director,o1)

  m:Start()
  m:Update()
  if not enabled then error("enabled should be set") end
  if disabled then error("disabled shoud not be set") end
  m:Update()
  m:Update()
  if not disabled then error("disabled should be set") end
end
