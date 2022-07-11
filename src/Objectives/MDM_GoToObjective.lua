MDM_GoToObjective = {}

function MDM_GoToObjective:new(args)
  if not args.position then
    error("position not set",2)
  end

  local objective = MDM_Objective:new(args)
  objective.vector = args.position
  objective.radius = args.radius or 20
  objective:OnObjectiveStart(function() MDM_GoToObjective._OnObjectiveStart(objective) end)
  objective:OnObjectiveEnd(function() MDM_GoToObjective._OnObjectiveEnd(objective) end)
  objective:OnUpdate(function() MDM_GoToObjective._OnUpdate(objective) end)

  objective.area = MDM_Area.ForSphere({
    position = objective.vector,
    radius = objective.radius
  })

  return objective
end

function MDM_GoToObjective._OnObjectiveEnd(self)
  self.area:Hide()
  self.blip:Hide()
end

function MDM_GoToObjective._OnObjectiveStart(self)
  if not self.blip then
    self.blip = MDM_Blip.ForVector({vector = self.vector})
  end

  self.blip:Show()
  self.area:Show()
end

function MDM_GoToObjective._OnUpdate(self)
  if self.area:IsInside(MDM_PlayerUtils.GetPlayer():GetPos()) then
    self:Succeed()
  end
end

function MDM_GoToObjective.UnitTest()
  local vec = MDM_Utils.GetVector(-907.94,-160.41,2)

  local m = MDM_Mission:new({title = "Test"})
  local objective = MDM_GoToObjective:new({mission = m, position = vec})
  objective.title = "Objective 2"
  objective.task = "Go to the marked location"
  objective.description = "Blablabla"

  if not objective then
    error ("objective is nil" ,2)
  end

  if not objective.vector then
    error("objective vector is nil",2)
  end

  objective:Start()
end
