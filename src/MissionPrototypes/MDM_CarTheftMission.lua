MDM_CarTheftMission = {}

function MDM_CarTheftMission:new(config)
  if not config.destination then
    error("destination not set",2)
  end

  if not config.destination.position then
    error("destination.position not set",2)
  end

  if not config.destination.radius then
    error("destination.radius not set",2)
  end

  local mission = MDM_Mission:new( {
    title = config.title or "Car Theft"
  })

  mission.cars = MDM_List:new()
  mission.bodyguards = MDM_List:new()
  mission.bodyguardsDetectionRange = config.bodyguardsDetectionRange or 20

  mission.destinationArea = MDM_Area.ForSphere({
    position = config.destination.position,
    radius = config.destination.radius
  })

  mission.onUpdate = function() MDM_CarTheftMission._OnUpdate(mission) end

  for _,c in ipairs(config.cars) do
    mission.cars:Add(MDM_Car:new(c))
  end

  if config.bodyguards then
    for _,b in ipairs(config.bodyguards) do
      mission.bodyguards:Add(MDM_NPC:new(b))
    end
  end

  mission.onVehicleEntered = function (args) MDM_CarTheftMission._OnVehicleEntered(mission,args) end
  mission.onVehicleLeft = function (args) MDM_CarTheftMission._OnVehicleLeft(mission,args) end

  local assets = MDM_List:new()
  assets:AddAll(mission.cars)
  assets:AddAll(mission.bodyguards)

  mission:AddAssets(assets)
  ---------------------------------------------------------
  ---------------------- Callbacks- -----------------------
  ---------------------------------------------------------
  mission:OnMissionEnd(function()
    MDM_CarTheftMission._OnMissionEnd(mission)
  end)

  mission:OnMissionStart(function()
    MDM_CarTheftMission._OnMissionStart(mission)
  end)
  ---------------------------------------------------------
  ---------------------- Objectives -----------------------
  ---------------------------------------------------------
  local objective_500_SpawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = assets
  })

  mission:AddObjective(objective_500_SpawnerObjective)
  mission:AddObjective(MDM_CarTheftMission._StealObjective(mission))
  return mission
end

function MDM_CarTheftMission._IsCarDelivered(self , car)
  local distance = MDM_Vector.DistanceToPoint(self.destinationArea.position,car:GetPosition())
  return distance <= self.destinationArea.radius
end

function MDM_CarTheftMission._EvaluateSuccess(mission)
  for _,c in ipairs(mission.cars) do
    if not c:IsSpawned() or not c:GetGameEntity() then
      return false
    end

    if not MDM_CarTheftMission._IsCarDelivered(mission,c) then
      return false
    end
  end

  return true
end

function MDM_CarTheftMission._StealObjective(mission)
  local cars = MDM_List:new()

  for _,c in ipairs(mission.cars) do
    if not MDM_CarTheftMission._IsCarDelivered(mission,c) then
      cars:Add(c)
    end
  end

  if #cars == 0 then
    return nil
  end

  local objective = MDM_GetInCarObjective:new({
    mission = mission,
    title = "Steal the cars",
    cars = cars
  })


  objective:OnObjectiveEnd(function()
    local car = MDM_CarTheftMission._GetPlayerCar(mission)
    if car ~= nil  then
      mission:AddObjective(MDM_CarTheftMission._DeliverObjective(mission, car))
    end
  end)

  -- Check if a car is not in the target area anymore and add it back to the objective cars
  objective:OnUpdate(function()
    for _,c in ipairs(mission.cars) do
      if not MDM_CarTheftMission._IsCarInTargetArea(mission,c) and not objective.cars:Contains(c) then
        objective:AddCar(c)
      end
    end
  end)

  return objective
end

function MDM_CarTheftMission._DeliverObjective(mission,car)
  if not car then
    error("car not set",2)
  end

  local objective = MDM_DriveToObjective:new({
    mission = mission,
    title = "Deliver the car",
    car = car,
    position = mission.destinationArea.position,
    radius = mission.destinationArea.radius,
    onObjectiveStart = function()
      MDM_Core.callbackSystem.RegisterCallback("on_player_vehicle_left",mission.onVehicleLeft)
      MDM_CarTheftMission._BodyuguardAttack(mission)
    end,
    onObjectiveEnd = function()
      MDM_Core.callbackSystem.UnregisterCallback("on_player_vehicle_left",mission.onVehicleLeft)
      local objective =  MDM_CarTheftMission._StealObjective(mission)
      if objective then
        mission:AddObjective(objective) end
    end
  })

  return objective
end

function MDM_CarTheftMission._GetPlayerCar(mission)
  local gameEntity = MDM_Utils.Vehicle.GetPlayerCurrentVehicle()
  for _,car in ipairs(mission.cars) do
    if car:GetGameEntity() == gameEntity then
      return car
    end
  end

  return nil
end

function MDM_CarTheftMission._IsCarInTargetArea(mission,car)
  return mission.destinationArea:IsInside(car:GetPosition())
end

function MDM_CarTheftMission._OnMissionEnd(mission)
  MDM_Core.callbackSystem.UnregisterCallback("on_update",mission.onUpdate)
end

function MDM_CarTheftMission._OnMissionStart(mission)
  MDM_Core.callbackSystem.RegisterCallback("on_update",mission.onUpdate)
end

function MDM_CarTheftMission._OnUpdate(mission)
  for _,car in ipairs(mission.cars) do
    if car:IsSpawned() and not car:CanDrive() then
      mission:Fail("The car is too damaged")
      return
    end
  end

  if MDM_CarTheftMission._EvaluateSuccess(mission) then
    mission:Succeed()
  end
end

function MDM_CarTheftMission._OnVehicleEntered(mission,args)

end

function MDM_CarTheftMission._BodyuguardAttack(mission)
  if not mission.bodyguards or #mission.bodyguards == 0 then
    return
  end

  local attack = false

  for _,car in ipairs(mission.cars) do
    if car:GetGameEntity() == MDM_Utils.Vehicle.GetPlayerCurrentVehicle() then
      attack = true
    end
  end

  if not attack then
    return
  end

  for _,bodyguard in ipairs(mission.bodyguards) do
    if bodyguard:GetGameEntity():GetSeePlayer() then
      bodyguard:AttackPlayer()
    end
  end

end

function MDM_CarTheftMission._OnVehicleLeft(mission,args)
  local isMissionCar = false

  for _,car in ipairs(mission.cars) do
    if car:GetGameEntity() == args.gameEntity then
      isMissionCar = true
    end
  end

  if not isMissionCar then
    return
  end

  local currentObjective = mission:GetCurrentObjective()

  if not currentObjective then
    return
  end

  currentObjective:Succeed()
end

function MDM_CarTheftMission.UnitTest()
  MDM_List:new(MDM_CarTheftMissionConfigurations.carThefts):ForEach(function(carTheft)
    local mission = MDM_CarTheftMission:new(carTheft)

    MDM_CarTheftMission._EvaluateSuccess(mission, mission.cars,mission.destinationArea.position,mission.destinationArea.radius)

    mission:Start()

    MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})

    mission:Stop()
  end)

end
