MDM_CarTheftMissionConfigurations = {}
MDM_CarTheftMissionConfigurations.carThefts = {
  {
    cars = {
      {carId = "houston_coupe_bv01", position = MDM_Vector:new(-634.09747,162.89331,3.1696486), direction = MDM_Vector:new(-0.99951327,-0.026886089,-0.015828749)},
      {carId = "houston_coupe_bv01", position = MDM_Vector:new(-634.09747,162.89331,3.1696486), direction = MDM_Vector:new(-0.99951327,-0.026886089,-0.015828749)}
    },
    destination = {
      position = MDM_Vector:new(1,2,3),
      radius = 25
    },
    bodyguards = {
      {npcId = "18187434932497386406", position = MDM_Vector:new(-619.09271,128.21832,4.2791152), direction = MDM_Vector:new(0.54440945,0.83881962,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-619.09271,128.21832,4.2791152), direction = MDM_Vector:new(0.54440945,0.83881962,0), battleArchetype = "archetype_triggerman_base_pol"}
    }
  },
  {
  }
}

function MDM_CarTheftMissionConfigurations:new(config)
  local mission = MDM_Mission:new( {
    title = "Car Theft"
  })

  local cars = {}

  for _,c in ipairs(config.cars) do
    cars = MDM_Car:new(c)
  end

  local onVehicleEntered = function() end

  local function onMissionStart()
  end

  MDM_Core.callbackSystem.RegisterCallback("on_player_vehicle_entered", onVehicleEntered)
  MDM_Core.callbackSystem.UnregisterCallback("on_player_vehicle_entered",onVehicleEntered)

  local objective_500_SpawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = cars
  })

  local objective_1000 = MDM_CallbackObjective:new({
    mission = mission,
    title = "Steal the cars",
    callback = function() return MDM_CarTheftMissionConfigurations._EvaluateSuccess(cars, config.destination.position, config.destination.radius) end
  })

  MDM_Mission.OnMissionStart(mission,onMissionStart)

  MDM_Mission.AddObjective(mission,objective_500_SpawnerObjective)
  MDM_Mission.AddObjective(mission,objective_1000)
  return mission
end

function MDM_CarTheftMissionConfigurations._EvaluateSuccess(cars, targetPosition, targetRadius)
  for _,c in cars do
    if not c:IsSpawned() then
      return false
    end

    local distance = MDM_Vector.DistanceToPoint(targetPosition,c:GetGameEntity():GetPos())
    if distance < targetRadius then
      return false
    end
  end

  return true
end

function MDM_CarTheftMissionConfigurations.UnitTest()
  local config = MDM_List.GetRandom(MDM_CarTheftMissionConfigurations.carThefts)
  MDM_CarTheftMissionConfigurations:new(config)
end
