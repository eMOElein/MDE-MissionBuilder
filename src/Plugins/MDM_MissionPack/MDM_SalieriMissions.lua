MDM_SalieriMissions = {}
MDM_SalieriMissions.assets = {
  M1_BackyardTrouble = {
    donSalieri = {npcId = "17047363682458951493", position = MDM_Vector:new(-928.22968,-248.62529,2.7746923), direction = MDM_Vector:new(-0.34469545,0.9387145,0), initialAnimation = "hero_nw_calm_idle_fidget_rain_a"},
    cars = {
      {carId = "bolt_model_b", position = MDM_Vector:new(-905.04358,-229.26549,2.9038675), direction = MDM_Vector:new(-0.0071616364,-0.99995255,0.0066532223)},
      {carId="shubert_six", position = MDM_Vector:new(-670.4494,-22.954449,3.3371413), direction = MDM_Vector:new(-0.32917213,-0.94427019,-0.0002347008)}
    },
    enemies = {
      {npcId="13604348442857333985",position=MDM_Vector:new(-683.10767,-15.692556,3.2338758),direction=MDM_Vector:new(0.6981827,-0.71591961,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="13604348442857333985",position=MDM_Vector:new(-681.30603,-24.531549,3.2201567),direction=MDM_Vector:new(0.41589907,0.90941077,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="13604348442857333985",position=MDM_Vector:new(-684.01532,-21.848021,3.352128),direction=MDM_Vector:new(0.9708972,0.23949677,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="13604348442857333985",position=MDM_Vector:new(-678.65411,-14.920903,3.2161522),direction=MDM_Vector:new(-0.31570739,-0.94885659,0), battleArchetype = "archetype_triggerman_base_pol"}
    }
  },
  M2_WhiskyWhopper = {
    truck = {carId = "bolt_truck", position = MDM_Vector:new(-903.20862,-692.28986,3.88734), direction = MDM_Vector:new(-0.96103084,-0.27643755,-0.0014791912)},
    compoundCars = {
      {carId = "bolt_pickup", position = MDM_Vector:new(-893.90149,-745.11334,3.8092734), direction = MDM_Vector:new(0.72964358,0.68382657,0.0011832109)},
      {carId = "bolt_pickup", position = MDM_Vector:new(-898.30536,-751.86047,3.3934219), direction = MDM_Vector:new(-0.74674648,-0.66510487,-0.0023534386)},
      {carId = "bolt_pickup", position = MDM_Vector:new(-910.31396,-759.52026,3.8393802), direction = MDM_Vector:new(-0.62445927,0.7810356,0.0058287559)},
      {carId = "bolt_delivery", position = MDM_Vector:new(-908.26495,-740.39478,3.7478696), direction = MDM_Vector:new(-0.67092276,-0.74139231,-0.014146926)},
      {carId = "bolt_delivery", position = MDM_Vector:new(-912.86163,-761.5907,3.7518097), direction = MDM_Vector:new(-0.56397796,0.8257395,-0.0091202371)},
      {carId = "bolt_delivery", position = MDM_Vector:new(-911.30109,-725.61053,3.7402503), direction = MDM_Vector:new(-0.0078235492,0.99992293,-0.0096368138)},
      {carId = "culver_airmaster", position = MDM_Vector:new(-910.1109,-735.37524,3.777604), direction = MDM_Vector:new(-0.99961263,0.02770582,-0.0026414304)},
      {carId = "shubert_e_six", position = MDM_Vector:new(-925.31885,-742.49475,3.6757897), direction = MDM_Vector:new(0.31558034,-0.94889647,-0.0022272428)},
      {carId = "shubert_e_six", position = MDM_Vector:new(-930.09686,-691.34521,3.614205), direction = MDM_Vector:new(-0.57875252,0.81542385,-0.011381509)},
      {carId = "shubert_e_six", position = MDM_Vector:new(-919.50708,-711.02771,3.7303878), direction = MDM_Vector:new(0.61881775,0.78550607,-0.0067021623)},
      {carId = "lassiter_v16", position = MDM_Vector:new(-913.54755,-745.96582,3.7011901), direction = MDM_Vector:new(-0.90786278,-0.4191981,0.0076475153)},
      -- destination area cars
      {carId = "shubert_six", position = MDM_Vector:new(-1533.4163,-408.33746,2.3574228), direction = MDM_Vector:new(0.91624779,-0.40051475,0.0088161454)},
      {carId = "bolt_delivery", position = MDM_Vector:new(-1509.3436,-376.85468,3.6807584), direction = MDM_Vector:new(0.91617841,-0.40075919,0.0031141266)},
    },
    compoundEnemies = {
      -- We set the battleArchetype to "archetype_triggerman_base_pol" as we do not want the triggermen to constantly spam us with molotovs.
      {npcId="18187434932497386406", position=MDM_Vector:new(-918.92773,-706.95239,3.146647), direction=MDM_Vector:new(0.43737864,-0.89927745,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="18187434932497386406", position=MDM_Vector:new(-921.99921,-711.38287,3.1582365), direction=MDM_Vector:new(0.70571977,-0.70849109,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="18187434932497386406", position=MDM_Vector:new(-928.05493,-690.15259,3.061234), direction=MDM_Vector:new(-0.96647418,-0.2567637,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="18187434932497386406", position=MDM_Vector:new(-913.62866,-690.31207,3.1151304), direction=MDM_Vector:new(-0.10116922,-0.99486923,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="18187434932497386406", position=MDM_Vector:new(-909.53839,-699.11597,3.1243472), direction=MDM_Vector:new(-0.1667802,-0.9859941,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="18187434932497386406", position=MDM_Vector:new(-922.41571,-744.79175,3.0986309), direction=MDM_Vector:new(-0.90848875,0.4179092,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="18187434932497386406", position=MDM_Vector:new(-923.88202,-740.05048,3.093822), direction=MDM_Vector:new(-0.99298406,-0.11824846,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="9024609446539980771", position=MDM_Vector:new(-922.49371,-728.50079,3.1785531), direction=MDM_Vector:new(0.60751921,-0.79430497,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="18187434932497386406", position=MDM_Vector:new(-899.25873,-723.43848,3.1321092), direction=MDM_Vector:new(0.21112774,-0.97745848,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId="18187434932497386406", position=MDM_Vector:new(-915.8587,-745.17853,3.0953269), direction=MDM_Vector:new(0.70855165,-0.70565885,0), battleArchetype = "archetype_triggerman_base_pol"}
    },
    paulie_appartment = {npcId="5874491335140879700",position=MDM_Vector:new(-634.74359,-272.58469,2.9996707),direction=MDM_Vector:new (-0.22052898,-0.97538036,0)},
    sam_compound = {npcId = "17582426933065501070", position = MDM_Vector:new(-1521.0383,-378.9501,3.4498563), direction = MDM_Vector:new(-0.95369244,0.30078357,0)}
  },
  M5_The_Camino_Escalation = {
    donSalieri_office = {npcId = "17047363682458951493", position = MDM_Vector:new(-930.04272,-237.91933,6.774931), direction = MDM_Vector:new(0.99158531,-0.129454,0)},
    wave1_ally_cars = {
      {carId = "shubert_e_six", position = MDM_Vector:new(-898.6781,-206.9682,2.9882104), direction = MDM_Vector:new(-0.99834269,0.057258766,-0.0057688723), indestructable = true},
      {carId = "smith_v12", position = MDM_Vector:new(-903.03925,-202.60851,2.9235554), direction = MDM_Vector:new(0.97159564,0.23641084,0.010577699), indestructable = true},
      {carId = "lassiter_v16_roadster", position = MDM_Vector:new(-894.45197,-202.98668,2.9466419), direction = MDM_Vector:new(-0.94317025,0.33142328,0.024261482), indestructable = true}
    },
    wave1_ally_npcs = {
      {npcId = "17582426933065501070", position = MDM_Vector:new(-903.9118,-204.3454,2.7654061), direction = MDM_Vector:new(0.95016724,0.31174058,0)},
      {npcId = "5874491335140879700", position = MDM_Vector:new(-893.06909,-205.6087,2.7583747), direction = MDM_Vector:new(-0.27516028,0.96139836,0)}
    },
    wave1_enemy_cars = {
      {carId = "shubert_e_six", position = MDM_Vector:new(-891.53961,-175.98308,2.9105735), direction = MDM_Vector:new(-0.42457402,-0.90538579,-0.0036094198),indestructable = true, lightsOn = true},
      {carId = "bolt_truck", position = MDM_Vector:new(-896.28357,-173.75388,3.1058621), direction = MDM_Vector:new(-0.13210587,-0.99119651,-0.0088297259), indestructable = true, lightsOn = true},
      {carId = "shubert_six", position = MDM_Vector:new(-900.11688,-174.43999,2.8915193), direction = MDM_Vector:new(-0.079025052,-0.99687004,0.0023694881), indestructable = true, lightsOn = true},
      {carId = "falconer_classic", position = MDM_Vector:new(-904.13879,-174.84245,3.0141106), direction = MDM_Vector:new(0.34974024,-0.93684578,-0.0015406765), indestructable = true, lightsOn = true},
      {carId = "smith_v12", position = MDM_Vector:new(-892.47552,-187.95558,2.9261396), direction = MDM_Vector:new(-0.88356274,-0.46824974,-0.0077114701), indestructable = true},
      {carId = "shubert_e_six", position = MDM_Vector:new(-892.69537,-192.82971,2.9417343), direction = MDM_Vector:new(-0.9915787,-0.12913372,0.0098076146), indestructable = true},
      {carId = "shubert_e_six", position = MDM_Vector:new(-903.54724,-188.91106,2.9339561), direction = MDM_Vector:new(0.95047498,-0.3107619,0.0049449285), indestructable = true},
      {carId = "bolt_model_b", position = MDM_Vector:new(-906.65942,-183.04655,2.975781), direction = MDM_Vector:new(0.92824286,-0.37086901,-0.028661601), indestructable = true}
    },
    wave1_enemy_npcs = {
      --thompson
      {npcId = "13296154699591050027", position = MDM_Vector:new(-894.04907,-174.84938,2.7366309), direction = MDM_Vector:new(-0.1944367,-0.98091507,0)},
      {npcId = "13296154699591050027", position = MDM_Vector:new(-902.12329,-175.76057,2.7373047), direction = MDM_Vector:new(-0.1944367,-0.98091507,0)},
      --shotgun
      {npcId = "2624519215596331124", position = MDM_Vector:new(-898.56555,-174.58881,2.7366204), direction = MDM_Vector:new(0.41528636,-0.90969074,0)},
      {npcId = "2624519215596331124", position = MDM_Vector:new(-907.46515,-180.68529,2.8499207), direction = MDM_Vector:new(0.22172351,-0.97510958,0)},
      -- colt - We set the battleArchetype to "archetype_triggerman_base_pol" as we do not want the triggermen to constantly spam us with molotovs.
      {npcId = "18187434932497386406", position = MDM_Vector:new(-909.88092,-181.22871,2.8536987), direction = MDM_Vector:new(0.18648589,-0.98245764,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-905.64447,-181.34718,2.736156), direction = MDM_Vector:new(0.18581454,-0.98258483,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-902.89764,-187.10097,2.7580409), direction = MDM_Vector:new(0.35274372,-0.93571997,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-893.53784,-191.03168,2.7702768), direction = MDM_Vector:new(-0.23014002,-0.97315753,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-892.18762,-185.425,2.7367439), direction = MDM_Vector:new(-0.28345007,-0.958987,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-889.97803,-176.84952,2.7367396), direction = MDM_Vector:new(-0.38724083,-0.92197859,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-905.47607,-171.23624,2.7371027), direction = MDM_Vector:new(0.39135718,-0.92023885,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-890.77386,-172.79179,2.7366362), direction = MDM_Vector:new(-0.90468264,-0.42608595,0), battleArchetype = "archetype_triggerman_base_pol"},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-899.83588,-171.56589,2.7373915), direction = MDM_Vector:new(0.7722798,-0.63528252,0), battleArchetype = "archetype_triggerman_base_pol"}
    },
    intermezzo1_dead_attackers = {
      {npcId = "18187434932497386406", position = MDM_Vector:new(-923.74182,-235.12625,6.1912246), direction = MDM_Vector:new(-0.99847579,-0.055189606,0), health = 0},
      {npcId = "13296154699591050027", position = MDM_Vector:new(-926.59393,-235.11417,4.0173841), direction = MDM_Vector:new(-0.97367388,-0.22794519,0), health = 0},
      {npcId = "18187434932497386406", position = MDM_Vector:new(-920.9433,-239.57573,6.774157), direction = MDM_Vector:new(-0.9412182,-0.33779892,0), health = 0},
      {npcId = "13296154699591050027", position = MDM_Vector:new(-920.63092,-240.77165,6.774157), direction = MDM_Vector:new(-0.67132002,0.74116755,0), health = 0}
    }
  },
}

function MDM_SalieriMissions.M1_BackyardTrouble()
  local assets = MDM_SalieriMissions.assets.M1_BackyardTrouble

  local cars = MDM_Car.ForConfigs(assets.cars)
  local npcs = MDM_List:new(assets.enemies):Map(function(e)  return MDM_NPC:new(e) end)
  local donSalieri = MDM_NPC:new(assets.donSalieri)

  local missionAssets = MDM_List:new()
  missionAssets:AddAll(cars)
  missionAssets:Add(donSalieri)
  missionAssets:AddAll(npcs)

  local mission = MDM_Mission:new({
    title = "Salieri - Backyard Trouble",
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR,
    assets = missionAssets
  })

  local objective_0500_Spawner = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = missionAssets
  })

  local objective_1000_SpeakToSalieri = MDM_SpeakToObjective:new({
    mission = mission,
    npc = donSalieri,
    title = "Speak to Don Salieri",
    outroText = "Some of Morello's gunmen were reported hanging around in our neighbourhood harassing our people.\nThis can not be tolerated.\nSend Morello a message and take them out.",
  })

  local objective_2000_killTargest = MDM_KillTargetsObjective:new({
    mission = mission,
    targets = npcs,
    title = "Take out Morello's henchmen in a nearby backyard",
    task = "Take out Morello's henchmen in a nearby backyard",
  })


  local objective_3000_evadePolice = MDM_PoliceEvadeObjective:new ({
    mission = mission,
    initialLevel = 2,
    title = "The police is on the way - Escape!"
  })


  local objective_4000_driveBack = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Vector:new(-933.99438,-236.87489,3.7424583),
    radius = 2,
    title = "Drive back to Salieri's Bar",
    noPolice = true
  })

  local objective_5000_SpeakToSalieri = MDM_SpeakToObjective:new({
    mission = mission,
    npc = donSalieri,
    title = "Speak to Don Salieri",
    outroText = "That should show them that we mean business.\nWell done Tommy.",
  })

  -- police should not interfere during the shooting. only afterwards.
  local noPoliceZoneDirector = MDM_PoliceFreeZoneFeature:new({
    position = MDM_Vector:new(-671.66565,-10.197743,3.1811743), radius = 60
  })
  MDM_FeatureUtils.RunWhileObjective(noPoliceZoneDirector,objective_2000_killTargest)

  mission:AddObjectives({
    objective_0500_Spawner,
    objective_1000_SpeakToSalieri,
    objective_2000_killTargest,
    objective_3000_evadePolice,
    objective_4000_driveBack,
    objective_5000_SpeakToSalieri
  })

  return mission
end

function MDM_SalieriMissions.M2_WhiskyWhopper()
  local M2_introText = "Barrels of an exclusive Whisky were smuggled to Lost Heaven on a ship today\nOne of our men at the harbour stored them in a truck on a nearby compound.\nHe was supposed to meet Sam a few hours ago but he didn't show up.\nThat smells like Morello.\nI want you and Paulie to go to the compound, find out what happened and bring the truck to the meetingpoint."

  local npc_paulie = MDM_NPC:newFriend(MDM_SalieriMissions.assets.M2_WhiskyWhopper.paulie_appartment)
  local npc_sam = MDM_NPC:newFriend(MDM_SalieriMissions.assets.M2_WhiskyWhopper.sam_compound)
  local enemyNpcs = MDM_List:new(MDM_SalieriMissions.assets.M2_WhiskyWhopper.compoundEnemies):Map(function(enemy) return MDM_NPC:newEnemy(enemy) end)
  local car_assets = MDM_List:new(MDM_SalieriMissions.assets.M2_WhiskyWhopper.compoundCars):Map(function(car) return MDM_Car:new(car) end)
  local car_truck = MDM_Car:new(MDM_SalieriMissions.assets.M2_WhiskyWhopper.truck)
  -------------------------------------
  ---------------Mission---------------
  -------------------------------------
  local mission = MDM_Mission:new({
    title = "Salieri - Whisky Whopper",
    introText = M2_introText,
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR
  })

  mission:AddAssets(enemyNpcs)
  mission:AddAssets(car_assets)
  mission:AddAssets({npc_paulie,npc_sam,car_truck})
  -------------------------------------
  --------------Objectives-------------
  -------------------------------------
  local objective_050_Spawner = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = mission:GetAssets()
  })

  local objective_100_PickupPaulie = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Vector:new(-634.74359,-272.58469,2.9996707),
    radius = 10,
    title = "Pick up Paulie.",
    onObjectiveStart = function() MDM_PlayerUtils.RestorePlayer() end,
    onObjectiveEnd = function() npc_paulie:MakeAlly(true) end
  })

  local objective_200_FindTruck = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Vector:new(-905.73865,-721.30676,3.1869726),
    title = "Find the truck.",
    radius = 40
  })

  local objective_300_GetInTruck = MDM_GetInCarObjective:new({
    mission = mission,
    car = car_truck,
    title = "Get in the truck."
  })

  local objective_400_GotoMeetingpoint = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Vector:new(-1531.4517,-372.92609,2.9755383),
    title = "Drive to the meeting area.",
    onObjectiveEnd = function() npc_paulie:MakeAlly(false) end,
    noPolice = true
  })

  mission:AddObjectives({
    objective_050_Spawner,
    objective_100_PickupPaulie,
    objective_200_FindTruck,
    objective_300_GetInTruck,
    objective_400_GotoMeetingpoint
  })
  -------------------------------------
  --------------Directors--------------
  -------------------------------------
  local compoundZone = {
    position = MDM_Vector:new(-903.87787,-729.97449,3.1465139) ,
    radius = 60
  }

  -- Deactivate the police during the shooting
  local noPoliceZoneDirector = MDM_PoliceFreeZoneFeature:new({
    position = compoundZone.position,
    radius = compoundZone.radius
  })
  MDM_FeatureUtils.RunBetweenObjectives(noPoliceZoneDirector,objective_200_FindTruck,objective_300_GetInTruck)

  -- Make the enemies on the compound attack the player on sight if close enough
  local hostileZoneDirector = MDM_HostileZoneFeature:new({
    position = compoundZone.position,
    radius = compoundZone.radius,
    detectionRadius = 15,
    enemies = enemyNpcs,
    showArea = true
  })
  MDM_FeatureUtils.RunBetweenObjectives(hostileZoneDirector,objective_200_FindTruck,objective_300_GetInTruck)

  local playerInTruckBannerDetector= MDM_PlayerInCarBannerFeature:new ({
    car = car_truck,
    text = "Get back in the truck"
  })
  MDM_FeatureUtils.RunWhileObjective(playerInTruckBannerDetector,objective_400_GotoMeetingpoint)

  -- Fail the mission if the distance to Paulie is too high but print a warning to give the player the chance to get back to Paulie.
  local paulieDistanceDirector = MDM_EntityDistanceFeature:new({
    entity = npc_paulie,
    distance = 60,
    warningDistance = 40,
    warningText = "Get back to Paulie",
    callback = function() mission:Fail("You lost Paulie") end
  })
  MDM_FeatureUtils.RunBetweenObjectives(paulieDistanceDirector,objective_200_FindTruck,objective_400_GotoMeetingpoint)

  return mission
end


function MDM_SalieriMissions.M3_GangWar1()
  local mission = MDM_GangWarMission:new({
    title = "Little Italy Gang War",
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR,
    carAssets = {
      {carId = "falconer_classic", position = MDM_Vector:new(-902.37054,-245.55942,3.0346258), direction = MDM_Vector:new(0.96175694,-0.2737895,0.0079307277)},
      {carId = "shubert_e_six", position = MDM_Vector:new(-892.20801,-244.26845,2.9532924), direction = MDM_Vector:new(-0.98323697,0.1810374,-0.021691686)},
      {carId = "bolt_v8", position = MDM_Vector:new(-896.96661,-243.3506,3.0347798), direction = MDM_Vector:new(-0.99142301,0.13016272,0.011757697)},
      {carId = "houston_coupe_bv01", position = MDM_Vector:new(-905.63287,-214.83951,3.0663233), direction = MDM_Vector:new(0.9260062,0.37677419,-0.023531549)},
      {carId = "shubert_e_six", position = MDM_Vector:new(-899.86102,-213.72401,2.9817023), direction = MDM_Vector:new(-0.99989682,0.0066443244,-0.012744583)},
      {carId = "bolt_delivery", position = MDM_Vector:new(-893.70294,-213.1147,2.9461083), direction = MDM_Vector:new(-0.99562818,0.093218289,0.0059474269)},
      {carId = "bolt_pickup", position = MDM_Vector:new(-905.54279,-214.16341,3.0409355), direction = MDM_Vector:new(-0.96589297,-0.25770497,0.025275096)}
    },
    allyNpcs = {
      {npcId="5874491335140879700",position=MDM_Vector:new(-908.85223,-227.08142,2.808135),direction=MDM_Vector:new(0.99617749,0.087352395,0)},
    },
    waves = {
      {
        title = "Wave 1 - They are coming from the North",
        restorePlayer = true,
        preparationTime = 10,
        enemies = {
          {npcId="13604348442857333985", position = MDM_Vector:new(-877.54053,-179.31276,2.8210607), direction=MDM_Vector:new(-0.91717273,-0.39848995,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-909.6463,-188.8774,2.8385715),direction= MDM_Vector:new(0.51778549,-0.85551047,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-898.08289,-183.80492,2.7595434),direction= MDM_Vector:new(-0.23320645,-0.97242725,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-892.63867,-181.422,2.7360954), direction=MDM_Vector:new(-0.15583517,-0.98778307,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-900.65839,-176.99596,2.7371385), direction=MDM_Vector:new(-0.19901529,-0.97999644,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-895.70215,-174.4108,2.7366309), direction=MDM_Vector:new(-0.21996461,-0.97550786,0), battleArchetype = "archetype_triggerman_base_pol"}
        }
      },
      {
        title = "Wave 2 - They are coming from the South",
        restorePlayer = true,
        preparationTime = 10,
        enemies = {
          {npcId="13604348442857333985", position = MDM_Vector:new(-912.276,-272.20651,2.7572498), direction=MDM_Vector:new(0.77677119,0.62978292,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-902.5733,-281.51898,2.6639752), direction=MDM_Vector:new(-0.45808861,0.88890654,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-890.86993,-274.1214,2.6641729),direction= MDM_Vector:new(-0.39807889,0.91735119,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-884.85193,-272.28378,2.7870576),direction= MDM_Vector:new(-0.26791304,0.9634431,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-882.34644,-270.70609,2.8150592),direction= MDM_Vector:new(-0.1980121,0.98019958,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Vector:new(-896.8877,-297.81766,2.793437),direction= MDM_Vector:new(-0.051288676,0.99868387,0), battleArchetype = "archetype_triggerman_base_pol"}
        }
      }
    }
  })

  return mission
end

function MDM_SalieriMissions.M4_GangWar2()
  local wave1Npcs = {
    {npcId="13604348442857333985", position= MDM_Vector:new(-1341.6405,60.678833,3.3377147), direction = MDM_Vector:new(0.057904456,-0.99832207,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1338.4283,61.330421,3.4274106), direction = MDM_Vector:new(-0.1250236,-0.9921537,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1333.8378,60.914726,3.4938006), direction = MDM_Vector:new(0.83252376,-0.55398923,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1336.9178,64.083038,3.4031191), direction = MDM_Vector:new(-0.029945441,-0.99955148,0), battleArchetype = "archetype_triggerman_base_pol"}
  }

  local wave2NPCs = {
    {npcId="13604348442857333985", position= MDM_Vector:new(-1379.2908,20.443228,3.3324304), direction = MDM_Vector:new(0.99984968,0.017331241,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1378.7825,23.249542,3.3157849), direction = MDM_Vector:new(0.8313151,0.55580127,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1378.5864,25.967979,3.2988653), direction = MDM_Vector:new(0.9989906,-0.044919487,0), battleArchetype = "archetype_triggerman_base_pol"}
  }

  local wave3NPCs = {
    {npcId="13604348442857333985", position= MDM_Vector:new(-1339.7012,-24.598413,4.0049219), direction = MDM_Vector:new(-0.030802596,0.99952543,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1335.7605,-24.900768,4.0430508), direction = MDM_Vector:new(-0.024835717,0.99969149,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1332.0574,-24.968515,4.0788627), direction = MDM_Vector:new(-0.013719424,0.99990582,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1328.6531,-25.033279,4.1118484), direction = MDM_Vector:new(-0.01357092,0.99990785,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1331.3779,-20.022778,4.0834484), direction = MDM_Vector:new(-0.16082166,0.98698342,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Vector:new(-1336.2496,-19.2791,4.05158), direction = MDM_Vector:new(-0.61400998,0.78929818,0), battleArchetype = "archetype_triggerman_base_pol"},
  }

  local carAssets = {
    {carId = "shubert_e_six", position = MDM_Vector:new(-1332.9858,9.4035025,4.2480459), direction = MDM_Vector:new(-0.95426929,-0.29860383,0.014352869)},
    {carId = "shubert_e_six", position = MDM_Vector:new(-1339.9849,10.249894,4.169414), direction = MDM_Vector:new(0.94146079,-0.33535159,0.03451445)},
    {carId = "shubert_e_six", position = MDM_Vector:new(-1335.6543,24.85214,4.0719504), direction = MDM_Vector:new(-0.9127509,0.40821823,-0.015609706)},
    {carId = "bolt_delivery", position = MDM_Vector:new(-1341.9893,26.62381,3.9106264), direction = MDM_Vector:new(0.99264538,-0.11264583,0.044340719)},
    {carId = "shubert_six", position = MDM_Vector:new(-1349.9421,22.056082,3.5512807), direction = MDM_Vector:new(0.046726886,-0.99883455,0.012112266)}
  }

  local allyNpcs = {
    {npcId= "5874491335140879700", position= MDM_Vector:new(-1330.4849,16.178551,3.9502649), direction = MDM_Vector:new(-0.95933074,0.28228405,0)}
  }

  local mission = MDM_GangWarMission:new({
    title = "Little Italy Gang War 2",
    startPosition = MDM_Vector:new(-1330.4849,15.178551,3.9502649),
    carAssets = carAssets,
    allyNpcs = allyNpcs,
    waves = {
      {
        enemies = wave1Npcs,
        title = "Wave 1 - Attack from the north",
        restorePlayer = true,
        preparationTime = 10,
      },
      {
        enemies = wave2NPCs,
        title = "Wave 2 - Attack from the west",
        restorePlayer = true,
        preparationTime = 10,
      },
      {
        enemies = wave3NPCs,
        title = "Wave 3 - Attack from the south",
        restorePlayer = true,
        preparationTime = 10,
      }
    }
  })

  return mission
end

function MDM_SalieriMissions.M5_The_Camino_Escalation()
  local assets = MDM_SalieriMissions.assets.M5_The_Camino_Escalation

  local donSalieri = MDM_NPC:new(assets.donSalieri_office)
  local wave1_enemyCars = MDM_Car.ForConfigs(assets.wave1_enemy_cars)
  local wave1_enemyNpcs = MDM_NPC.ForConfigs(assets.wave1_enemy_npcs)
  local wave1_allyCars = MDM_Car.ForConfigs(assets.wave1_ally_cars)
  local wave1_allyNpcs = MDM_List:new(assets.wave1_ally_npcs):Map(function(npc) return MDM_NPC:newAlly(npc) end)
  local intermezzo1_deadAttackers = MDM_NPC.ForConfigs(assets.intermezzo1_dead_attackers)

  local wave1_Assets = MDM_List:new()
    :Add(donSalieri)
    :AddAll(wave1_enemyCars)
    :AddAll(wave1_allyCars)
    :AddAll(wave1_enemyNpcs)
    :AddAll(wave1_allyNpcs)
    :AddAll(intermezzo1_deadAttackers)

  local assets = MDM_List:new(wave1_Assets)

  local mission = MDM_Mission:new({
    title = "The Camino Escalation",
    initialWeather = "temp_teaser_trailer",
    initialOutfit = "9354636703565519112", --Trenchcoat and hat
    startPosition = MDM_Vector:new(-898.15344,-209.46974,2.8157277),
    startDirection = MDM_Vector:new(-0.26472956,0.96432263,0),
    assets = assets,
    onMissionStart = function()
      game.traffic:SetEnableAmbientTrafficSpawning(false)
      MDM_PlayerUtils.RestorePlayer()
    end,
    onMissionEnd = function()
      game.traffic:SetEnableAmbientTrafficSpawning(true)
    end
  })

  local objective_100_spawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = wave1_Assets
  })

  local objective_200_KillGroup1 = MDM_KillTargetsObjective:new({
    mission = mission,
    title = "Defend the bar!",
    targets = wave1_enemyNpcs,
    onObjectiveStart = function() for _,e in ipairs(wave1_enemyNpcs) do e:AttackPlayer() end end
  })

  local objective_300_Intermezzo1Spawner = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = intermezzo1_deadAttackers
  })

  local objective_400_SpeakToSalieri = MDM_SpeakToObjective:new({
    mission = mission,
    title = "Look for Don Salieri",
    npc = donSalieri
  })

  mission:AddObjectives({
    objective_100_spawnerObjective,
    --    objective_200_KillGroup1,
    objective_300_Intermezzo1Spawner,
    objective_400_SpeakToSalieri
  })

  return mission
end

MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M1_BackyardTrouble", func = MDM_SalieriMissions.M1_BackyardTrouble})
MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M2_WhiskyWhopper", func = MDM_SalieriMissions.M2_WhiskyWhopper})
MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M3_GangWar1", func = MDM_SalieriMissions.M3_GangWar1})
MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M4_GangWar2", func = MDM_SalieriMissions.M4_GangWar2})
MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M5_The_Camino_Escalation", func = MDM_SalieriMissions.M5_The_Camino_Escalation})
