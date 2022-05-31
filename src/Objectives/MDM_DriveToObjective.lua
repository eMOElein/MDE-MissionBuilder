MDM_DriveToObjective = {}
MDM_DriveToObjective = MDM_Objective:class()

function MDM_DriveToObjective:new(args)
  if not args.position then
    error("position not set",2)
  end

  if not args.car then
    error("car not set",2)
  end

  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self


  objective.vector = args.position
  objective.radius = args.radius or 20
  objective.car = args.car
  objective.onFoot = true

  objective.area = MDM_Area.ForSphere({
    position = objective.vector,
    radius = objective.radius
  })

  objective.detector = MDM_EntityInCircleDetector:new({
    entity = MDM_PlayerUtils.GetPlayer(),
    position = objective.vector,
    radius = objective.radius
  })

  return objective
end

function MDM_DriveToObjective:PlayerDistanceToObjective(vector)
  local Distance = 0
  if game then
    Distance = getp():GetPos():DistanceToPoint(vector)
  end
  return Distance
end

function MDM_DriveToObjective.Start(self)
  MDM_Objective.Start(self)

  if not self.blip then
    self.blip = MDM_Blip.ForVector({vector = self.vector})
  end

  self.blip:Show()
  self.area:Show()
end

function MDM_DriveToObjective.Stop(self)
  self.area:Hide()
  self.blip:Hide()
  MDM_Objective.Stop(self)
end

function MDM_DriveToObjective.Update(self)
  MDM_Objective.Update(self)
  if not self.running then
    return
  end

  local successful = self:_IsSuccessful()

  if self:_IsSuccessful() then
    self:Succeed()
  end
end

function MDM_DriveToObjective._IsSuccessful(self)
  -- Don't continue if we are not in the destination area
  if not self.area:IsInside(MDM_Utils.Player.GetPos()) then
    return false
  end

  local playerInCar = MDM_Utils.Player.IsInCar()

  if not playerInCar then
    return
  end

  local correctCar = false
  correctCar = correctCar or self.car == nil and playerInCar
  correctCar = correctCar or self.car:GetGameEntity() == MDM_Utils.Vehicle.GetPlayerCurrentVehicle()

  return correctCar
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
