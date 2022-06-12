MDM_FrankMissions = {}

MDM_FrankMissions.assets = {
  M1_Test = {
    frank = {npcId = "3294909036990047762", position = MDM_Vector:new(-923.15936,-245.3199,2.7747059), direction = MDM_Vector:new(-0.99971199,0.023997903,0), initialAnimation = "hero_nw_calm_idle_fidget_rain_a"},
    compoundAllies = {
      {npcId = "18187434932497386406", position = MDM_Vector:new(-379.7298,480.71155,3.8913431), direction = MDM_Vector:new(0.99649781,0.083619177,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-373.87668,476.0126,3.8754921), direction = MDM_Vector:new(0.99515307,0.098338425,0), battleArchetype = "archetype_triggerman_base_pol"}
    },
    compoundEnemies = {
      -- shotgunners
      {npcId = "2624519215596331124", position = MDM_Vector:new(-358.44565,486.82159,3.8884668), direction = MDM_Vector:new(-0.89483333,-0.4464004,0)},
      {npcId = "2624519215596331124", position = MDM_Vector:new(-351.21591,477.30969,3.8884668), direction = MDM_Vector:new(-0.98277205,0.18482189,0)},
      -- machinegunners
      {npcId = "8866396308432925397", position = MDM_Vector:new(-355.13467,475.11234,3.8884668), direction = MDM_Vector:new(-0.99063963,0.13650352,0)},
      {npcId = "8866396308432925397", position = MDM_Vector:new(-355.77206,484.4603,3.8884668), direction = MDM_Vector:new(-0.94384283,-0.33039472,0)},
      -- Colt
      {npcId = "18187434932497386406", position = MDM_Vector:new(-352.32721,486.45822,3.8884668), direction = MDM_Vector:new(-0.96145165,-0.2749736,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-352.32721,486.45822,3.8884668), direction = MDM_Vector:new(-0.96145165,-0.2749736,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-348.13992,477.85095,3.8884668), direction = MDM_Vector:new(-0.9883216,-0.15238188,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-348.13992,477.85095,3.8884668), direction = MDM_Vector:new(-0.9883216,-0.15238188,0), battleArchetype = "archetype_triggerman_base_pol"}
    },
    compoundCars = {
      {carId = "shubert_e_six", position = MDM_Vector:new(-359.34601,487.93124,4.0679979), direction = MDM_Vector:new(-0.60395682,-0.79701132,-0.0030418932)},
      {carId = "bolt_delivery", position = MDM_Vector:new(-357.19742,472.45547,4.0772705), direction = MDM_Vector:new(0.21165815,-0.97730517,-0.0087135416)},
      {carId = "bolt_model_b", position = MDM_Vector:new(-361.50089,471.33133,4.0729499), direction = MDM_Vector:new(0.23215644,-0.97265708,0.0064760428)},
      {carId = "bolt_cooler", position = MDM_Vector:new(-367.00232,469.95941,4.1986623), direction = MDM_Vector:new(0.20321761,-0.97911143,-0.0065877307)},
      {carId = "shubert_e_six", position = MDM_Vector:new(-379.47083,482.23831,4.0621428), direction = MDM_Vector:new(0.7494995,-0.66195208,-0.0083699515)},
      {carId = "bolt_delivery", position = MDM_Vector:new(-372.71484,474.78781,4.064146), direction = MDM_Vector:new(0.40910947,0.91245103,-0.0079058176)}

    },
    mission_truck = {carId = "bolt_truck", position = MDM_Vector:new(-354.36224,480.75027,4.3814688), direction = MDM_Vector:new(-0.95393491,0.29989064,-0.0085874526)},

  }
}

function MDM_FrankMissions.M1_Test()
  local assets = MDM_FrankMissions.assets.M1_Test

  local frank = MDM_NPC:newFriend(assets.frank)
  local mission_truck = MDM_Car:new(assets.mission_truck)
  local compoundEnemies = MDM_List:new(assets.compoundEnemies):Map(function(ally) return MDM_NPC:newFriend(ally) end)
  local compoundAllies =   MDM_List:new(assets.compoundAllies):Map(function(ally) return MDM_NPC:newFriend(ally) end)
  local compoundCars = MDM_Car.ForConfigs(assets.compoundCars)

  local assets = MDM_List:new()
  assets:AddAll(compoundEnemies)
  assets:AddAll(compoundAllies)
  assets:AddAll(compoundCars)
  assets:Add(frank)
  assets:Add(mission_truck)

  local mission = MDM_Mission:new({
    title = "Frank Test 1",
    assets = assets
  })

  local objective_0000_SpawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = assets
  })
  local objective_1000_SpeakToFrank = MDM_SpeakToObjective:new({
    mission = mission,
    npc = frank
  })

  local objective_2000_GoToCompound = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Vector:new(-379.7298,480.71155,3.8913431),
    radius = 80
  })

  local objective_3000_KillCompoundEnemies = MDM_KillTargetsObjective:new({
    mission = mission,
    targets = compoundEnemies,
    onObjectiveStart = function()
      MDM_List:new(compoundEnemies):ForEach(function(enemie) enemie:MakeEnemy() end)
      MDM_ShootoutMission._AttackRoundRobin(compoundAllies,compoundEnemies)
    end
  })

  local objective_4000_GetInTrucks = MDM_GetInCarObjective:new({
    mission = mission,
    car = mission_truck
  })

  local objective_5000_DeliverTruck = MDM_DriveToObjective:new({
    mission = mission,
    position = MDM_Locations.SALIERIS_BAR_GARAGE_FRONTDOOR,
    car = mission_truck
  })


  mission:AddObjectives({
    objective_0000_SpawnerObjective,
    objective_1000_SpeakToFrank,
    objective_2000_GoToCompound,
    objective_3000_KillCompoundEnemies,
    objective_4000_GetInTrucks,
    objective_5000_DeliverTruck
  })
  --------------------------------------
  --------------Directors---------------
  --------------------------------------


  return mission
end

MDM_UnitTest.RegisterTest({name = "MDM_FrankMissions.M1_Test", func = MDM_FrankMissions.M1_Test})
