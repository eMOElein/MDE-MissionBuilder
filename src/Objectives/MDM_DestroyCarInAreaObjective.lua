MDM_DestroyCarInAreaObjective = {}
MDM_DestroyCarInAreaObjective = MDM_Objective:class()

function MDM_DestroyCarInAreaObjective:new(args)
  if not args.car then
    error("car not set",2)
  end

  if not args.position then
    error("vector not set",2)
  end

  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  objective.pos = args.position
  objective.radius = args.radius or 20
  objective.blip = MDM_ObjectivePosition:new(objective.title..":Testblip",objective.pos,objective.radius)

  objective.car = args.car
  objective.positiondetector = MDM_EntityInCircleDetector:new({entity = objective.car, position = objective.pos, radius = objective.radius})
  objective.damagedetector = MDM_CarDamageDetector:new({car = objective.car, threshold = 100, flagMotorDamage = false, flagCarDamage = true})

  return objective
end

function MDM_DestroyCarInAreaObjective.Start(self)
  MDM_Objective.Start(self)

  if self.blip then
    self.blip:AddToMap()
  end
end

function MDM_DestroyCarInAreaObjective.Stop(self)
  if self.blip then
    self.blip:RemoveFromMap()
  end
  MDM_Objective.Stop(self)
end

function MDM_DestroyCarInAreaObjective.Update(self)
  MDM_Objective.Update(self)

  local damage = self.damagedetector:Test()
  local position = self.positiondetector:Test()

  if damage and position then
    self:Succeed()
  end

  if damage and not position then
    self:Fail()
  end

end

function MDM_DestroyCarInAreaObjective.UnitTest()
  print("---------------MDM_DestroyCarInAreaObjective:UnitTest")
  local mission = MDM_Mission:new({title = "Test"})
  local car = MDM_Car:new("smith_v12",MDM_Utils.GetVector(-180.402725,-897.841553,2.624493),MDM_Utils.GetVector(-0.021050,0.999603,-0.018721))


  local obj = MDM_DestroyCarInAreaObjective:new({mission = mission, car = car , position = car:GetPos(), radius = 5})
end
