MDM_SalieriMissions = {}

function MDM_SalieriMissions.M1_BackyardTrouble()
  local car_schubert = MDM_Car:new("shubert_six",MDM_Utils.GetVector(-670.4494,-22.954449,3.3371413),MDM_Utils.GetVector(-0.32917213,-0.94427019,-0.0002347008))

  local npc1 = MDM_NPC:new({npcId="13604348442857333985",position=MDM_Utils.GetVector(-683.10767,-15.692556,3.2338758),direction=MDM_Utils.GetVector(0.6981827,-0.71591961,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc2 = MDM_NPC:new({npcId="13604348442857333985",position=MDM_Utils.GetVector(-681.30603,-24.531549,3.2201567),direction=MDM_Utils.GetVector(0.41589907,0.90941077,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc3 = MDM_NPC:new({npcId="13604348442857333985",position=MDM_Utils.GetVector(-684.01532,-21.848021,3.352128),direction=MDM_Utils.GetVector(0.9708972,0.23949677,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc4 = MDM_NPC:new({npcId="13604348442857333985",position=MDM_Utils.GetVector(-678.65411,-14.920903,3.2161522),direction=MDM_Utils.GetVector(-0.31570739,-0.94885659,0), battleArchetype = "archetype_triggerman_base_pol"})

  local assets = {car_schubert,npc1,npc2,npc3,npc4}

  local mission = MDM_Mission:new({
    title = "Salieri - Backyard Trouble",
    introText = "Some of Morello's gunmen were reported hanging around in our neighbourhood harassing our people.\nThis can not be tolerated.\nSend Morello a message and take them out.",
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR,
    assets = assets
  })

  local objective1 = MDM_KillTargetsObjective:new({
    mission = mission,
    targets = {npc1,npc2,npc3,npc4},
    title = "Take out Morello's henchmen in a nearby backyard",
    task = "Take out Morello's henchmen in a nearby backyard",
    onObjectiveStart = function()
      MDM_PlayerUtils.RestorePlayer()
      MDM_Utils.SpawnAll(assets)
    end
  })
  mission:AddObjective(objective1)

  local objective2 = MDM_PoliceEvadeObjective:new ({
    mission = mission,
    initialLevel = 2,
    title = "The police is on the way - Escape!"
  })
  mission:AddObjective(objective2)

  local objective3 = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Utils.GetVector(-907.94,-210.41,2),
    title = "Drive back to Salieri's Bar",
    noPolice = true
  })
  mission:AddObjective(objective3)

  -- police should not interfere during the shooting. only afterwards.
  local noPoliceZoneDirector = MDM_PoliceFreeZoneDirector:new({
    position = MDM_Utils.GetVector(-671.66565,-10.197743,3.1811743), radius = 60
  })
  MDM_ActivatorUtils.RunWhileObjective(noPoliceZoneDirector,objective1)

  return mission
end

function MDM_SalieriMissions.M2_WhiskyWhopper()
  local M2_introText = "Bottles of an exclusive Whisky were smuggled to Lost Heaven on a ship today\nOne of our men at the harbour stored it in a truck on a nearby compound.\nHe was supposed to meet Sam a few hours ago but he didn't show up.\nThat smells like Morello.\nI want you and Paulie to go to the compound, find out what happened and bring the truck to the meetingpoint."

  local npc_paulie = MDM_NPC:newFriend({npcId="5874491335140879700",position=MDM_Utils.GetVector(-634.74359,-272.58469,2.9996707),direction=MDM_Utils.GetVector (-0.22052898,-0.97538036,0)})
  local npc_sam = MDM_NPC:newFriend({npcId = "17582426933065501070", position = MDM_Utils.GetVector(-1521.0383,-378.9501,3.4498563), direction = MDM_Utils.GetVector(-0.95369244,0.30078357,0)})

  -- We set the battleArchetype to "archetype_triggerman_base_pol" as we do not want the triggermen to constantly spam us with molotovs.
  local npc1 = MDM_NPC:new({npcId="18187434932497386406",position=MDM_Utils.GetVector(-918.92773,-706.95239,3.146647),direction=MDM_Utils.GetVector(0.43737864,-0.89927745,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc2 = MDM_NPC:new({npcId="18187434932497386406",position=MDM_Utils.GetVector(-921.99921,-711.38287,3.1582365),direction=MDM_Utils.GetVector(0.70571977,-0.70849109,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc3 = MDM_NPC:new({npcId="18187434932497386406",position=MDM_Utils.GetVector(-928.05493,-690.15259,3.061234),direction=MDM_Utils.GetVector(-0.96647418,-0.2567637,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc4 = MDM_NPC:new({npcId="18187434932497386406",position=MDM_Utils.GetVector(-913.62866,-690.31207,3.1151304),direction=MDM_Utils.GetVector(-0.10116922,-0.99486923,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc5 = MDM_NPC:new({npcId="18187434932497386406",position=MDM_Utils.GetVector(-909.53839,-699.11597,3.1243472),direction=MDM_Utils.GetVector(-0.1667802,-0.9859941,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc6 = MDM_NPC:new({npcId="18187434932497386406",position=MDM_Utils.GetVector(-922.41571,-744.79175,3.0986309),direction=MDM_Utils.GetVector(-0.90848875,0.4179092,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc7 = MDM_NPC:new({npcId="18187434932497386406",position=MDM_Utils.GetVector(-923.88202,-740.05048,3.093822),direction=MDM_Utils.GetVector(-0.99298406,-0.11824846,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc8 = MDM_NPC:new({npcId="9024609446539980771",position=MDM_Utils.GetVector(-922.49371,-728.50079,3.1785531),direction=MDM_Utils.GetVector(0.60751921,-0.79430497,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc9 = MDM_NPC:new({npcId="18187434932497386406",position=MDM_Utils.GetVector(-899.25873,-723.43848,3.1321092),direction=MDM_Utils.GetVector(0.21112774,-0.97745848,0), battleArchetype = "archetype_triggerman_base_pol"})
  local npc10 = MDM_NPC:new({npcId="18187434932497386406",position=MDM_Utils.GetVector(-915.8587,-745.17853,3.0953269),direction=MDM_Utils.GetVector(0.70855165,-0.70565885,0), battleArchetype = "archetype_triggerman_base_pol"})
  local enemyNpcs = {npc1,npc2,npc3,npc4,npc5,npc6,npc7,npc8,npc9,npc10}

  local car_bolt_pickup_1 = MDM_Car:new("bolt_pickup",MDM_Utils.GetVector(-893.90149,-745.11334,3.8092734),MDM_Utils.GetVector(0.72964358,0.68382657,0.0011832109))
  local car_bolt_pickup_2 = MDM_Car:new("bolt_pickup",MDM_Utils.GetVector(-898.30536,-751.86047,3.3934219),MDM_Utils.GetVector(-0.74674648,-0.66510487,-0.0023534386))
  local car_bolt_pickup_3 = MDM_Car:new("bolt_pickup",MDM_Utils.GetVector(-910.31396,-759.52026,3.8393802),MDM_Utils.GetVector(-0.62445927,0.7810356,0.0058287559))
  local car_bolt_delivery_1 = MDM_Car:new("bolt_delivery",MDM_Utils.GetVector(-908.26495,-740.39478,3.7478696),MDM_Utils.GetVector(-0.67092276,-0.74139231,-0.014146926))
  local car_bolt_delivery_2 = MDM_Car:new("bolt_delivery",MDM_Utils.GetVector(-912.86163,-761.5907,3.7518097),MDM_Utils.GetVector(-0.56397796,0.8257395,-0.0091202371))
  local car_bolt_delivery_3 = MDM_Car:new("bolt_delivery",MDM_Utils.GetVector(-911.30109,-725.61053,3.7402503),MDM_Utils.GetVector(-0.0078235492,0.99992293,-0.0096368138))
  local car_bolt_delivery_4 = MDM_Car:new("bolt_delivery",MDM_Utils.GetVector(-1509.3436,-376.85468,3.6807584),MDM_Utils.GetVector(0.91617841,-0.40075919,0.0031141266))
  local car_culvery_1 = MDM_Car:new("culver_airmaster",MDM_Utils.GetVector(-910.1109,-735.37524,3.777604),MDM_Utils.GetVector(-0.99961263,0.02770582,-0.0026414304))
  local car_shubert_1 = MDM_Car:new("shubert_e_six",MDM_Utils.GetVector(-925.31885,-742.49475,3.6757897),MDM_Utils.GetVector(0.31558034,-0.94889647,-0.0022272428))
  local car_shubert_2 = MDM_Car:new("shubert_e_six",MDM_Utils.GetVector(-930.09686,-691.34521,3.614205),MDM_Utils.GetVector(-0.57875252,0.81542385,-0.011381509))
  local car_shubert_3 = MDM_Car:new("shubert_e_six",MDM_Utils.GetVector(-919.50708,-711.02771,3.7303878),MDM_Utils.GetVector(0.61881775,0.78550607,-0.0067021623))
  local car_shubert_4 = MDM_Car:new("shubert_six",MDM_Utils.GetVector(-1534.4438,-407.91177,2.7442001),MDM_Utils.GetVector(0.9161188,-0.4007743,0.010295066))
  local car_lassiter_1 = MDM_Car:new("lassiter_v16",MDM_Utils.GetVector(-913.54755,-745.96582,3.7011901),MDM_Utils.GetVector(-0.90786278,-0.4191981,0.0076475153))
  local car_truck = MDM_Car:new("bolt_truck",MDM_Utils.GetVector(-903.20862,-692.28986,3.88734),MDM_Utils.GetVector(-0.96103084,-0.27643755,-0.0014791912))
  local car_assets = {car_bolt_pickup_1,car_bolt_pickup_2,car_bolt_pickup_3,car_bolt_delivery_1,car_bolt_delivery_2,car_bolt_delivery_2,car_bolt_delivery_3,car_bolt_delivery_4,car_culvery_1,
    car_shubert_1, car_shubert_2,car_shubert_3,car_shubert_4,car_lassiter_1,car_truck}

  local mission = MDM_Mission:new({
    title = "Salieri - Whisky Whopper",
    introText = M2_introText,
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR
  })
  -------------------------------------
  --------------Objectives-------------
  -------------------------------------
  local objective1 = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Utils.GetVector(-634.74359,-272.58469,2.9996707),
    radius = 10,
    title = "Pick up Paulie.",
    onObjectiveStart = function() MDM_PlayerUtils.RestorePlayer() end,
    onObjectiveEnd = function() npc_paulie:MakeAlly(true) end
  })
  mission:AddObjective(objective1)

  local objective2 = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Utils.GetVector(-905.73865,-721.30676,3.1869726),
    title = "Find the truck.",
    radius = 40
  })
  mission:AddObjective(objective2)

  local objective3 = MDM_GetInCarObjective:new({
    mission = mission,
    car = car_truck,
    title = "Get in the truck."
  })
  mission:AddObjective(objective3)

  local objective4 = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Utils.GetVector(-1531.4517,-372.92609,2.9755383),
    title = "Drive to the meeting area.",
    onObjectiveEnd = function() npc_paulie:MakeAlly(false) end,
    noPolice = true
  })
  mission:AddObjective(objective4)
  -------------------------------------
  --------------Directors--------------
  -------------------------------------
  local zonePosition = MDM_Utils.GetVector(-903.87787,-729.97449,3.1465139)
  local zoneRadius = 60

  local noPoliceZoneDirector = MDM_PoliceFreeZoneDirector:new({
    position = zonePosition,
    radius = zoneRadius
  })
  MDM_ActivatorUtils.RunBetweenObjectives(noPoliceZoneDirector,objective2,objective3)

  local hostileZoneDirector = MDM_HostileZoneDirector:new({
    position = zonePosition,
    radius = zoneRadius,
    detectionRadius = 15,
    enemies = enemyNpcs,
    showArea = true
  })
  MDM_ActivatorUtils.RunBetweenObjectives(hostileZoneDirector,objective2,objective3)

  mission:AddAssets(enemyNpcs)
  mission:AddAssets(car_assets)
  mission:AddAssets({npc_paulie,npc_sam})

  mission:OnMissionStart(function()
    MDM_Utils.SpawnAll(car_assets)
    MDM_Utils.SpawnAll(enemyNpcs)
    MDM_Utils.SpawnAll({npc_paulie,npc_sam}) -- Important to put single objects in brackets!!!
  end)

  return mission
end


function MDM_SalieriMissions.M3_GangWar1()
  local mission = MDM_GangWarMission:new({
    title = "Little Italy Gang War",
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR,
    carAssets = {
      {carId = "falconer_classic", position = MDM_Utils.GetVector(-902.37054,-245.55942,3.0346258), direction = MDM_Utils.GetVector(0.96175694,-0.2737895,0.0079307277)},
      {carId = "shubert_e_six", position = MDM_Utils.GetVector(-892.20801,-244.26845,2.9532924), direction = MDM_Utils.GetVector(-0.98323697,0.1810374,-0.021691686)},
      {carId = "bolt_v8", position = MDM_Utils.GetVector(-896.96661,-243.3506,3.0347798), direction = MDM_Utils.GetVector(-0.99142301,0.13016272,0.011757697)},
      {carId = "houston_coupe_bv01", position = MDM_Utils.GetVector(-905.63287,-214.83951,3.0663233), direction = MDM_Utils.GetVector(0.9260062,0.37677419,-0.023531549)},
      {carId = "shubert_e_six", position = MDM_Utils.GetVector(-899.86102,-213.72401,2.9817023), direction = MDM_Utils.GetVector(-0.99989682,0.0066443244,-0.012744583)},
      {carId = "bolt_delivery", position = MDM_Utils.GetVector(-893.70294,-213.1147,2.9461083), direction = MDM_Utils.GetVector(-0.99562818,0.093218289,0.0059474269)},
      {carId = "bolt_pickup", position = MDM_Utils.GetVector(-905.54279,-214.16341,3.0409355), direction = MDM_Utils.GetVector(-0.96589297,-0.25770497,0.025275096)}

    },
    allyNpcs = {
      {npcId="5874491335140879700",position=MDM_Utils.GetVector(-908.85223,-227.08142,2.808135),direction=MDM_Utils.GetVector(0.99617749,0.087352395,0)},
    },
    waves = {
      {
        title = "Wave 1 - They are coming from the North",
        restorePlayer = true,
        preparationTime = 10,
        enemies = {
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-877.54053,-179.31276,2.8210607), direction=MDM_Utils.GetVector(-0.91717273,-0.39848995,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-909.6463,-188.8774,2.8385715),direction= MDM_Utils.GetVector(0.51778549,-0.85551047,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-898.08289,-183.80492,2.7595434),direction= MDM_Utils.GetVector(-0.23320645,-0.97242725,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-892.63867,-181.422,2.7360954), direction=MDM_Utils.GetVector(-0.15583517,-0.98778307,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-900.65839,-176.99596,2.7371385), direction=MDM_Utils.GetVector(-0.19901529,-0.97999644,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-895.70215,-174.4108,2.7366309), direction=MDM_Utils.GetVector(-0.21996461,-0.97550786,0), battleArchetype = "archetype_triggerman_base_pol"}
        }
      },
      {
        title = "Wave 2 - They are coming from the South",
        restorePlayer = true,
        preparationTime = 10,
        enemies = {
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-912.276,-272.20651,2.7572498), direction=MDM_Utils.GetVector(0.77677119,0.62978292,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-902.5733,-281.51898,2.6639752), direction=MDM_Utils.GetVector(-0.45808861,0.88890654,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-890.86993,-274.1214,2.6641729),direction= MDM_Utils.GetVector(-0.39807889,0.91735119,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-884.85193,-272.28378,2.7870576),direction= MDM_Utils.GetVector(-0.26791304,0.9634431,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-882.34644,-270.70609,2.8150592),direction= MDM_Utils.GetVector(-0.1980121,0.98019958,0), battleArchetype = "archetype_triggerman_base_pol"},
          {npcId="13604348442857333985", position = MDM_Utils.GetVector(-896.8877,-297.81766,2.793437),direction= MDM_Utils.GetVector(-0.051288676,0.99868387,0), battleArchetype = "archetype_triggerman_base_pol"}
        }
      }
    }
  })

  return mission
end

function MDM_SalieriMissions.M4_GangWar2()
  local wave1Npcs = {
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1341.6405,60.678833,3.3377147), direction = MDM_Utils.GetVector(0.057904456,-0.99832207,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1338.4283,61.330421,3.4274106), direction = MDM_Utils.GetVector(-0.1250236,-0.9921537,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1333.8378,60.914726,3.4938006), direction = MDM_Utils.GetVector(0.83252376,-0.55398923,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1336.9178,64.083038,3.4031191), direction = MDM_Utils.GetVector(-0.029945441,-0.99955148,0), battleArchetype = "archetype_triggerman_base_pol"}
  }

  local wave2NPCs = {
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1379.2908,20.443228,3.3324304), direction = MDM_Utils.GetVector(0.99984968,0.017331241,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1378.7825,23.249542,3.3157849), direction = MDM_Utils.GetVector(0.8313151,0.55580127,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1378.5864,25.967979,3.2988653), direction = MDM_Utils.GetVector(0.9989906,-0.044919487,0), battleArchetype = "archetype_triggerman_base_pol"}
  }

  local wave3NPCs = {
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1339.7012,-24.598413,4.0049219), direction = MDM_Utils.GetVector(-0.030802596,0.99952543,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1335.7605,-24.900768,4.0430508), direction = MDM_Utils.GetVector(-0.024835717,0.99969149,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1332.0574,-24.968515,4.0788627), direction = MDM_Utils.GetVector(-0.013719424,0.99990582,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1328.6531,-25.033279,4.1118484), direction = MDM_Utils.GetVector(-0.01357092,0.99990785,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1331.3779,-20.022778,4.0834484), direction = MDM_Utils.GetVector(-0.16082166,0.98698342,0), battleArchetype = "archetype_triggerman_base_pol"},
    {npcId="13604348442857333985", position= MDM_Utils.GetVector(-1336.2496,-19.2791,4.05158), direction = MDM_Utils.GetVector(-0.61400998,0.78929818,0), battleArchetype = "archetype_triggerman_base_pol"},
  }

  local carAssets = {
    {carId = "shubert_e_six", position = MDM_Utils.GetVector(-1332.9858,9.4035025,4.2480459), direction = MDM_Utils.GetVector(-0.95426929,-0.29860383,0.014352869)},
    {carId = "shubert_e_six", position = MDM_Utils.GetVector(-1339.9849,10.249894,4.169414), direction = MDM_Utils.GetVector(0.94146079,-0.33535159,0.03451445)},
    {carId = "shubert_e_six", position = MDM_Utils.GetVector(-1335.6543,24.85214,4.0719504), direction = MDM_Utils.GetVector(-0.9127509,0.40821823,-0.015609706)},
    {carId = "bolt_delivery", position = MDM_Utils.GetVector(-1341.9893,26.62381,3.9106264), direction = MDM_Utils.GetVector(0.99264538,-0.11264583,0.044340719)},
    {carId = "shubert_six", position = MDM_Utils.GetVector(-1349.9421,22.056082,3.5512807), direction = MDM_Utils.GetVector(0.046726886,-0.99883455,0.012112266)}
  }

  local allyNpcs = {
    {npcId= "5874491335140879700", position= MDM_Utils.GetVector(-1330.4849,16.178551,3.9502649), direction = MDM_Utils.GetVector(-0.95933074,0.28228405,0)}
  }

  local mission = MDM_GangWarMission:new({
    title = "Little Italy Gang War 2",
    startPosition = MDM_Utils.GetVector(-1330.4849,15.178551,3.9502649),
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
  local enemyCars1_light = {
    MDM_Car:new({carId = "shubert_e_six", position = MDM_Utils.GetVector(-891.53961,-175.98308,2.9105735), direction = MDM_Utils.GetVector(-0.42457402,-0.90538579,-0.0036094198),indestructable = true, lightsOn = true}),
    MDM_Car:new({carId = "bolt_truck", position = MDM_Utils.GetVector(-896.28357,-173.75388,3.1058621), direction = MDM_Utils.GetVector(-0.13210587,-0.99119651,-0.0088297259), indestructable = true, lightsOn = true}),
    MDM_Car:new({carId = "shubert_six", position = MDM_Utils.GetVector(-900.11688,-174.43999,2.8915193), direction = MDM_Utils.GetVector(-0.079025052,-0.99687004,0.0023694881), indestructable = true, lightsOn = true}),
    MDM_Car:new({carId = "falconer_classic", position = MDM_Utils.GetVector(-904.13879,-174.84245,3.0141106), direction = MDM_Utils.GetVector(0.34974024,-0.93684578,-0.0015406765), indestructable = true, lightsOn = true})
  }

  local enemyCars1_nolight = {
    MDM_Car:new({carId = "smith_v12", position = MDM_Utils.GetVector(-892.47552,-187.95558,2.9261396), direction = MDM_Utils.GetVector(-0.88356274,-0.46824974,-0.0077114701), indestructable = true}),
    MDM_Car:new({carId = "shubert_e_six", position = MDM_Utils.GetVector(-892.69537,-192.82971,2.9417343), direction = MDM_Utils.GetVector(-0.9915787,-0.12913372,0.0098076146), indestructable = true}),
    MDM_Car:new({carId = "shubert_e_six", position = MDM_Utils.GetVector(-903.54724,-188.91106,2.9339561), direction = MDM_Utils.GetVector(0.95047498,-0.3107619,0.0049449285), indestructable = true}),
    MDM_Car:new({carId = "bolt_model_b", position = MDM_Utils.GetVector(-906.65942,-183.04655,2.975781), direction = MDM_Utils.GetVector(0.92824286,-0.37086901,-0.028661601), indestructable = true})

  }

  local allyCars1 = {
    MDM_Car:new({carId = "shubert_e_six", position = MDM_Utils.GetVector(-898.6781,-206.9682,2.9882104), direction = MDM_Utils.GetVector(-0.99834269,0.057258766,-0.0057688723), indestructable = true}),
    MDM_Car:new({carId = "smith_v12", position = MDM_Utils.GetVector(-903.03925,-202.60851,2.9235554), direction = MDM_Utils.GetVector(0.97159564,0.23641084,0.010577699), indestructable = true}),
    MDM_Car:new({carId = "lassiter_v16_roadster", position = MDM_Utils.GetVector(-894.45197,-202.98668,2.9466419), direction = MDM_Utils.GetVector(-0.94317025,0.33142328,0.024261482), indestructable = true})
  }

  local enemyMachinegunners_1 = {
    MDM_NPC:new({npcId = "13296154699591050027", position = MDM_Utils.GetVector(-894.04907,-174.84938,2.7366309), direction = MDM_Utils.GetVector(-0.1944367,-0.98091507,0)}),
    MDM_NPC:new({npcId = "13296154699591050027", position = MDM_Utils.GetVector(-902.12329,-175.76057,2.7373047), direction = MDM_Utils.GetVector(-0.1944367,-0.98091507,0)})
  }

  local enemyShotgunners_1 = {
    MDM_NPC:new({npcId = "2624519215596331124", position = MDM_Utils.GetVector(-898.56555,-174.58881,2.7366204), direction = MDM_Utils.GetVector(0.41528636,-0.90969074,0)}),
    MDM_NPC:new({npcId = "2624519215596331124", position = MDM_Utils.GetVector(-907.46515,-180.68529,2.8499207), direction = MDM_Utils.GetVector(0.22172351,-0.97510958,0)})
  }

  -- We set the battleArchetype to "archetype_triggerman_base_pol" as we do not want the triggermen to constantly spam us with molotovs.
  local enemyGunners_1 = {
    MDM_NPC:new({npcId = "18187434932497386406", position = MDM_Utils.GetVector(-909.88092,-181.22871,2.8536987), direction = MDM_Utils.GetVector(0.18648589,-0.98245764,0), battleArchetype = "archetype_triggerman_base_pol"}),
    MDM_NPC:new({npcId = "18187434932497386406", position = MDM_Utils.GetVector(-905.64447,-181.34718,2.736156), direction = MDM_Utils.GetVector(0.18581454,-0.98258483,0), battleArchetype = "archetype_triggerman_base_pol"}),
    MDM_NPC:new({npcId = "18187434932497386406", position = MDM_Utils.GetVector(-902.89764,-187.10097,2.7580409), direction = MDM_Utils.GetVector(0.35274372,-0.93571997,0), battleArchetype = "archetype_triggerman_base_pol"}),
    MDM_NPC:new({npcId = "18187434932497386406", position = MDM_Utils.GetVector(-893.53784,-191.03168,2.7702768), direction = MDM_Utils.GetVector(-0.23014002,-0.97315753,0), battleArchetype = "archetype_triggerman_base_pol"}),
    MDM_NPC:new({npcId = "18187434932497386406", position = MDM_Utils.GetVector(-892.18762,-185.425,2.7367439), direction = MDM_Utils.GetVector(-0.28345007,-0.958987,0), battleArchetype = "archetype_triggerman_base_pol"}),
    MDM_NPC:new({npcId = "18187434932497386406", position = MDM_Utils.GetVector(-889.97803,-176.84952,2.7367396), direction = MDM_Utils.GetVector(-0.38724083,-0.92197859,0), battleArchetype = "archetype_triggerman_base_pol"}),
    MDM_NPC:new({npcId = "18187434932497386406", position = MDM_Utils.GetVector(-905.47607,-171.23624,2.7371027), direction = MDM_Utils.GetVector(0.39135718,-0.92023885,0), battleArchetype = "archetype_triggerman_base_pol"}),
    MDM_NPC:new({npcId = "18187434932497386406", position = MDM_Utils.GetVector(-890.77386,-172.79179,2.7366362), direction = MDM_Utils.GetVector(-0.90468264,-0.42608595,0), battleArchetype = "archetype_triggerman_base_pol"}),
    MDM_NPC:new({npcId = "18187434932497386406", position = MDM_Utils.GetVector(-899.83588,-171.56589,2.7373915), direction = MDM_Utils.GetVector(0.7722798,-0.63528252,0), battleArchetype = "archetype_triggerman_base_pol"})

  }

  local allyNpcs1 = {
    MDM_NPC:newAlly({npcId = "17582426933065501070", position = MDM_Utils.GetVector(-903.9118,-204.3454,2.7654061), direction = MDM_Utils.GetVector(0.95016724,0.31174058,0)}),
    MDM_NPC:newAlly({npcId = "5874491335140879700", position = MDM_Utils.GetVector(-893.06909,-205.6087,2.7583747), direction = MDM_Utils.GetVector(-0.27516028,0.96139836,0)})
  }

  local enemyNpcs1 = {}
  MDM_Utils.AddAll(enemyNpcs1,enemyMachinegunners_1)
  MDM_Utils.AddAll(enemyNpcs1,enemyShotgunners_1)
  MDM_Utils.AddAll(enemyNpcs1,enemyGunners_1)

  local cars1All = {}
  MDM_Utils.AddAll(cars1All,enemyCars1_light)
  MDM_Utils.AddAll(cars1All,enemyCars1_nolight)
  MDM_Utils.AddAll(cars1All,allyCars1)


  local npcs1All = {}
  MDM_Utils.AddAll(npcs1All,enemyNpcs1)
  MDM_Utils.AddAll(npcs1All,allyNpcs1)

  local All1 = {}
  MDM_Utils.AddAll(All1,npcs1All)
  MDM_Utils.AddAll(All1,cars1All)

  local assets = {}
  MDM_Utils.AddAll(assets,All1)

  local mission = MDM_Mission:new({
    title = "The Camino Escalation",
    initialWeather = "temp_teaser_trailer",
    initialOutfit = "9354636703565519112", --Trenchcoat and hat
    startPosition = MDM_Utils.GetVector(-898.15344,-209.46974,2.8157277),
    startDirection = MDM_Utils.GetVector(-0.26472956,0.96432263,0),
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
    spawnables = All1
  })

  local objective_200_KillGroup1 = MDM_KillTargetsObjective:new({
    mission = mission,
    title = "Defend the bar!",
    targets = enemyNpcs1,
    onObjectiveStart = function() for _,e in ipairs(enemyNpcs1) do e:AttackPlayer() end end
  })

  mission:AddObjectives({
    objective_100_spawnerObjective,
    objective_200_KillGroup1
  })
  return mission
end

MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M1_BackyardTrouble", func = MDM_SalieriMissions.M1_BackyardTrouble})
MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M2_WhiskyWhopper", func = MDM_SalieriMissions.M2_WhiskyWhopper})
MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M3_GangWar1", func = MDM_SalieriMissions.M3_GangWar1})
MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M4_GangWar2", func = MDM_SalieriMissions.M4_GangWar2})
MDM_UnitTest.RegisterTest({name = "MDM_SalieriMissions.M5_The_Camino_Escalation", func = MDM_SalieriMissions.M5_The_Camino_Escalation})
