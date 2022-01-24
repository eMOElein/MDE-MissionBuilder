MDM_LucasBertone = {}

local pos_SalierisBar = MDM_Locations.SALIERIS_BAR_GARAGE_FRONTDOOR
local pos_BertonesAutoservice = MDM_Locations.BERTONES_AUTOSERVICE_FRONTDOOR --real location

function MDM_LucasBertone.M1_1_Fairplay()
  local smithV12Car = MDM_Car:new({
    carId = "smith_v12",
    position = MDM_Utils.GetVector(-180.402725,-897.841553,2.624493),
    direction = MDM_Utils.GetVector(-0.021050,0.999603,-0.018721)
  })
  smithV12Car:SetPrimaryColorRGB(150,100,0)

  -- Create mission
  local mission = MDM_Mission:new({
    title = "Lucas Bertone 1-1 - Fairplay",
    initialOutfit = "7399986759921114297",
    initialWeather = "mm_050_race_cp_120",
    initialSeason = 2, --1932
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR
  })

  -- Objective 1: Visit Lucas Bertone.
  local objective1 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Visit Lucas Bertone.",
    task = "Visit Lucas Bertone.",
    description = "Visit Lucas Bertone.",
    noPolice = true
  })
  mission:AddObjective(objective1)

  -- Objective2: Get in the parked car.
  -- No need to spawn the car manually. The objective does that for us on start.
  -- If the car is already spawned it wont be spawned again.
  local objective2 = MDM_GetInCarObjective:new({
    car = smithV12Car,
    title = "Steal the Smith V12",
    task = "Steal the Smith V12",
    description = "Steal the parked vehicle and try not to get spottet"
  })
  mission:AddObjective(objective2)

  -- Objective 3: Drive back to Salieris bar.
  local objective3 = MDM_GoToObjective:new({
    position = pos_SalierisBar,
    title = "Drive back to Salieri's bar",
    task = "Drive back to Salieri's bar",
    description = "Park the car behind Salieri's bar",
    noPolice = true
  })
  mission:AddObjective(objective3)

  -- Create the director that notifies the HUD when the player is not in the vehicle.
  -- Only active while objective2 is running.
  local director= MDM_PlayerInCarBannerDirector:new ({
    mission = mission,
    car = smithV12Car
  })
  MDM_ActivatorUtils.RunWhileObjective(director,objective3)

  return mission
end

function MDM_LucasBertone.M2_1_TripToTheCountry()
  local M2_1_introText = "Ah Tommy, just the man I need.\nAn informant told me the police is after one of my friends.\nWe need to warn him before it's too late!\nHis house is in Hoboken.\nCan you do that for me Tommy?"
  local M2_1_outroText = "Thank you Tommy.\nI have a gift for you.\nThis one's brand new.\nThe first car with an aerodynamic body.\nSome people are not impressed but I certainly am.\nAnd thievefriendly too.\nJust stick in this whire and you're done.\nA guy in Oakwood owns the same car.\nHe parked it in front of his house."

  local boltCar = MDM_Car:new({
    carId = "bolt_v8",
    position = MDM_Utils.GetVector(1710.9281,528.12469,3.0614924),
    direction = MDM_Utils.GetVector(-0.27043605,-0.96266121,0.012160566)
  })

  local mission = MDM_Mission:new({
    initialOutfit = "9354636703565519112", --Trenchcoat and hat
    initialWeather = "mm_100_farm_cp_050",
    initialSeason = 3, --1933
    outroText = M2_1_outroText,
    startPosition = MDM_Utils.GetVector(1714.9164,529.63013,2.7865424),
    title = "Lucas Bertone 2-1 - A Trip To The Country"
  })
  mission:AddAssets({boltCar})
  mission:OnMissionStart(function() MDM_Utils.SpawnAll({boltCar})end)


  --Objective1: Visit Lucas Bertone
  local objective1 = MDM_GoToObjective:new({
    title = "Visit Lucas Bertone",
    position = pos_BertonesAutoservice,
    radius = 2,
    noPolice = true
  })
  mission:AddObjective(objective1)

  --Objective2: Warn Lucas' friend
  local objective2 = MDM_GoToObjective:new({
    introText = M2_1_introText,
    position = MDM_Utils.GetVector(1463.5498,210.33923,9.577445),
    radius = 2,
    title = "Warn Lucas' friend!",
    outroText = "Are you crazy? Do you know what time it is?\nWhat the cops are on their way?\nShit, I need to get the hell out of here.\nI'll go through the backdoor.\nThank Lucas from me and you too man.",
    noPolice = true
  })
  mission:AddObjective(objective2)

  MDM_MissionUtils.RunTimerBetweenObjectives(mission,objective2, objective2, 300, function() mission:Fail() end)

  --Objective3: Drive back to Lucas Bertone
  local objective3 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Drive back to Lucas Bertone"
  })
  mission:AddObjective(objective3)

  return mission
end

function MDM_LucasBertone.M2_2_TripToTheCountry()
  local car_culver = MDM_Car:new({
    carId = "culver_airmaster",
    position = MDM_Utils.GetVector(1455.7325,-645.18976,45.83866),
    direction = MDM_Utils.GetVector(0.20905077,-0.97790265,-0.0020436067)
  })
  car_culver:SetPrimaryColorRGB(70,70,10)

  local mission = MDM_Mission:new({
    initialWeather = "mm_100_farm_cp_050",
    initialOutfit = "9354636703565519112", --Trenchcoat and Hat
    title = "Lucas Bertone 2-2 - A Trip To The Country",
    startPosition = MDM_Locations.BERTONES_AUTOSERVICE_FRONTDOOR
  })

  local objective1 = MDM_GetInCarObjective:new({
    car = car_culver,
    title = "Steal the Culver in Oakwood"
  })
  mission:AddObjective(objective1)

  -- Objective 2: Drive back to Salieris bar.
  local objective2 = MDM_GoToObjective:new({
    position = pos_SalierisBar,
    title = "Drive back to Salieri's bar",
    task = "Drive back to Salieri's bar",
    description = "Park the car behind Salieri's bar"
  })
  mission:AddObjective(objective2)

  return mission
end

function MDM_LucasBertone.M3_1_Omerta()
  local M3_1_introText = "A guy from Oakwod has beaten up one of my guys.\nA guy from the Black Cat bar. Someone needs to teach him a lesson.\nBut don't kill him. Just give him one or two good punches.\nAnd say him it's a lesson from Carlo."
  local npc_big_stan = MDM_NPC:new("2541916285709005291",MDM_Utils.GetVector(-1040.7507,-302.92154,4.3719287),MDM_Utils.GetVector(-0.67485845,0.73794723,0))
  local car_shubert = MDM_Car:new({
    carId = "shubert_e_six",
    position = MDM_Utils.GetVector(866.77765,124.30984,27.451666),
    direction = MDM_Utils.GetVector(0.0027531318,-0.99997759,0.0062396573)
  })

  local mission = MDM_Mission:new({
    initialWeather = "mm_110_omerta_cp_050_cs_safehouse",
    introText = M3_1_introtext,
    title = "Lucas Bertone 3-1 - Omerta",
    initialOutfit = "16117888644291730074", --Pinstripe and Hat
    startPosition = MDM_Locations.BERTONES_AUTOSERVICE_FRONTDOOR
  })
  mission:AddAssets({car_shubert})
  mission:OnMissionStart(function() MDM_Utils.SpawnAll({car_shubert}) end)


  -- Visit Lucas Bertone
  local objective1 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Visit Lucas Bertone",
    noPolice = true
  })
  mission:AddObjective(objective1)

  local spawnerObjective = MDM_SpawnerObjective:new({spawnables = {npc_big_stan}})
  mission:AddObjective(spawnerObjective)

  -- Teach Big Stan a lesson
  local objective2 = MDM_HurtNPCObjective:new({
    npc = npc_big_stan,
    threshold = 85,
    title = "Teach Big Stan a lesson - He's at the former Black Cat bar",
  })
  mission:AddObjective(objective2)

  -- Back to Lucas Bertone
  local objective3 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    title = "Go back to Lucas Bertone",
    noPolice = true
  })
  mission:AddObjective(objective3)

  return mission
end

function MDM_LucasBertone.M3_2_Omerta()
  local car_berkley = MDM_Car:new({
    carId = "berkley_810",
    position = MDM_Utils.GetVector(2127.3906,-252.37337,122.8),
    direction = MDM_Utils.GetVector(-0.99890906,-0.045765243,-0.0092927944)
  })
  car_berkley:SetPrimaryColorRGB(100,30,0)

  local mission = MDM_Mission:new({
    initialWeather = "mm_110_omerta_cp_050_cs_safehouse",
    title = "Lucas Bertone 3-2 - Omerta"
  })

  local objective1 = MDM_GetInCarObjective:new({
    car = car_berkley,
    title = "Steal the Berkley 810 in Oak Hill"
  })
  mission:AddObjective(objective1)

  local objective2 = MDM_GoToObjective:new({
    position = pos_SalierisBar,
    title = "Drive back to Salieri's Bar"
  })
  mission:AddObjective(objective2)

  return mission
end

function MDM_LucasBertone.M4_1_LuckyBastard()
  local npcFriend1 = MDM_NPC:newFriend("18187434932497386406", MDM_Utils.GetVector(-1047.1255,533.90619,17.958805), MDM_Utils.GetVector(-0.36978897,-0.92911577,0))
  local npcFriend2 = MDM_NPC:newFriend("18187434932497386406", MDM_Utils.GetVector(-1045.6821,533.11432,17.960611), MDM_Utils.GetVector(-0.80718642,-0.59029663,0))
  local npdDead = MDM_NPC:new("18187434932497386406", MDM_Utils.GetVector(-1048.6772,530.96112,17.956875), MDM_Utils.GetVector(-0.70304906,-0.71114135,0))

  local mission = MDM_Mission:new({
    title = "Lucas Bertone 4-1 Lucky Bastard",
    initialOutfit = "7399986759921114297",
    initialWeather = "mm_160_harbor_cp_080_harbour_entrance_cutscene"
  })
  mission:AddAssets({npcFriend1,npcFriend2,npdDead})

  local objective_100_visitLucas = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Visit Lucas Bertone",
    noPolice = true
  })
  mission:AddObjective(objective_100_visitLucas)

  local objective_200_pickupFriends = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-1045.6821,533.11432,17.960611),
    radius = 7,
    title = "Rescue Lucas's friend!",
    onObjectiveStart = function() print("Spawn Feidns") MDM_Utils.SpawnAll({npcFriend1,npcFriend2,npdDead}) end,
    onObjectiveEnd = function() npcFriend1:MakeAlly(true)  npcFriend2:MakeAlly(true) end,
    noPolice = true
  })
  mission:AddObjective(objective_200_pickupFriends)


  local objective_300_toDoctor = MDM_GoToObjective:new({
    position = MDM_Locations.OAKWOOD_DOCTOR_DRIVEWAY,
    radius = 7,
    title = "Drive to the doctor in Oakwood.",
    introText = "Drive us to the doctor in Oakwood",
    outroText = "You made it. Thanks mate!",
    onObjectiveEnd = function() MDM_Utils.DespawnAll({npcFriend1,npcFriend2}) end,
    noPolice = true
  })
  mission:AddObjective(objective_300_toDoctor)

  MDM_MissionUtils.RunTimerBetweenObjectives(mission,objective_200_pickupFriends,objective_300_toDoctor,400,function() mission:Fail("You did not make it in time!") end)

  return mission
end

function MDM_LucasBertone.M4_2_LuckyBastard()
  local npc_Owner = MDM_NPC:new("18187434932497386406", MDM_Utils.GetVector(144.16101,-518.84393,2.6868534), MDM_Utils.GetVector(0.60738873,0.79440475,0))

  local car_Lassiter =  MDM_Car:new({
    carId = "lassiter_v16_roadster",
    position = MDM_Utils.GetVector(148.10092,-514.96936,2.7449892),
    direction = MDM_Utils.GetVector(-0.02271148,-0.99974233,0.00023041756)
  })

  local mission = MDM_Mission:new({
    title = "Lucas Bertone 4-2 Lucky Bastard",
    initialOutfit = "7399986759921114297",
    initialWeather = "mm_160_harbor_cp_080_harbour_entrance_cutscene"
  })
  mission:AddAssets({npc_Owner,car_Lassiter})

  local objective100_GetInCar = MDM_GetInCarObjective:new({
    car = car_Lassiter,
    title = "Steal the Bruno Speedster near the parking lot on Central Island.",
    onObjectiveStart = function() MDM_Utils.SpawnAll({npc_Owner,car_Lassiter})end
  })
  mission:AddObjective(objective100_GetInCar)

  local objective200_ToSalieri = MDM_GoToObjective:new({
    position = MDM_Locations.SALIERIS_BAR_GARAGE_FRONTDOOR,
    title = "Drive back to Salieri's bar",
    onObjectiveStart = function() npc_Owner:AttackPlayer()end
  })
  mission:AddObjective(objective200_ToSalieri)

  return mission
end

function MDM_LucasBertone.M5_1_CremeDeLaCreme()
  -- We prepare all cars that we need during the mission
  -- We need a local variable for the shubert as we need to access it directly later.
  local car_shubert = MDM_Car:new({
    carId = "shubert_e_six",
    position = MDM_Utils.GetVector(446.40228,30.989382,12.288987),
    direction = MDM_Utils.GetVector(0.3100757,-0.95071179,0.00070346153)
  })

  local car_assets = {
    car_shubert,
    MDM_Car:new({ carId = "bolt_ace_pickup", position = MDM_Utils.GetVector(2088.7234,-915.70911,34.317371), direction = MDM_Utils.GetVector(0.47644749,0.8786763,-0.030425811)}),
    MDM_Car:new({ carId = "bolt_pickup", position = MDM_Utils.GetVector(2039.1796,-746.21606,53.322742), direction = MDM_Utils.GetVector(0.98174202,-0.18941244,-0.017485484)}),
    MDM_Car:new({ carId = "bolt_truck", position = MDM_Utils.GetVector(2085.188,-911.09637,34.2), direction = MDM_Utils.GetVector(0.83328521,0.55257672,-0.017171353)})
  }

  local pos_lighthouse = MDM_Utils.GetVector(2128.7178,-912.16492,30.68644)

  local mission = MDM_Mission:new({
    initialWeather = "mm_170_plane_cp_060_cine_1750_plane_airport",
    initialOutfit = "9354636703565519112",
    outroText = "Thank you Tommy.",
    startPosition = MDM_Locations.BERTONES_AUTOSERVICE_FRONTDOOR,
    title = "Lucas Bertone 5-1 - Creme de la Creme"
  })
  mission:OnMissionEnd(function() MDM_PoliceUtils.UnlockWantedLevel() end)

  mission:AddObjective(MDM_RestorePlayerObjective:new())

  local objective1 = MDM_GoToObjective:new({
    outroText = "The car outside was used in a crime.\nI need you to drive it to the lighthouse and destroy it there.\nBut be careful. The police knows the vehicle.",
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Visit Lucas Bertone"
  })
  mission:AddObjective(objective1)

  local objective2 = MDM_GetInCarObjective:new({
    car = car_shubert,
    title = "Get in the car",
    onObjectiveStart = function() MDM_Utils.SpawnAll(car_assets) end,
    onObjectiveEnd = function() MDM_PoliceUtils.SetWantedLevel(2) MDM_PoliceUtils.LockWantedLevel() end
  })
  mission:AddObjective(objective2)

  local objective3 = MDM_GoToObjective:new({
    position = pos_lighthouse,
    radius = 40,
    title = "Destroy the car at the lighthouse",
    onObjectiveEnd = function() MDM_PoliceUtils.SetWantedLevel(0) MDM_PoliceUtils.UnlockWantedLevel() end
  })
  mission:AddObjective(objective3)

  local objective4 = MDM_DestroyCarInAreaObjective:new({
    car = car_shubert,
    position = pos_lighthouse,
    radius = 40,
    title = "Destroy the car"
  })
  mission:AddObjective(objective4)

  local objective5 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Go back to Lucas Bertone"
  })
  mission:AddObjective(objective5)

  --We don't want the car to be destroyed before we are at the lighthouse.
  local damageDirector = MDM_DetectorDirector:new({
    mission = mission,
    detector = MDM_CarDamageDetector:new({
      car = car_shubert,
      threshold = 100,
      flagMotorDamage = true,
      flagCarDamage = true
    }),
    callback = function () mission:Fail("You did not destroy the car in the right location!") end
  })
  MDM_ActivatorUtils.RunBetweenObjectives(damageDirector,objective2,objective3)

  mission:AddAssets(car_assets)

  return mission
end

function MDM_LucasBertone.M5_2_CremeDeLaCreme()
  local car_celeste = MDM_Car:new({
    carId =  "celeste_mark_5",
    position = MDM_Utils.GetVector(534.76263,414.78525,19.954273),
    direction = MDM_Utils.GetVector(0.022378264,-0.99973452,0.005499539)
  })

  local npc_enemy1 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(545.29333,423.88425,19.781425), MDM_Utils.GetVector(-0.5477711,-0.83662814,0))
  local npc_enemy2 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(519.13971,426.54214,19.845762),MDM_Utils.GetVector(-0.5401746,-0.84155297,0))


  local mission = MDM_Mission:new({
    title = "Lucas Bertone 5-2 - Creme de la Creme",
    initialWeather = "mm_170_plane_cp_060_cine_1750_plane_airport ",
    initialOutfit = "9354636703565519112"
  })
  mission:AddAssets({car_celeste,npc_enemy1,npc_enemy2})


  mission:AddObjective(MDM_RestorePlayerObjective:new())

  local objective1 = MDM_GetInCarObjective:new({
    car = car_celeste,
    title = "Steal the Celeste Mark 5 from the diner.",
    onObjectiveStart = function() MDM_Utils.SpawnAll({car_celeste,npc_enemy1,npc_enemy2}) end,
    onObjectiveEnd = function() npc_enemy1:AttackPlayer() npc_enemy2:AttackPlayer() end
  })
  mission:AddObjective(objective1)

  local objective2 = MDM_GoToObjective:new({
    position = pos_SalierisBar,
    title = "Drive back to Salieri's bar"
  })
  mission:AddObjective(objective2)

  return mission
end

function MDM_LucasBertone.M6_1_Election()
  local npc_friend = MDM_NPC:newFriend("18187434932497386406",MDM_Utils.GetVector(-1735.0616,-477.45865,2.6067872),MDM_Utils.GetVector(-0.76740706,0.64116019,0))
  local mission = MDM_Mission:new({
    title = "Lucas Bertone 6-1 - Election Campaign",
    initialWeather = "mm_180_sniper_cp_010",
    initialOutfit = "9354636703565519112"
  })

  local objective1 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Visit Lucas Bertone",
    noPolice = true
  })
  mission:AddObjective(objective1)

  local objective2 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-1735.0616,-477.45865,2.6067872),
    radius = 8,
    title = "Pick up Lucas' friend.",
    introText = "Pick up my friend.",
    onObjectiveStart = function() npc_friend:Spawn() end,
    onObjectiveEnd = function() npc_friend:MakeAlly(true) end,
    noPolice = true
  })
  mission:AddObjective(objective2)

  MDM_MissionUtils.RunTimerBetweenObjectives(mission,objective2, objective2, 300, function() mission:Fail() end)

  local objective3 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 4,
    title = "Drive back to Lucas Bertone",
    onObjectiveStop = function() npc_friend:MakeAlly(false) end,
    noPolice = true
  })
  mission:AddObjective(objective3)

  mission:AddAssets({npc_friend})
  return mission
end

function MDM_LucasBertone.M6_2_Election()
  local car_apollon = MDM_Car:new({
    carId = "lassiter_v16_appolyon",
    position = MDM_Utils.GetVector(1860.8296,-371.40375,107.90319),
    direction = MDM_Utils.GetVector(-0.021005129,0.99971157,-0.011642429)
  })

  local mission = MDM_Mission:new({
    title = "Lucas Bertone 6-2 - Election Campaign",
    initialWeather = "mm_180_sniper_cp_010",
    initialOutfit = "9354636703565519112"
  })

  local spawnerObjective = MDM_SpawnerObjective:new({spawnables = {car_apollon}})
  mission:AddObjective(car_apollon)

  local objective1 = MDM_GetInCarObjective:new({
    car = car_apollon,
    title = "Steal the Lassiter V16 Apolon in Oak Hill."
  })
  mission:AddObjective(objective1)

  local objective2 = MDM_GoToObjective:new({
    position = pos_SalierisBar,
    title = "Drive back to Salieri's bar"
  })
  mission:AddObjective(objective2)

  mission:AddAssets({car_apollon})

  return mission
end

function MDM_LucasBertone.M7_1_Robbery()
  local car_schubert = MDM_Car:new({carId = "shubert_e_six", position = MDM_Utils.GetVector(503.34198,-723.47284,4.4603772), direction = MDM_Utils.GetVector(-0.0096728336,0.99994606,-0.0037835632)})
  local npc_bigdick = MDM_NPC:newFriend("18187434932497386406",MDM_Utils.GetVector(504.8013,-723.25311,4.2775931),MDM_Utils.GetVector(0.72326815,-0.69056726,0))
  npc_bigdick:Godmode(true)

  local npc_enemy1 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(513.33789,-707.03601,7.0374451),MDM_Utils.GetVector(-0.34904775,-0.93710494,0))
  local npc_enemy2 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(515.18402,-706.78918,12.788147),MDM_Utils.GetVector(-0.33973026,-0.94052291,0))
  local npc_enemy3 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(513.67609,-695.6297,4.204731),MDM_Utils.GetVector(-0.19928837,-0.97994089,0))
  local npc_enemy4 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(500.04239,-689.76831,4.2494841),MDM_Utils.GetVector(0.2406131,-0.97062111,0))
  local enemy_assets = {npc_enemy1,npc_enemy2,npc_enemy3,npc_enemy4}

  local mission = MDM_Mission:new({
    title = "Lucas Bertone 7-1 - Moonlighting",
    initialWeather = "mm_110_omerta_cp_050_cs_safehouse",
    initialOutfit = "7399986759921114297",
    outroText = "Thank you for helping me out Tommy.",
    startPosition = MDM_Utils.GetVector(450.40228,30.989382,12.288987)
  })

  mission:AddAssets(enemy_assets)
  mission:AddAssets({npc_bigdick,car_schubert})

  mission:AddObjective(MDM_RestorePlayerObjective:new())

  -- Visit Lucas Bertone
  local objective1 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Visit Lucas Bertone",
    outroText = "There's a dude called big dick.\nI need you to deliver a package to him."
  })
  mission:AddObjective(objective1)

  -- Go to Big Dick
  local objective2 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(504.8013,-723.25311,4.2775931),
    radius = 2,
    title = "Find Big Dick",
    outroText = "Did Lucas send you?\nI am waiting for a special delivery.\nYou tell me you were not followed?\nThen who are these guys.\nThey don't look very friendly.",
    onObjectiveStart = function() npc_bigdick:Spawn(); car_schubert:Spawn()end,
    noPolice = true
  })
  mission:AddObjective(objective2)

  -- Eliminate enemys
  -- Objective spawns the enemies on start if we haven't done it yet.
  local objective3 = MDM_KillTargetsObjective:new({
    targets = enemy_assets,
    title = "Help Big Dick",
    outroText = "You're not as useless as you look.\nThanks for your help and greet Lucas from me.",
    onObjectiveStart = function() npc_bigdick:MakeAlly(true) end,
    onObjectiveEnd = function() npc_bigdick:MakeAlly(false) end
  })
  mission:AddObjective(objective3)

  for _,e in ipairs(enemy_assets) do e:AttackPlayer() end

  -- Disabling the police in the zone where the shooting is happening.
  -- We only activate it during the neccessary objectives.
  local noPoliceZoneDirector = MDM_PoliceFreeZoneDirector:new({position = MDM_Utils.GetVector(506.13187,-711.24323,4.2604446),radius = 60})
  MDM_ActivatorUtils.RunWhileObjective(noPoliceZoneDirector,objective3)
  mission:AddDirector(noPoliceZoneDirector)

  -- Visit Lucas Bertone
  local objective4 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Go back to Lucas Bertone",
    noPolice = true
  })
  mission:AddObjective(objective4)

  return mission
end

function MDM_LucasBertone.M7_2_Robbery()
  local car_trautenberg = MDM_Car:new({
    carId = "trautenberg_sport",
    position = MDM_Utils.GetVector(1582.7761,-513.8941,49.780258),
    direction = MDM_Utils.GetVector(-0.0058350917,0.99998069,-0.0021573838)
  })

  local npc_Driver = MDM_NPC:newCivilian("18187434932497386406", MDM_Utils.GetVector(1585.3451,-514.1037,49.55558), MDM_Utils.GetVector(-0.99988061,0.015445053,0))

  local mission = MDM_Mission:new({
    title = "Lucas Bertone 7-2 - Moonlighting",
    initialWeather = "mm_110_omerta_cp_050_cs_safehouse",
    initialOutfit = "7399986759921114297",
    introText = "Steal the Trautenberg from the Oak Wood Junior High-School",
    startPosition = MDM_Locations.OAKWOOD_DOCTOR_DRIVEWAY
  })

  mission:AddAssets({car_trautenberg,npc_Driver})
  MDM_RestorePlayerObjective:new (mission)

  local objective1 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(1582.7761,-513.8941,49.780258),
    radius = 50,
    title = "Steal the Trautenberg from the Oak Wood Junior High-School.",
    onObjectiveStart = function () MDM_Utils.SpawnAll({car_trautenberg,npc_Driver})end
  })
  mission:AddObjective(objective1)

  local objective2_waitForSpawns = MDM_CallbackObjective:new ({
    title = "Spawntime",
    callback = function ()
      if car_trautenberg:IsSpawned() and npc_Driver:IsSpawned()then
        npc_Driver:GetGameEntity():GetInOutCar(car_trautenberg:GetGameEntity(),1,false,false)

        car_trautenberg:GetGameEntity():InitializeAIParams(enums.CarAIProfile.NORMAL,enums.CarAIProfile.NORMAL)
        car_trautenberg:GetGameEntity():SetMaxAISpeed(true,50)
        car_trautenberg:GetGameEntity():SetNavModeWanderArea(false,nil)
        return true
      else
        return false
      end
    end
  })
  mission:AddObjective(objective2_waitForSpawns)

  local objective3_GetInCar = MDM_GetInCarObjective:new({
    car = car_trautenberg,
    title = "Steal the Trautenberg.",
    onObjectiveStart = function() end
  })
  mission:AddObjective(objective3_GetInCar)

  MDM_Core.missionManager:StartMission(mission)
  return mission
end
