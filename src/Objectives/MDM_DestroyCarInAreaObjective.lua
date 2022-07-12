MDM_DestroyCarInAreaObjective = {}

function MDM_DestroyCarInAreaObjective:new(args)
  if not args.car then
    error("car not set",2)
  end

  if not args.position then
    error("position not set",2)
  end

  local objective = MDM_Objective:new(args)

  objective.pos = args.position
  objective.radius = args.radius or 20
  objective.blip = MDM_Blip.ForVector({vector = objective.pos})
  objective.blip:Hide()
  --objective.blip = MDM_ObjectivePosition:new(objective.title..":Testblip",objective.pos,objective.radius)

  objective.area = MDM_Area.ForSphere({
    position = objective.pos,
    radius = objective.radius
  })

  objective.car = args.car

  objective:OnObjectiveStart(MDM_DestroyCarInAreaObjective._OnObjectiveStart)
  objective:OnObjectiveEnd(MDM_DestroyCarInAreaObjective._OnObjectiveEnd)
  objective:OnUpdate(MDM_DestroyCarInAreaObjective._OnUpdate)

  return objective
end

function MDM_DestroyCarInAreaObjective._OnObjectiveStart(self)
  if self.blip then
    self.blip:Show()
  end
end

function MDM_DestroyCarInAreaObjective._OnObjectiveEnd(self)
  if self.blip then
    self.blip:Hide()
  end
end

function MDM_DestroyCarInAreaObjective._OnUpdate(self)
  local damage = not self.car:CanDrive()
  local position = self.area:IsInside(self.car:GetPos())

  if damage and position then
    self:Succeed()
  end

  if damage and not position then
    self:Fail()
  end

end

function MDM_DestroyCarInAreaObjective.UnitTest()
  local mission = MDM_Mission:new({title = "Test"})
  local car = MDM_Car:new("smith_v12",MDM_Utils.GetVector(-180.402725,-897.841553,2.624493),MDM_Utils.GetVector(-0.021050,0.999603,-0.018721))


  local obj = MDM_DestroyCarInAreaObjective:new({mission = mission, car = car , position = car:GetPos(), radius = 5})
end
