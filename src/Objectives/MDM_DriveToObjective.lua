MDM_DriveToObjective = {}

function MDM_DriveToObjective:new(args)
  if not args.position then
    error("position not set",2)
  end

  if not args.car then
    error("car not set",2)
  end

  local objective = MDM_Objective:new(args)

  objective.vector = args.position
  objective.radius = args.radius or 20
  objective.car = args.car
  objective.onFoot = true

  objective:OnObjectiveStart(MDM_DriveToObjective._OnObjectiveStart)
  objective:OnObjectiveEnd(MDM_DriveToObjective._OnObjectiveEnd)
  objective:OnUpdate(MDM_DriveToObjective._OnUpdate)


  objective.area = MDM_Area.ForSphere({
    position = objective.vector,
    radius = objective.radius
  })

  return objective
end

function MDM_DriveToObjective._OnObjectiveStart(self)
  if not self.blip then
    self.blip = MDM_Blip.ForVector({vector = self.vector})
  end

  self.blip:Show()
  self.area:Show()
end

function MDM_DriveToObjective._OnObjectiveEnd(self)
  self.area:Hide()
  self.blip:Hide()
end

function MDM_DriveToObjective._OnUpdate(self)
  local successful = MDM_DriveToObjective._IsSuccessful(self)

  if MDM_DriveToObjective._IsSuccessful(self) then
    self:Succeed()
  end
end

function MDM_DriveToObjective._IsSuccessful(self)
  if not self.area:IsInside(MDM_Utils.Player.GetPos()) then
    return false
  end

  if not MDM_Utils.Player.IsInCar() then
    return false
  end

  if not MDM_DriveToObjective._IsCorrectCar(self,self.car) then
    return false
  end

  return true
end

function MDM_DriveToObjective._IsCorrectCar(self)
  if self.car == nil and MDM_Utils.Player.IsInCar() then
    return true
  end

  if self.car:GetGameEntity() == MDM_Utils.Vehicle.GetPlayerCurrentVehicle() then
    return true
  end

  return false
end

function MDM_DriveToObjective.UnitTest()
  local vec = MDM_Utils.GetVector(-907.94,-160.41,2)

  local mission = MDM_Mission:new({title = "Test"})

  local objective = MDM_DriveToObjective:new({
    mission = mission,
    position = vec,
    car = MDM_Car:new({carId="1", position = MDM_Vector:new(0,0,0), direction = MDM_Vector:new(0,0,0)})
  })

  objective:Start()
  objective:Update()

end
