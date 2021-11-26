-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

MDM_SalieriMissions = {}

function MDM_SalieriMissions.M1_BackyardTrouble()
  local M1_introText = "Some of Morello's gunmen were reported hanging around in our neighbourhood harassing our people.\nThis can not be tolerated.\nSend Morello a message and take them out."

  local car_schubert = MDM_Car:new("shubert_six",MDM_Utils.GetVector(-670.4494,-22.954449,3.3371413),MDM_Utils.GetVector(-0.32917213,-0.94427019,-0.0002347008))

  local npc1 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-683.10767,-15.692556,3.2338758),MDM_Utils.GetVector(0.6981827,-0.71591961,0))
  local npc2 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-681.30603,-24.531549,3.2201567),MDM_Utils.GetVector(0.41589907,0.90941077,0))
  local npc3 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-684.01532,-21.848021,3.352128),MDM_Utils.GetVector(0.9708972,0.23949677,0))
  local npc4 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-678.65411,-14.920903,3.2161522),MDM_Utils.GetVector(-0.31570739,-0.94885659,0))

  local m = MDM_Mission:new({
    title = "Salieri - Backyard Trouble",
    introText = M1_Introtext
  })

  m:AddObjective(MDM_RestorePlayerObjective:new())

  local objective1 = MDM_KillTargetsObjective:new({
    mission = m,
    targets = {npc1,npc2,npc3,npc4},
    title = "Take out Morello's henchmen in a nearby backyard",
    task = "Take out Morello's henchmen in a nearby backyard",
    onObjectiveStart = function() MDM_PlayerUtils.RestorePlayer() end
  })
  m:AddObjective(objective1)

  local objective2 = MDM_PoliceEvadeObjective:new ({
    mission = m,
    initialLevel = 2,
    title = "The police is on the way - Escape!"
  })
  m:AddObjective(objective2)

  local objective3 = MDM_GoToObjective:new({
    mission = m,
    position = MDM_Utils.GetVector(-907.94,-210.41,2),
    title = "Drive back to Salieri's Bar"
  })
  m:AddObjective(objective3)

  -- police should not interfere during the shooting. only afterwards.
  local noPoliceZoneDirector = MDM_PoliceFreeZoneDirector:new({position = MDM_Utils.GetVector(-671.66565,-10.197743,3.1811743), radius = 60})
  MDM_ActivatorUtils.RunWhileObjective(noPoliceZoneDirector,objective1)
  m:AddDirector(noPoliceZoneDirector)

  local assets = {npc1,npc2,npc3,npc4,car_schubert} -- Important to add single objects in brackets as method can only handle tables!!!
  m:AddAssets(assets)

  if MDM_MissionManager.StartMission(m) then
    MDM_Utils.SpawnAll(assets)
  end

  return m
end

function MDM_SalieriMissions.M2_WhiskyWhopper()
  local M2_introText = "Bottles of an exclusive Whisky were smuggled to Lost Heaven on a ship today\nOne of our men at the harbour stored it in a truck and hid it on a nearby compound.\nHe was supposed to meet Sam a few hours ago but he didn't show up.\nMaybe Morello has someting to do with that.\nGo to the compound, find out what happened and bring the truck to the meetingpoint."

  local npc_paulie = MDM_NPC:newFriend("5874491335140879700",MDM_Utils.GetVector(-634.74359,-272.58469,2.9996707),MDM_Utils.GetVector (-0.22052898,-0.97538036,0))

  local npc1 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(-918.92773,-706.95239,3.146647),MDM_Utils.GetVector(0.43737864,-0.89927745,0))
  local npc2 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(-921.99921,-711.38287,3.1582365),MDM_Utils.GetVector(0.70571977,-0.70849109,0))
  local npc3 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(-928.05493,-690.15259,3.061234),MDM_Utils.GetVector(-0.96647418,-0.2567637,0))
  local npc4 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(-913.62866,-690.31207,3.1151304),MDM_Utils.GetVector(-0.10116922,-0.99486923,0))
  local npc5 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(-909.53839,-699.11597,3.1243472),MDM_Utils.GetVector(-0.1667802,-0.9859941,0))
  local npc6 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(-922.41571,-744.79175,3.0986309),MDM_Utils.GetVector(-0.90848875,0.4179092,0))
  local npc7 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(-923.88202,-740.05048,3.093822),MDM_Utils.GetVector(-0.99298406,-0.11824846,0))
  local npc8 = MDM_NPC:new("9024609446539980771",MDM_Utils.GetVector(-922.49371,-728.50079,3.1785531),MDM_Utils.GetVector(0.60751921,-0.79430497,0))
  local npc9 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(-899.25873,-723.43848,3.1321092),MDM_Utils.GetVector(0.21112774,-0.97745848,0))
  local npc10 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(-915.8587,-745.17853,3.0953269),MDM_Utils.GetVector(0.70855165,-0.70565885,0))
  local npc_assets = {npc1,npc2,npc3,npc4,npc5,npc6,npc7,npc8,npc9,npc10}

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
    introText = M2_introText
  })

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
    position = MDM_Utils.GetVector(-905.73865,-721.30676,3.1869726),
    title = "Find the truck."
  })
  mission:AddObjective(objective2)

  local objective3 = MDM_GetInCarObjective:new({
    car = car_truck,
    title = "Find the truck."
  })
  mission:AddObjective(objective3)

  local noPoliceZoneDirector = MDM_PoliceFreeZoneDirector:new({position = MDM_Utils.GetVector(-903.87787,-729.97449,3.1465139), radius = 60})
  MDM_ActivatorUtils.EnableOnObjectiveStart(noPoliceZoneDirector,objective2)
  MDM_ActivatorUtils.DisableOnObjectiveStop(noPoliceZoneDirector,objective3)

  local objective4 = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Utils.GetVector(-1531.4517,-372.92609,2.9755383),
    introText = "Drive to the meeting area.",
    onObjectiveEnd = function() npc_paulie:MakeAlly(false) end
  })
  mission:AddObjective(objective4)

  mission:AddAssets(npc_assets)
  mission:AddAssets(car_assets)
  mission:AddAssets({npc_paulie})

  if MDM_MissionManager.StartMission(mission) then
    MDM_Utils.SpawnAll(car_assets)
    MDM_Utils.SpawnAll(npc_assets)
    MDM_Utils.SpawnAll({npc_paulie}) -- Important to put single objects in brackets as method can only handle tables!!!
  end

  return mission
end


function MDM_SalieriMissions.M3_GangWar1()
  local wave1Npcs = {
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-877.54053,-179.31276,2.8210607), MDM_Utils.GetVector(-0.91717273,-0.39848995,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-909.6463,-188.8774,2.8385715), MDM_Utils.GetVector(0.51778549,-0.85551047,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-898.08289,-183.80492,2.7595434), MDM_Utils.GetVector(-0.23320645,-0.97242725,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-892.63867,-181.422,2.7360954), MDM_Utils.GetVector(-0.15583517,-0.98778307,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-900.65839,-176.99596,2.7371385), MDM_Utils.GetVector(-0.19901529,-0.97999644,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-895.70215,-174.4108,2.7366309), MDM_Utils.GetVector(-0.21996461,-0.97550786,0))
  }

  local wave2NPCs = {
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-912.276,-272.20651,2.7572498), MDM_Utils.GetVector(0.77677119,0.62978292,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-902.5733,-281.51898,2.6639752), MDM_Utils.GetVector(-0.45808861,0.88890654,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-890.86993,-274.1214,2.6641729), MDM_Utils.GetVector(-0.39807889,0.91735119,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-884.85193,-272.28378,2.7870576), MDM_Utils.GetVector(-0.26791304,0.9634431,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-882.34644,-270.70609,2.8150592), MDM_Utils.GetVector(-0.1980121,0.98019958,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-896.8877,-297.81766,2.793437), MDM_Utils.GetVector(-0.051288676,0.99868387,0))

  }

  local carAssets = {
    MDM_Car:new("falconer_classic",MDM_Utils.GetVector(-902.37054,-245.55942,3.0346258),MDM_Utils.GetVector(0.96175694,-0.2737895,0.0079307277)),
    MDM_Car:new("shubert_e_six",MDM_Utils.GetVector(-892.20801,-244.26845,2.9532924),MDM_Utils.GetVector(-0.98323697,0.1810374,-0.021691686)),
    MDM_Car:new("bolt_v8",MDM_Utils.GetVector(-896.96661,-243.3506,3.0347798),MDM_Utils.GetVector(-0.99142301,0.13016272,0.011757697)),
    MDM_Car:new("houston_coupe_bv01",MDM_Utils.GetVector(-905.63287,-214.83951,3.0663233),MDM_Utils.GetVector(0.9260062,0.37677419,-0.023531549)),
    MDM_Car:new("shubert_e_six",MDM_Utils.GetVector(-899.86102,-213.72401,2.9817023),MDM_Utils.GetVector(-0.99989682,0.0066443244,-0.012744583)),
    MDM_Car:new("bolt_delivery",MDM_Utils.GetVector(-893.70294,-213.1147,2.9461083),MDM_Utils.GetVector(-0.99562818,0.093218289,0.0059474269)),
    MDM_Car:new("bolt_pickup", MDM_Utils.GetVector(-905.54279,-214.16341,3.0409355), MDM_Utils.GetVector(-0.96589297,-0.25770497,0.025275096))
  }

  local allyNpcs = {
    MDM_NPC:newFriend("5874491335140879700",MDM_Utils.GetVector(-908.85223,-227.08142,2.808135),MDM_Utils.GetVector(0.99617749,0.087352395,0)),
  }

  local wave1 = {enemies = wave1Npcs,
    title = "Wave 1 - They are coming from the North"
  }

  local wave2 = {enemies = wave2NPCs,
    title = "Wave 2 - They are coming from the South"
  }

  local warConfig = MDM_GangWarMission.GangWarConfiguration()
  warConfig.title = "Little Italy Gang War"
  warConfig.waves = {wave1,wave2}
  warConfig.carAssets = carAssets
  warConfig.allyNpcs = allyNpcs
  warConfig.initialPosition = MDM_LocationPositions.SALIERIS_BAR_FRONTDOOR

  local mission = MDM_GangWarMission:new(warConfig)
  MDM_MissionManager.StartMission(mission)

  return mission
end

function MDM_SalieriMissions.M4_GangWar2()
  local wave1Npcs = {
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1341.6405,60.678833,3.3377147), MDM_Utils.GetVector(0.057904456,-0.99832207,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1338.4283,61.330421,3.4274106), MDM_Utils.GetVector(-0.1250236,-0.9921537,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1333.8378,60.914726,3.4938006), MDM_Utils.GetVector(0.83252376,-0.55398923,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1336.9178,64.083038,3.4031191), MDM_Utils.GetVector(-0.029945441,-0.99955148,0))
  }

  local wave2NPCs = {
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1379.2908,20.443228,3.3324304), MDM_Utils.GetVector(0.99984968,0.017331241,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1378.7825,23.249542,3.3157849), MDM_Utils.GetVector(0.8313151,0.55580127,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1378.5864,25.967979,3.2988653), MDM_Utils.GetVector(0.9989906,-0.044919487,0))
  }

  local wave3NPCs = {
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1339.7012,-24.598413,4.0049219), MDM_Utils.GetVector(-0.030802596,0.99952543,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1335.7605,-24.900768,4.0430508), MDM_Utils.GetVector(-0.024835717,0.99969149,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1332.0574,-24.968515,4.0788627), MDM_Utils.GetVector(-0.013719424,0.99990582,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1328.6531,-25.033279,4.1118484), MDM_Utils.GetVector(-0.01357092,0.99990785,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1331.3779,-20.022778,4.0834484), MDM_Utils.GetVector(-0.16082166,0.98698342,0)),
    MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1336.2496,-19.2791,4.05158), MDM_Utils.GetVector(-0.61400998,0.78929818,0)),
  }

  local carAssets = {
    MDM_Car:new("shubert_e_six", MDM_Utils.GetVector(-1332.9858,9.4035025,4.2480459), MDM_Utils.GetVector(-0.95426929,-0.29860383,0.014352869)),
    MDM_Car:new("shubert_e_six", MDM_Utils.GetVector(-1339.9849,10.249894,4.169414), MDM_Utils.GetVector(0.94146079,-0.33535159,0.03451445)),
    MDM_Car:new("shubert_e_six", MDM_Utils.GetVector(-1335.6543,24.85214,4.0719504), MDM_Utils.GetVector(-0.9127509,0.40821823,-0.015609706)),
    MDM_Car:new("bolt_delivery", MDM_Utils.GetVector(-1341.9893,26.62381,3.9106264), MDM_Utils.GetVector(0.99264538,-0.11264583,0.044340719)),
    MDM_Car:new("shubert_six", MDM_Utils.GetVector(-1349.9421,22.056082,3.5512807), MDM_Utils.GetVector(0.046726886,-0.99883455,0.012112266))
  }

  local allyNpcs = {
    MDM_NPC:newFriend("5874491335140879700", MDM_Utils.GetVector(-1330.4849,16.178551,3.9502649), MDM_Utils.GetVector(-0.95933074,0.28228405,0))
  }

  local wave1 = {
    enemies = wave1Npcs,
    title = "Wave 1 - Attack from the north"
  }

  local wave2 = {
    enemies = wave2NPCs,
    title = "Wave 2 - Attack from the west"
  }

  local wave3 = {
    enemies = wave3NPCs,
    title = "Wave 3 - Attack from the south"
  }

  local warConfig = MDM_GangWarMission.GangWarConfiguration()
  warConfig.title = "Little Italy Gang War 2"
  warConfig.waves = {wave1,wave2,wave3}
  warConfig.carAssets = carAssets
  warConfig.allyNpcs = allyNpcs
  warConfig.initialPosition = MDM_Utils.GetVector(-1330.4849,15.178551,3.9502649)

  local mission = MDM_GangWarMission:new(warConfig)
  MDM_MissionManager.StartMission(mission)

  return mission
end
