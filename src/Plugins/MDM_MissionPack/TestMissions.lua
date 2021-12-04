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

TestMissions = {}

local objBlip = nil
function TestMissions.Test()

  --game.hud:TemperatureGaugeShow(true) Überhitzungsanzeige und Wert setzen
  --game.hud:SetTemperatureGaugeValue(20)

  -- Movie ????===? "cine_0400_motel_intro"
  if not objBlip then
    local pos = MDM_Utils.GetVector(506.13187,-711.24323,4.2604446)
    print("Show: ")
    objBlip = game.navigation:RegisterCircle(pos.x, pos.y, 60, "", "", 4, true)
  else
    print("Hide")
    HUD_UnregisterIcon(objBlip)
    objBlip = nil
  end


  --  local ent = game.game:CreateCleanEntity(Utils_GetVector(-907.94,-180.41,2), 0, false, false, true)
  --  ent:SetPos(pos)
  --  ent:SetDir(Utils_GetVector(0,0,0))
  --  local entWrapComp = ent:GetComponent("C_EntityWrapperComponent")
  --  entWrapComp:SetGameEntityType(enums.EntityType.ITEM_NAVDUMMY)
  --  entWrapComp:SetModelName("spawn_special")
  --  ent:AddComponent("C_SpawnerComponent")
  --  ent:AddComponent("C_RuntimeSpawnerComponent")
  --  ent:SetModelName("lh_news_stand_a_v1")
  --
  --  local  spawner_ent = ent:GetComponent("C_RuntimeSpawnerComponent")
  --  spawner_ent:Activate()
  --  ent:SetSpawnProfile("XXXXXXXXXX")
  --  Wait(ent:GetSpawnProfileLoadSyncObject())
  --  local output = ent:CreateObject()

  --game.navigation:RegisterHighDamageObjectivePos(Utils_GetVector(-907.94,-180.41,2),"STR","STR2","STR3")
  --game.navigation:RegisterStashHouseEntity("rr",3,3,"icon",true)
  --game.navigation:RegisterStashHousePos(Utils_GetVector(-907.94,-180.41,2),20,"hideout","icon",true)
  MDM_MissionManager.HideMenu()

  --game.hud:TailingGaugeShow(true) --Abstandsanzeige
  --game.hud:SetTailingGaugeValue(50) -- Abstandsanzeige Wert setzen

  --game.hud:DamageGaugeShow(true) --Anzeige Fahrzeugschaden
  --game.hud:SetDamageGaugeValue(50) -- Wert für Anzeige Fahrzeugschaden

  --game.hud:StartCountDown(20) Countdown vom Rennen
end

function TestMissions.DuelTest()

  --- @param enemyNpcs = MDM_NPC instances
  --- @param allyNpcs = MDM_NPC instances
  local function DuelTestMission(args)

    if not args.enemyNpcs then
      error("enemyNpcs not set",2)
    end

    if #args.enemyNpcs < 1 then
      error("enemyNpcs is empty",2)
    end

    if not args.allyNpcs then
      error("allyNpcs not set",2)
    end

    if #args.allyNpcs < 1 then
      error("allyNpcs is empty",2)
    end

    local mission = MDM_Mission:new(args)
    mission:OnMissionStart(function()
      MDM_Utils.SpawnAll(args.enemyNpcs)
      MDM_Utils.SpawnAll(args.allyNpcs)
    end)
    -- mission:OnMissionEnd(function() MDM_Utils.DespawnAll(assets) end)
    mission:AddAssets(args.allyNpcs)
    mission:AddAssets(args.enemyNpcs)

    local objective1_waitForSpawns = MDM_CallbackObjective:new ({
      title = "Spawntime",
      callback = function ()
        if not MDM_SpawnUtils.AreAllSpawned(args.allyNpcs) then return false end
        if not MDM_SpawnUtils.AreAllSpawned(args.enemyNpcs) then return false end

        local enemyIndex = 1
        for _,a in ipairs(args.allyNpcs) do
          if enemyIndex > #args.enemyNpcs then
            enemyIndex = 1
          end
          a:GetGameEntity():Attack(args.enemyNpcs[enemyIndex]:GetGameEntity())
          enemyIndex = enemyIndex + 1
        end

        return true
      end,
    })

    local objective100_KillTargets = MDM_KillTargetsObjective:new({
      title ="Take out your targets",
      targets = args.enemyNpcs
    })
    mission:AddObjective(objective100_KillTargets)

    mission:AddObjective(MDM_RestorePlayerObjective:new())

    return mission
  end


  local mission = DuelTestMission({
    title = "Duel Test",
    startPosition = MDM_Utils.GetVector(-1454.884,-453.95401,3.0223277),
    initialWeather = "mm_110_omerta_cp_050_cs_safehouse",
    enemyNpcs = {
      MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1444.2271,-488.13773,3.2395408), MDM_Utils.GetVector(-0.27127859,0.96250087,0)),
      MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1440.8369,-486.95615,3.2213628), MDM_Utils.GetVector(-0.2992492,0.954175,0)),
      MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1437.6008,-485.80936,3.222491), MDM_Utils.GetVector(-0.29935825,0.95414078,0)),
      MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1436.2045,-482.95331,3.1876981), MDM_Utils.GetVector(-0.94076848,0.3390497,0)),
      MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1437.4296,-491.64578,3.1564496), MDM_Utils.GetVector(-0.70401907,0.71018106,0)),
      MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1442.595,-491.52405,3.2064359), MDM_Utils.GetVector(-0.64396787,0.76505256,0)),
      MDM_NPC:new("13604348442857333985", MDM_Utils.GetVector(-1446.0928,-486.38669,3.2213938), MDM_Utils.GetVector(-0.62356263,0.78177339,0))
    },
    allyNpcs = {
      MDM_NPC:newFriend("13604348442857333985", MDM_Utils.GetVector(-1447.3892,-468.7261,3.1898816), MDM_Utils.GetVector(0.43327615,-0.90126121,0)),
      MDM_NPC:newFriend("13604348442857333985", MDM_Utils.GetVector(-1450.9735,-469.41238,3.1904457), MDM_Utils.GetVector(0.16622388,-0.98608804,0)),
      MDM_NPC:newFriend("13604348442857333985", MDM_Utils.GetVector(-1448.8175,-472.27847,3.1461122), MDM_Utils.GetVector(0.59389323,-0.80454385,0)),
      MDM_NPC:newFriend("13604348442857333985", MDM_Utils.GetVector(-1445.1748,-472.47644,3.1494639), MDM_Utils.GetVector(0.11688796,-0.99314511,0)),
      MDM_NPC:newFriend("13604348442857333985", MDM_Utils.GetVector(-1453.8947,-466.51282,3.1729071), MDM_Utils.GetVector(0.41520488,-0.90972793,0))
    }
  })

  MDM_Core.missionManager:StartMission(mission)
  return mission
end

function TestMissions.PursuitTest()
  local car_target = MDM_Car:new("smith_v12", MDM_Utils.GetVector(-898.98346,-190.64536,2.9552386), MDM_Utils.GetVector(0.028562285,0.99954069,-0.010129704))
  local npc_target = MDM_NPC:newFriend("13604348442857333985",MDM_Utils.GetVector(-907.94,-180.41,25),MDM_Utils.GetVector(0,0,0))
  local npc_target2 = MDM_NPC:newFriend("13604348442857333985",MDM_Utils.GetVector(-907.98,-180.41,25),MDM_Utils.GetVector(0,0,0))
  local car_police = MDM_Car:new("shubert_e_six_p", MDM_Utils.GetVector(-899.25092,-203.29758,2.9997153), MDM_Utils.GetVector(-0.0055011963,0.99997598,-0.0042084511))
  local npc_police = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-907.94,-180.41,2),MDM_Utils.GetVector(0,0,0))
  local car_player = MDM_Car:new("shubert_e_six", MDM_Utils.GetVector(-899.16278,-225.84026,2.977174), MDM_Utils.GetVector(0.044264518,0.99901813,-0.0018530977))

  local mission = MDM_Mission:new({
    title = "Carchase Test",
    startPosition = MDM_Utils.GetVector(-892.93268,-216.92448,2.9243827),
    initialWeather = "mm_180_sniper_cp_010"
  })

  mission:AddAssets({car_target,npc_target,npc_police,car_police,car_player,npc_target2})
  mission:OnMissionStart(function() MDM_Utils.SpawnAll({car_target,npc_police,car_police,npc_target,car_player,npc_target2})end)

  local objective1_waitForSpawns = MDM_CallbackObjective:new ({
    title = "Spawntime",
    callback = function ()
      if car_target:IsSpawned() and
        car_police:IsSpawned() and
        npc_police:IsSpawned() and
        npc_target:IsSpawned() and
        car_player:IsSpawned()
      then
        npc_target:GetGameEntity():GetInOutCar(car_target:GetGameEntity(),1,false,false)
        npc_target2:GetGameEntity():GetInOutCar(car_target:GetGameEntity(),2,false,false)
        car_target:GetGameEntity():InitializeAIParams(enums.CarAIProfile.PIRATE   ,enums.CarAIProfile.PIRATE   )
        car_target:GetGameEntity():SetMaxAISpeed(true,65)
        car_target:GetGameEntity():SetNavModeWanderArea(false,nil)

        npc_police:GetGameEntity():GetInOutCar(car_police:GetGameEntity(),1,false,false)
        car_police:GetGameEntity():InitializeAIParams(enums.CarAIProfile.PIRATE   ,enums.CarAIProfile.PIRATE   )
        car_police:GetGameEntity():SetMaxAISpeed(true,65)
        car_police:GetGameEntity():SetSirenOn(true)
        car_police:GetGameEntity():SetBeaconLightOn(true)
        car_police:GetGameEntity():SetNavModeHunt(npc_target:GetGameEntity(),5,  enums.CarHuntRole.FOLLOW    )

        getp():GetOnVehicle(car_player:GetGameEntity(), 1, false, "WALK")

        npc_target2:GetGameEntity():Attack( car_police:GetGameEntity())
        return true
      else
        return false
      end
    end,
  })
  mission:AddObjective(objective1_waitForSpawns)


  --  local objective2_Teleports = MDM_CallbackObjective:new ({
  --    title = "Teleporting",
  --    callback = function ()
  --      print("Teleporting!!!")
  --      enemyNpc:GetGameEntity():GetInOutCar(enemyCar:GetGameEntity(),1,false,false)
  --      getp():GetOnVehicle(playerCar:GetGameEntity(), 1, false, "WALK")
  --
  --      enemyCar:GetGameEntity():InitializeAIParams(enums.CarAIProfile.AGGRESSIVE   ,enums.CarAIProfile.AGGRESSIVE   )
  --      enemyCar:GetGameEntity():SetMaxAISpeed(true,60)
  --      enemyCar:GetGameEntity():SetNavModeWanderArea(false,nil)
  --      return true
  --    end
  --  })
  --  mission:AddObjective(objective2_Teleports)

  local objective3_Killtarget = MDM_KillTargetsObjective:new({
    title ="Take out your target",
    targets = {npc_target}
  })
  mission:AddObjective(objective3_Killtarget)

  MDM_Core.missionManager:StartMission(mission)
end

function TestMissions.CarchaseTest()
  local enemyCar = MDM_Car:new("smith_v12",MDM_Utils.GetVector(-898.71429,-181.9543,4),MDM_Utils.GetVector(-0,000001,-0.000004,0.000150))
  local enemyNpc = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-907.94,-180.41,2),MDM_Utils.GetVector(0,0,0))
  local playerCar = MDM_Car:new("smith_v12", MDM_Utils.GetVector(-898.67657,-205.45827,2.96613), MDM_Utils.GetVector(0.013172975,0.99991018,-0.0024737401))

  local mission = MDM_Mission:new({
    title = "Carchase Test",
    startPosition = MDM_Utils.GetVector(-904.78802,-206.16048,2.7450461)
  })

  mission:AddAssets({enemyCar,enemyNpc,playerCar})
  mission:OnMissionStart(function() MDM_Utils.SpawnAll({enemyCar,enemyNpc,playerCar})end)

  local objective1_waitForSpawns = MDM_CallbackObjective:new ({
    title = "Spawntime",
    callback = function ()
      if enemyCar:IsSpawned() and playerCar:IsSpawned() and enemyNpc:IsSpawned()then
        enemyNpc:GetGameEntity():GetInOutCar(enemyCar:GetGameEntity(),1,false,false)
        getp():GetOnVehicle(playerCar:GetGameEntity(), 1, false, "WALK")

        enemyCar:GetGameEntity():InitializeAIParams(enums.CarAIProfile.AGGRESSIVE   ,enums.CarAIProfile.AGGRESSIVE   )
        enemyCar:GetGameEntity():SetMaxAISpeed(true,60)
        enemyCar:GetGameEntity():SetNavModeWanderArea(false,nil)
        return true
      else
        return false
      end
    end
  })
  mission:AddObjective(objective1_waitForSpawns)


  --  local objective2_Teleports = MDM_CallbackObjective:new ({
  --    title = "Teleporting",
  --    callback = function ()
  --      print("Teleporting!!!")
  --      enemyNpc:GetGameEntity():GetInOutCar(enemyCar:GetGameEntity(),1,false,false)
  --      getp():GetOnVehicle(playerCar:GetGameEntity(), 1, false, "WALK")
  --
  --      enemyCar:GetGameEntity():InitializeAIParams(enums.CarAIProfile.AGGRESSIVE   ,enums.CarAIProfile.AGGRESSIVE   )
  --      enemyCar:GetGameEntity():SetMaxAISpeed(true,60)
  --      enemyCar:GetGameEntity():SetNavModeWanderArea(false,nil)
  --      return true
  --    end
  --  })
  --  mission:AddObjective(objective2_Teleports)

  local objective3_Killtarget = MDM_KillTargetsObjective:new({
    title ="Take out your target",
    targets = {enemyNpc}
  })
  mission:AddObjective(objective3_Killtarget)

  MDM_Core.missionManager:StartMission(mission)
end

function TestMissions.DestroyCarInAreaTest()
  local mission = MDM_Mission:new({title = "Destroy car in Area"})
  local car_smith = MDM_Car:new("smith_v12",MDM_Utils.GetVector(-898.71429,-181.9543,4),MDM_Utils.GetVector(-0,000001,-0.000004,0.000150))
  car_smith:Spawn()
  local objective = MDM_DestroyCarInAreaObjective:new({mission = mission, car = car_smith, position = MDM_Utils.GetVector(-898.71429,-181.9543,4), radius = 20})
  mission:AddObjective(objective)
  MDM_Core.missionManager:StartMission(mission)
end

function TestMissions.WaveTest()
  local enemyNpcs = {
    MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-887.94025,-228.11867,2.7994239),MDM_Utils.GetVector(-0.99984133,0.017813683,0)),
    MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-887.56146,-233.41458,2.8025167),MDM_Utils.GetVector(-0.97434926,0.22504109,0))
  }

  local mission = MDM_Mission:new({title = "Wave Tesmission"})

  local config = {enemies = enemyNpcs,
    mission = mission
  }

  MDM_RestorePlayerObjective:new(mission)
  local wave = MDM_WaveObjective:new(config)


  MDM_Core.missionManager:StartMission(mission)
end


function TestMissions.GangWarTest()
  local wave1Npcs = {
    MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-887.94025,-228.11867,2.7994239),MDM_Utils.GetVector(-0.99984133,0.017813683,0)),
    MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-887.56146,-233.41458,2.8025167),MDM_Utils.GetVector(-0.97434926,0.22504109,0))
  }

  local wave2NPCs = {
    MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-887.94025,-228.11867,2.7994239),MDM_Utils.GetVector(-0.99984133,0.017813683,0)),
    MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-887.56146,-233.41458,2.8025167),MDM_Utils.GetVector(-0.97434926,0.22504109,0))
  }

  local carAssets = {
    MDM_Car:new("shubert_six",MDM_Utils.GetVector(-903.09753,-229.61916,2.9170983),MDM_Utils.GetVector(-0.014218162,-0.99989843,0.0011345582))
  }

  local allyNpcs = {
    MDM_NPC:newFriend("5874491335140879700",MDM_Utils.GetVector(-908.85223,-227.08142,2.808135),MDM_Utils.GetVector(0.99617749,0.087352395,0)),
  }

  local wave1 = {
    enemies = wave1Npcs,
    title = "Wave 1"
  }

  local wave2 = {
    enemies = wave2NPCs,
    title = "Wave 2"
  }

  local warConfig = MDM_GangWarMission.GangWarConfiguration()
  warConfig.waves = {wave1}
  warConfig.carAssets = carAssets
  warConfig.allyNpcs = allyNpcs
  warConfig.initialPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR

  local mission = MDM_GangWarMission:new(warConfig)
  MDM_Core.missionManager:StartMission(mission)

  return mission
end

function TestMissions.KillMission()
  local npc1 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-907.94,-180.41,2),MDM_Utils.GetVector(0,0,0))
  local m = MDM_Mission:new({title = "TEST: Kill Targets"})
  m:AddObjective(MDM_RestorePlayerObjective:new ())

  m:AddObjective(MDM_KillTargetsObjective:new({mission = m, targets = {npc1}}))
  m:AddAssets(npc1)
  MDM_Mission.Start(m)
  npc1:Spawn()
  npc1:AttackPlayer()
  --  npc2:Spawn()
  --  npc3:Spawn()
  --  npc4:Spawn()
  MDM_Core.missionManager:StartMission(m)
end

function TestMissions.NPCHurtTest()
  local npc1 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-907.94,-180.41,2),MDM_Utils.GetVector(-0.67485845,0.73794723,0))

  local m = MDM_Mission:new({title = "Test NPC Hurt"})
  local objective1 = MDM_HurtNPCObjective:new({mission = m, npc = npc1, threshold = 80})
  objective1.title = "Hurt NPC - Threshold 80"
  objective1.task = "Hurt the NPC"
  m:AddObjective(objective1)

  if MDM_Core.missionManager:StartMission(m) then
    npc1:Spawn()
  end
end


function TestMissions.WaypointMission()
  local mission = MDM_Mission:new({title = "Waypoint Mission"})
  local objective1 = MDM_GoToObjective:new({mission = mission, position = MDM_Utils.GetVector(-907.94,-210.41,2)})
  objective1.title = "Objective 1"
  objective1.task = "Go to the marked location"
  objective1.description = "Blablabla"
  mission:AddObjective(objective1)

  local objective2 = MDM_GoToObjective:new({mission = mission, position = MDM_Utils.GetVector(-907.94,-180.41,2)})
  objective2.title = "Objective 2"
  objective2.task = "Go to the marked location"
  objective2.description = "Blablabla"
  mission:AddObjective(objective2)


  local objective3 = MDM_GoToObjective:new({mission = mission,position = MDM_Utils.GetVector(-907.94,-160.41,2)})
  objective3.title = "Objective 2"
  objective3.task = "Go to the marked location"
  objective3.description = "Blablabla"
  mission:AddObjective(objective3)

  MDM_Core.missionManager:StartMission(mission)
end

function TestMissions.EvadeMission()
  local m = MDM_Mission:new({title = "Evade Mission"})
  local objective_policeEvade = MDM_PoliceEvadeObjective:new ({mission = m, initialLevel = 1})
  objective_policeEvade:SetInitialWantedLevel(1)
  --  m:AddObjective(objective_policeEvade)
  MDM_Core.missionManager:StartMission(m)
end

function TestMissions.BannerTest()
  MissionManager.HideMenu()
  game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "Salieri - Backyard Trouble", "Some of Morello's gunmen were reported to hang around in our neighbourhood harassing pur people.\nThis can not be tolerated.\nSend Morello a message by taking them out.")
end

function TestMissions.GetInCar()
  local falconerCar = MDM_Car:new("berkley_810",MDM_Utils.GetVector(-898.71429,-181.9543,4),MDM_Utils.GetVector(-0,000001,-0.000004,0.000150))
  falconerCar:SetIndestructable(true)
  --    falconerCar:SetPrimaryColor(48,45,10)
  falconerCar:SetPrimaryColor(100,30,0)
  local mission = MDM_Mission:new({title = "Get in the Car"})

  -- Objective1: Get In The Car
  local objective1 = MDM_GetInCarObjective:new({mission = mission, car = falconerCar})
  objective1:SetInformation("Get in the car")
  mission:AddObjective(objective1)

  -- Objective2: Drive Back To Salieris
  local objective2 = MDM_GoToObjective:new({mission = mission,position = MDM_Utils.GetVector(-907.94,-210.41,2)})
  objective2:SetInformation("Drive back to Salieri's")
  mission:AddObjective(objective2)

  -- Create Player in Car Detector and Use it while Objective 2 is active
  local detector= MDM_PlayerInCarBannerDirector:new ({mission = mission, car = falconerCar})
  MDM_ActivatorUtils.RunWhileObjective(detector,objective2)

  local onCarDestroyed = function()
    mission:SetFailDescription("You destroyed the car")
    mission:Fail()
  end

  local damageMonitor = MDM_CarDamageDetector:new({car = falconerCar, threshold = 5, flagMotorDamage = true, flagCarDamage = true})
  local damageDetector = MDM_DetectorDirector:new({
    mission = mission,
    detector = damageMonitor,
    callback = onCarDestroyed
  })
  MDM_ActivatorUtils.RunWhileObjective(damageDetector,objective2)

  mission:AddAssets({falconerCar})
  MDM_Core.missionManager:StartMission(mission)
end

function TestMissions.HostileZoneTest()
  local position = MDM_Utils.GetVector(-907.94,-180.41,2)
  local npc1 = MDM_NPC:new("13604348442857333985",position,MDM_Utils.GetVector(0,0,0))

  local mission = MDM_Mission:new({
    title = "Hostile AreaTest"
  })

  local objective = MDM_KillTargetsObjective:new({
    targets = {npc1}
  })
  mission:AddObjective(objective)

  local hostileZone =  MDM_HostileZoneDirector:new({
    position = position,
    radius = 80,
    detectionRadius = 5,
    showArea = true,
    enemies = {npc1}
  }
  )

  MDM_ActivatorUtils.RunBetweenObjectives(hostileZone,objective,objective)

  mission:AddDirector(hostileZone)
  mission:AddAssets({npc1})
  MDM_Core.missionManager:StartMission(mission)
end
