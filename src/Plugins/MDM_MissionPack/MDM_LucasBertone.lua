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
MDM_LucasBertone = {}

local pos_SalierisBar = MDM_LocationPositions.SALIERIS_BAR_GARAGE_FRONTDOOR--MDM_Utils.GetVector(-907.94,-210.41,2)
-- MDM_Utils.GetVector(437.38721,38.019478,12.10504)
local pos_BertonesAutoservice = MDM_LocationPositions.BERTONES_AUTOSERVICE_FRONTDOOR --real location
--local pos_BertonesAutoservice = MDM_Utils.GetVector(-907.94,-180.41,2) -- fake location at Salieris bar

function MDM_LucasBertone.M1_1_Fairplay()
  local smithV12Car = MDM_Car:new("smith_v12",MDM_Utils.GetVector(-180.402725,-897.841553,2.624493),MDM_Utils.GetVector(-0.021050,0.999603,-0.018721))
  smithV12Car:SetPrimaryColor(150,100,0)

  -- Create mission
  local mission = MDM_Mission:new({
    title = "Lucas Bertone 1-1 - Fairplay",
    initialOutfit = "7399986759921114297",
    initialWeather = "mm_050_race_cp_120",
    initialSeason = 2 --1932
  })
  -- Objective1: Get in the parked car.
  -- No need to spawn the car manually. The objective does that for us on start.
  -- If the car is already spawned it wont be spawned again.
  local objective1 = MDM_GetInCarObjective:new({
    car = smithV12Car,
    title = "Steal the Smith V12",
    task = "Steal the Smith V12","Go to the marked location",
    description = "Steal the parked vehicle and try not to get spottet"
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

  -- Create the director that notifies the HUD when the player is not in the vehicle.
  -- Only active while objective2 is running.
  local director= MDM_PlayerInCarBannerDirector:new ({
    car = smithV12Car
  })
  MDM_ActivatorUtils.RunWhileObjective(director,objective2)

  MDM_MissionManager.StartMission(mission)
end

function MDM_LucasBertone.M2_1_TripToTheCountry()
  local M2_1_introText = "Ah Tommy, just the man I need.\nAn informant told me the police is after one of my friends.\nWe need to warn him before it's too late!\nHis house is in Hoboken.\nCan you do that for me Tommy?"
  local M2_1_outroText = "Thank you Tommy.\nI have a gift for you.\nThis one's brand new.\nThe first car with an aerodynamic body.\nSome people are not impressed but I certainly am.\nAnd thievefriendly too.\nJust stick in this whire and you're done.\nA guy in Oakwood owns the same car.\nHe parked it in front of his house."
  local boltCar = MDM_Car:new("bolt_v8",MDM_Utils.GetVector(1710.9281,528.12469,3.0614924),MDM_Utils.GetVector(-0.27043605,-0.96266121,0.012160566))

  local mission = MDM_Mission:new({
    initialOutfit = "9354636703565519112", --Trenchcoat and hat
    initialWeather = "mm_100_farm_cp_080",
    initialSeason = 3, --1933
    outroText = M2_1_outroText,
    --    startPosition = MDM_Utils.GetVector(1714.9164,529.63013,2.7865424),
    title = "Lucas Bertone 2-1 - A Trip To The Country"
  })

  --Objective1: Visit Lucas Bertone
  local objective1 = MDM_GoToObjective:new({
    title = "Visit Lucas Bertone",
    position = pos_BertonesAutoservice,
    radius = 2
  })
  mission:AddObjective(objective1)

  --Objective2: Warn Lucas' friend
  local objective2 = MDM_GoToObjective:new({
    introText = M2_1_introText,
    position = MDM_Utils.GetVector(1463.5498,210.33923,9.577445),
    radius = 2,
    title = "Warn Lucas' friend!"
  })
  mission:AddObjective(objective2)

  MDM_MissionUtils.RunTimerBetweenObjectives(mission,objective2, objective2, 300, function() mission:Fail() end)

  --Objective3: Drive back to Lucas Bertone
  local objective3 = MDM_GoToObjective:new({
    introText = "Are you crazy? Do you know what time it is?\nWhat the cops are on their way?\nShit, I need to get the hell out of here.\nI'll go through the backdoor.\nThank Lucas from me and you too man.",
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Drive back to Lucas Bertone"
  })
  mission:AddObjective(objective3)

  mission:AddAssets({boltCar})

  if MDM_MissionManager.StartMission(mission) then
    boltCar:Spawn()
  end
end

function MDM_LucasBertone.M2_2_TripToTheCountry()
  local car_culver = MDM_Car:new("culver_airmaster",MDM_Utils.GetVector(1455.7325,-645.18976,45.83866),MDM_Utils.GetVector(0.20905077,-0.97790265,-0.0020436067))

  local mission = MDM_Mission:new({
    initialWeather = "mm_100_farm_cp_080",
    initialOutfit = "9354636703565519112", --Trenchcoat and Hat
    title = "Lucas Bertone 2-2 - A Trip To The Country"
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

  MDM_MissionManager.StartMission(mission)
end

function MDM_LucasBertone.M3_1_Omerta()
  local M3_1_introText = "A guy from Oakwod has beaten up one of my guys.\nA guy from the Black Cat bar. Someone needs to teach him a lesson.\nBut don't kill him. Just give him one or two good punches.\nAnd say him it's a lesson from Carlo."
  local npc_big_stan = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-1040.7507,-302.92154,4.3719287),MDM_Utils.GetVector(-0.67485845,0.73794723,0))

  local mission = MDM_Mission:new({
    initialWeather = "mm_110_omerta_cp_050_cs_safehouse",
    introText = M3_1_introtext,
    title = "Lucas Bertone 3-1 - Omerta"
  })

  -- Visit Lucas Bertone
  local objective1 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Visit Lucas Bertone"
  })
  mission:AddObjective(objective1)

  -- Teach Big Stan a lesson
  local objective2 = MDM_HurtNPCObjective:new({
    npc = npc_big_stan,
    threshold = 85,
    title = "Teach Big Stan a lesson - He's at the former Black Cat bar"
  })
  mission:AddObjective(objective2)

  -- Back to Lucas Bertone
  local objective3 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    title = "Go back to Lucas Bertone"
  })
  mission:AddObjective(objective3)

  if MDM_MissionManager.StartMission(mission) then
    MDM_Utils.SpawnAll({npc_big_stan})
  end
end

function MDM_LucasBertone.M3_2_Omerta()
  local car_berkley = MDM_Car:new("berkley_810",MDM_Utils.GetVector(2127.3906,-252.37337,122.8),MDM_Utils.GetVector(-0.99890906,-0.045765243,-0.0092927944))
  car_berkley:SetPrimaryColor(255,136,0)

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

  MDM_MissionManager.StartMission(mission)
end

function MDM_LucasBertone.M4_1_LuckyBastard()
--friend1 (-1046.58,533.24939,17.959492) Dir: (-0.64350677,-0.76544046,0)
--friend2 (-1046.8413,530.35669,17.959166) Dir: (-0.88415533,-0.46719313,0)
-- doctor (1478.233,-375.38785,48.744034)
end

function MDM_LucasBertone.M5_1_CremeDeLaCreme()
  -- We prepare all cars that we need during the mission
  -- We need a local variable for the shubert as we need to access it directly later.
  local car_shubert = MDM_Car:new("shubert_e_six",MDM_Utils.GetVector(446.40228,30.989382,12.288987),MDM_Utils.GetVector(0.3100757,-0.95071179,0.00070346153))

  local car_assets = {
    car_shubert,
    MDM_Car:new("bolt_ace_pickup", MDM_Utils.GetVector(2088.7234,-915.70911,34.317371), MDM_Utils.GetVector(0.47644749,0.8786763,-0.030425811)),
    MDM_Car:new("bolt_pickup", MDM_Utils.GetVector(2039.1796,-746.21606,53.322742), MDM_Utils.GetVector(0.98174202,-0.18941244,-0.017485484)),
    MDM_Car:new("bolt_truck",MDM_Utils.GetVector(2085.188,-911.09637,34.2),MDM_Utils.GetVector(0.83328521,0.55257672,-0.017171353))
  }

  local pos_lighthouse = MDM_Utils.GetVector(2128.7178,-912.16492,30.68644)
  --  pos_lighthouse = MDM_Utils.GetVector(446.40228,30.989382,12.288987) --for testing at lucas' garage

  local mission = MDM_Mission:new({
    initialWeather = "mm_170_plane_cp_060_cine_1750_plane_airport",
    initialOutfit = "9354636703565519112",
    outroText = "Thank you Tommy.",
    startPosition = MDM_LocationPositions.BERTONES_AUTOSERVICE_FRONTDOOR,
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
  local damageMonitor = MDM_CarDamageDetector:new({car = car_shubert, threshold = 100, flagMotorDamage = true, flagCarDamage = true})
  local damageDirector = MDM_DetectorDirector:new({
    mission = mission,
    detector = damageMonitor,
    callback = function () mission:Fail("You did not destroy the car in the right location!") end
  })
  MDM_ActivatorUtils.RunBetweenObjectives(damageDirector,objective2,objective3)

  mission:AddAssets(car_assets)
  MDM_MissionManager.StartMission(mission)
end

function MDM_LucasBertone.M5_2_CremeDeLaCreme()
  local car_celeste = MDM_Car:new("celeste_mark_5",MDM_Utils.GetVector(534.76263,414.78525,19.954273),MDM_Utils.GetVector(0.022378264,-0.99973452,0.005499539))

  local npc_enemy1 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(540.3476,425.81726,19.782795),MDM_Utils.GetVector(-0.35471952,-0.93497276,0))
  local npc_enemy2 = MDM_NPC:new("18187434932497386406",MDM_Utils.GetVector(519.13971,426.54214,19.845762),MDM_Utils.GetVector(-0.5401746,-0.84155297,0))


  local mission = MDM_Mission:new({
    title = "Lucas Bertone 5-2 - Creme de la Creme",
    initialWeather = "mm_170_plane_cp_060_cine_1750_plane_airport ",
    initialOutfit = "9354636703565519112"
  })

  mission:AddObjective(MDM_RestorePlayerObjective:new())

  local objective1 = MDM_GetInCarObjective:new({
    car = car_celeste,
    title = "Steal the Celeste Mark 5 from the diner."
  })
  mission:AddObjective(objective1)

  local objective2 = MDM_GoToObjective:new({
    position = pos_SalierisBar,
    title = "Drive back to Salieri's bar"
  })
  mission:AddObjective(objective2)

  mission:AddAssets({car_celeste,npc_enemy1,npc_enemy2})
  if MDM_MissionManager.StartMission(mission) then
    car_celeste:Spawn()
    npc_enemy1:Spawn()
    npc_enemy2:Spawn()
  end
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
    title = "Visit Lucas Bertone"
  })
  mission:AddObjective(objective1)

  local objective2 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-1735.0616,-477.45865,2.6067872),
    radius = 8,
    title = "Pick up Lucas' friend.",
    introText = "Pick up my friend.",
    onObjectiveStart = function() npc_friend:Spawn() end,
    onObjectiveEnd = function() npc_friend:MakeAlly(true) end
  })
  mission:AddObjective(objective2)

  MDM_MissionUtils.RunTimerBetweenObjectives(mission,objective2, objective2, 300, function() mission:Fail() end)

  local objective3 = MDM_GoToObjective:new({
    position = pos_BertonesAutoservice,
    radius = 4,
    title = "Drive back to Lucas Bertone",
    onObjectiveStop = function() npc_friend:MakeAlly(false) end
  })
  mission:AddObjective(objective3)

  mission:AddAssets({npc_friend})
  if MDM_MissionManager.StartMission(mission) then
  end
end

function MDM_LucasBertone.M6_2_Election()
  local car_apollon = MDM_Car:new("lassiter_v16_appolyon",MDM_Utils.GetVector(1860.8296,-371.40375,107.90319),MDM_Utils.GetVector(-0.021005129,0.99971157,-0.011642429))

  local mission = MDM_Mission:new({
    title = "Lucas Bertone 6-2 - Election Campaign",
    initialWeather = "mm_180_sniper_cp_010",
    initialOutfit = "9354636703565519112"
  })

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
  if MDM_MissionManager.StartMission(mission) then
    car_apollon:Spawn()
  end
end

function MDM_LucasBertone.M7_1_Robbery()
  local car_schubert = MDM_Car:new("shubert_e_six",MDM_Utils.GetVector(503.34198,-723.47284,4.4603772),MDM_Utils.GetVector(-0.0096728336,0.99994606,-0.0037835632))
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
    onObjectiveStart = function() npc_bigdick:Spawn(); car_schubert:Spawn()end
  })
  mission:AddObjective(objective2)

  -- Eliminate enemys
  -- Objective spawns the enemies on start if we haven't done it yet.
  local objective3 = MDM_KillTargetsObjective:new({
    targets = enemy_assets,
    title = "Help Big Dick",
    outroText = "You're not as useless as you look.\nThanks for your help and greet Lucas from me.",
    onObjectiveStart = function() npc_bigdick:MakeAlly(true) end,
    onObjectiveStop = function() npc_bigdick:MakeAlly(false) end
  })
  mission:AddObjective(objective3)

  for _,e in ipairs(enemy_assets) do e:AttackPlayer() end

  -- Disabling the police in the zone where the shooting is happening.
  -- We only activate it during the neccessary objectives.
  local noPoliceZoneDirector = MDM_PoliceFreeZoneDirector:new({position = MDM_Utils.GetVector(506.13187,-711.24323,4.2604446),radius = 60})
  MDM_ActivatorUtils.EnableOnObjectiveStart(noPoliceZoneDirector,objective2)
  MDM_ActivatorUtils.DisableOnObjectiveStop(noPoliceZoneDirector,objective3)
  mission:AddDirector(noPoliceZoneDirector)

  -- Visit Lucas Bertone
  local objective4 = MDM_GoToObjective:new({
    mission = mission,
    position = pos_BertonesAutoservice,
    radius = 2,
    title = "Go back to Lucas Bertone"
  })
  mission:AddObjective(objective4)

  MDM_MissionManager.StartMission(mission)
end

function MDM_LucasBertone.M7_2_Robbery()
  local car_trautenberg = MDM_Car:new("trautenberg_sport",MDM_Utils.GetVector(1582.7761,-513.8941,49.780258),MDM_Utils.GetVector(-0.0058350917,0.99998069,-0.0021573838))

  local m = MDM_Mission:new({
    title = "Lucas Bertone 7-2 - Moonlighting",
    initialWeather = "mm_110_omerta_cp_050_cs_safehouse",
    initialOutfit = "7399986759921114297",
    introText = "Steal the Trautenberg from the Oak Wood Junior High-School"
  })

  m:AddAssets(car_trautenberg)
  MDM_RestorePlayerObjective:new (m)

  local objective1 = MDM_GetInCarObjective:new({
    car = car_trautenberg,
    title = "Steal the Trautenberg from the Oak Wood Junior High-School"
  })
  m:AddObjective(objective1)

  if  MDM_MissionManager.StartMission(m) then
    car_trautenberg:Spawn()
  end
end





















