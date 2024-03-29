TestMissions = {}

local objBlip = nil
function TestMissions.Test()

  --game.hud:TemperatureGaugeShow(true) �berhitzungsanzeige und Wert setzen
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
  --game.hud:SetDamageGaugeValue(50) -- Wert f�r Anzeige Fahrzeugschaden

  --game.hud:StartCountDown(20) Countdown vom Rennen
end

function TestMissions.BasicDetectionTest()
  local npc = MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Vector:new(-912.05573,-169.46973,2.8635244), direction = MDM_Vector:new(0.99868453,0.051275015,0)})
  local banner = MDM_Banner:new("")

  local detectionAi = MDM_AI_BasicDetection:new({
    positionSupplier = function() return npc:GetPosition() end,
    onDistanceAreaChanged = function(self, newDistance, oldDistance) banner.title = tostring(newDistance) banner:Show() end,
    onDetected = function() detected = true end
  })

  local mission = MDM_Mission:new({
    onMissionEnd = function() banner:Hide()end
  })

  mission:AddAsset(npc)

  local objective_1000 = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = {npc}
  })

  local objective_2000 = MDM_KillTargetsObjective:new({
    mission = mission,
    targets = {npc}
  })

  mission:AddObjectives({
    objective_1000,
    objective_2000
  })

  MDM_FeatureUtils.RunWhileEntitySpawned(detectionAi,npc)

  return mission
end

function TestMissions.PatrolTest()

  local npc = MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Vector:new(-1722.4747,300.64154,22.720945), direction = MDM_Vector:new(0.99868453,0.051275015,0)})

  local pos1 = MDM_Vector:new(-1737.3948,293.03293,21.158731)
  local pos2 = MDM_Vector:new(-1731.4111,282.30789,21.057386)
  local pos3 = MDM_Vector:new(-1718.8314,290.66013,22.497913)
  local pos4 = MDM_Vector:new(-1722.4747,300.64154,22.720945)

  local patrolAi = MDM_AI_NPC_BasicPatrol:new({
    npc = npc,
    positions = {
      pos1,
      pos2,
      pos3,
      pos4
    }
  })
  MDM_FeatureUtils.RunWhileEntitySpawned(patrolAi,npc)


  local mission = MDM_Mission:new({
    startPosition = MDM_Vector:new(-1711.4769,301.31213,23.593981)
  })

  mission:AddAsset(npc)

  local objective_1000 = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = {npc}
  })

  local objective_2000 = MDM_KillTargetsObjective:new({
    mission = mission,
    targets = {npc}
  })

  mission:AddObjectives({
    objective_1000,
    objective_2000
  })

  return mission
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

    local spawnables = MDM_List:new()
    spawnables:AddAll(args.allyNpcs)
    spawnables:AddAll(args.enemyNpcs)

    local mission = MDM_Mission:new(args)
    mission:AddAssets(spawnables)

    local objective50_spawnerObjective = MDM_SpawnerObjective:new({
      mission = mission,
      spawnables = spawnables
    })
    mission:AddObjective(objective50_spawnerObjective)

    local objective1_startAttack = MDM_CallbackObjective:new ({
      mission = mission,
      title = "Attack",
      callback = function ()
        local targetIndex = 1
        for _,ally in ipairs(args.allyNpcs) do
          if targetIndex > #args.enemyNpcs then
            targetIndex = 1
          end
          ally:GetGameEntity():Attack(args.enemyNpcs[targetIndex]:GetGameEntity())
          targetIndex = targetIndex + 1
        end

        targetIndex = 1
        for _,enemy in ipairs(args.enemyNpcs) do
          if targetIndex > #args.allyNpcs then
            targetIndex = 1
          end
          enemy:GetGameEntity():Attack(args.allyNpcs[targetIndex]:GetGameEntity())
          targetIndex = targetIndex + 1
        end
        return true
      end,
    })
    mission:AddObjective(objective1_startAttack)

    local objective100_KillTargets = MDM_KillTargetsObjective:new({
      mission = mission,
      title ="Take out your targets",
      targets = args.enemyNpcs
    })
    mission:AddObjective(objective100_KillTargets)

    mission:AddObjective(MDM_RestorePlayerObjective:new({mission = mission}))

    local noPoliceDirecotr = MDM_PoliceFreeZoneFeature:new({
      position = args.enemyNpcs[1]:GetPosition(),
      radius = 100
    })
    MDM_FeatureUtils.RunBetweenObjectives(noPoliceDirecotr,objective1_startAttack,objective100_KillTargets)

    return mission
  end


  local mission = DuelTestMission({
    title = "Duel Test",
    startPosition = MDM_Utils.GetVector(-1454.884,-453.95401,3.0223277),
    initialWeather = "mm_110_omerta_cp_050_cs_safehouse",
    enemyNpcs = {
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1444.2271,-488.13773,3.2395408), direction = MDM_Utils.GetVector(-0.27127859,0.96250087,0)}),
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1440.8369,-486.95615,3.2213628), direction = MDM_Utils.GetVector(-0.2992492,0.954175,0)}),
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1437.6008,-485.80936,3.222491), direction = MDM_Utils.GetVector(-0.29935825,0.95414078,0)}),
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1436.2045,-482.95331,3.1876981), direction = MDM_Utils.GetVector(-0.94076848,0.3390497,0)}),
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1437.4296,-491.64578,3.1564496), direction = MDM_Utils.GetVector(-0.70401907,0.71018106,0)}),
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1442.595,-491.52405,3.2064359), direction = MDM_Utils.GetVector(-0.64396787,0.76505256,0)}),
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1446.0928,-486.38669,3.2213938), direction = MDM_Utils.GetVector(-0.62356263,0.78177339,0)})
    },
    allyNpcs = {
      MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1447.3892,-468.7261,3.1898816), direction = MDM_Utils.GetVector(0.43327615,-0.90126121,0)}),
      MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1450.9735,-469.41238,3.1904457), direction = MDM_Utils.GetVector(0.16622388,-0.98608804,0)}),
      MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1447.3892,-468.7261,3.1898816), direction = MDM_Utils.GetVector(0.43327615,-0.90126121,0)}),
      MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1447.3892,-468.7261,3.1898816), direction = MDM_Utils.GetVector(0.43327615,-0.90126121,0)}),
      MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1448.8175,-472.27847,3.1461122), direction = MDM_Utils.GetVector(0.59389323,-0.80454385,0)}),
      MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1448.8175,-472.27847,3.1461122), direction = MDM_Utils.GetVector(0.59389323,-0.80454385,0)}),
      MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1445.1748,-472.47644,3.1494639), direction = MDM_Utils.GetVector(0.11688796,-0.99314511,0)}),
      MDM_NPC:newFriend({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-1453.8947,-466.51282,3.1729071), direction = MDM_Utils.GetVector(0.41520488,-0.90972793,0)})
    }
  })

  return mission
end

function TestMissions.PursuitTest()
  local car_target = MDM_Car:new({carId = "smith_v12", position = MDM_Utils.GetVector(-898.98346,-190.64536,2.9552386), direction = MDM_Utils.GetVector(0.028562285,0.99954069,-0.010129704)})
  local npc_target = MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-907.94,-180.41,25), direction = MDM_Utils.GetVector(0,0,0)})
  local npc_target2 = MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-907.98,-180.41,25), direction = MDM_Utils.GetVector(0,0,0)})
  local car_police = MDM_Car:new({carId = "shubert_e_six_p", position = MDM_Utils.GetVector(-899.25092,-203.29758,2.9997153), direction = MDM_Utils.GetVector(-0.0055011963,0.99997598,-0.0042084511)})
  local npc_police = MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-907.94,-180.41,2), direction = MDM_Utils.GetVector(0,0,0)})
  local car_player = MDM_Car:new({carId = "shubert_e_six", position = MDM_Utils.GetVector(-899.16278,-225.84026,2.977174), direction = MDM_Utils.GetVector(0.044264518,0.99901813,-0.0018530977)})

  local assets = {car_target,npc_target,npc_target2,car_police,npc_police,car_player}

  local mission = MDM_Mission:new({
    title = "Carchase Test",
    startPosition = MDM_Utils.GetVector(-892.93268,-216.92448,2.9243827),
    initialWeather = "mm_180_sniper_cp_010"
  })

  mission:AddAssets(assets)

  local objective0_spawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = assets
  })
  mission:AddObjective(objective0_spawnerObjective)

  local objective1_waitForSpawns = MDM_CallbackObjective:new ({
    mission = mission,
    title = "Spawntime",
    callback = function ()

      npc_target:GetGameEntity():GetInOutCar(car_target:GetGameEntity(),1,false,false)
      npc_target2:GetGameEntity():GetInOutCar(car_target:GetGameEntity(),2,false,false)
      car_target:GetGameEntity():InitializeAIParams(enums.CarAIProfile.PIRATE   ,enums.CarAIProfile.PIRATE   )
      car_target:GetGameEntity():SetMaxAISpeed(true,65)
      car_target:GetGameEntity():SetNavModeWanderArea(false,nil)

      npc_police:GetGameEntity():GetInOutCar(car_police:GetGameEntity(),1,false,false)
      car_police:GetGameEntity():InitializeAIParams(enums.CarAIProfile.PIRATE   ,enums.CarAIProfile.PIRATE   )
      car_police:GetGameEntity():SetSirenOn(true)
      car_police:GetGameEntity():SetBeaconLightOn(true)
      car_police:GetGameEntity():SetMaxAISpeed(true,65)
      -- car_police:GetGameEntity():SetNavModeHunt(npc_target:GetGameEntity(),5,  enums.CarHuntRole.FOLLOW    )
      car_police:GetGameEntity():SetNavModeHunt(npc_target:GetGameEntity(),5,  enums.CarHuntRole.ALL    )

      --      car_police:GetGameEntity():SetNavModeHuntTeleport(false,npc_target:GetGameEntity(),5,  enums.CarHuntRole.ALL    )

      getp():GetOnVehicle(car_player:GetGameEntity(), 1, false, "WALK")

      --     npc_target2:GetGameEntity():Attack( car_police:GetGameEntity())
      return true
    end,
  })
  mission:AddObjective(objective1_waitForSpawns)

  local objective3_Killtarget = MDM_KillTargetsObjective:new({
    mission = mission,
    title ="Take out your target",
    targets = {npc_target}
  })
  mission:AddObjective(objective3_Killtarget)

  return mission
end

function TestMissions.CarchaseTest()
  local enemyCar = MDM_Car:new({carId = "smith_v12", position = MDM_Utils.GetVector(-898.71429,-181.9543,4), direction = MDM_Utils.GetVector(-0,000001,-0.000004,0.000150)})
  local enemyNpc = MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-907.94,-180.41,2), direction = MDM_Utils.GetVector(0,0,0)})
  local playerCar = MDM_Car:new({carId = "smith_v12", position = MDM_Utils.GetVector(-898.67657,-205.45827,2.96613), direction = MDM_Utils.GetVector(0.013172975,0.99991018,-0.0024737401)})

  local mission = MDM_Mission:new({
    title = "Carchase Test",
    startPosition = MDM_Utils.GetVector(-904.78802,-206.16048,2.7450461)
  })

  mission:AddAssets({enemyCar,enemyNpc,playerCar})
  mission:OnMissionStart(function() MDM_Utils.SpawnAll({enemyCar,enemyNpc,playerCar})end)

  local objective1_waitForSpawns = MDM_CallbackObjective:new ({
    mission = mission,
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
    mission = mission,
    title ="Take out your target",
    targets = {enemyNpc}
  })
  mission:AddObjective(objective3_Killtarget)

  return mission
end

function TestMissions.DestroyCarInAreaTest()
  local mission = MDM_Mission:new({title = "Destroy car in Area"})
  local car_smith = MDM_Car:new("smith_v12",MDM_Utils.GetVector(-898.71429,-181.9543,4),MDM_Utils.GetVector(-0,000001,-0.000004,0.000150))
  car_smith:Spawn()
  local objective = MDM_DestroyCarInAreaObjective:new({mission = mission, car = car_smith, position = MDM_Utils.GetVector(-898.71429,-181.9543,4), radius = 20})
  mission:AddObjective(objective)

  return mission
end

function TestMissions.WaitObjectiveTest()
  local mission = MDM_Mission:new({
    title = "Wait Objective Test"
  })

  local objective = MDM_WaitObjective:new({
    mission = mission,
    seconds = 10,
    bannerText = "wait"
  })

  mission:AddObjective(objective)
  return mission
end

function TestMissions.GangWarTest()
  local wave1Npcs = {
    {npcId= "13604348442857333985", position = MDM_Utils.GetVector(-887.94025,-228.11867,2.7994239), direction = MDM_Utils.GetVector(-0.99984133,0.017813683,0)},
    {npcId= "13604348442857333985", position = MDM_Utils.GetVector(-887.56146,-233.41458,2.8025167),MDM_Utils.GetVector(-0.97434926,0.22504109,0)}
  }

  local wave2NPCs = {
    {npcId= "13604348442857333985", position = MDM_Utils.GetVector(-887.94025,-228.11867,2.7994239), direction = MDM_Utils.GetVector(-0.99984133,0.017813683,0)},
    {npcId= "13604348442857333985", position = MDM_Utils.GetVector(-887.56146,-233.41458,2.8025167), direction = MDM_Utils.GetVector(-0.97434926,0.22504109,0)}
  }

  local carAssets = {
    {carId = "shubert_six", position= MDM_Utils.GetVector(-903.09753,-229.61916,2.9170983), direction = MDM_Utils.GetVector(-0.014218162,-0.99989843,0.0011345582)}
  }

  local allyNpcs = {
    {npcId="5874491335140879700", position = MDM_Utils.GetVector(-908.85223,-227.08142,2.808135), direction = MDM_Utils.GetVector(0.99617749,0.087352395,0)},
  }

  local wave2 = {
    enemies = wave2NPCs,
    title = "Wave 2"
  }

  local mission = MDM_GangWarMission:new({
    carAssets = carAssets,
    allyNpcs = allyNpcs,
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR,
    waves = {
      {
        enemies = wave1Npcs,
        title = "Wave 1"
      }
    }
  })

  return mission
end

function TestMissions.KillMission()
  local npc1 = MDM_NPC:newEnemy({npcId="16002116250561961955",position=MDM_Utils.GetVector(-907.94,-180.41,2),direction=MDM_Utils.GetVector(0,0,0), battleArchetype = "archetype_shotgunner_t1"})
  local m = MDM_Mission:new({title = "TEST: Kill Targets", assets = {npc1}})
  m:AddObjective(MDM_RestorePlayerObjective:new ({mission = m}))

  m:AddObjective(MDM_KillTargetsObjective:new({mission = m, targets = {npc1}}))
  m:AddAssets(npc1)
  MDM_Mission.Start(m)
  npc1:Spawn()
  npc1:AttackPlayer()
  --  npc2:Spawn()
  --  npc3:Spawn()
  --  npc4:Spawn()

  return m
end

function TestMissions.NPCHurtTest()
  local npc1 = MDM_NPC:new({npcId="13604348442857333985",position=MDM_Utils.GetVector(-907.94,-180.41,2),direction=MDM_Utils.GetVector(-0.67485845,0.73794723,0)})

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

  local objective1 = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Utils.GetVector(-907.94,-210.41,2),
    title = "Objective 1",
    task = "Go to the marked location",
    description = "Blablabla"
  })


  local objective2 = MDM_GoToObjective:new({
    mission = mission,
    position = MDM_Utils.GetVector(-907.94,-180.41,2),
    title = "Objective 2",
    task = "Go to the marked location",
    description = "Blablabla"
  })



  local objective3 = MDM_GoToObjective:new({
    mission = mission,
    title = "Objective 3",
    task = "Go to the marked location",
    description = "Blablabla",
    position = MDM_Utils.GetVector(-907.94,-160.41,2),
    noPolice = true
  })

  mission:AddObjectives({
    objective1,
    objective2,
    objective3
  })

  return mission
end

function TestMissions.EvadeMission()
  local m = MDM_Mission:new({title = "Evade Mission"})
  local objective_policeEvade = MDM_PoliceEvadeObjective:new ({mission = m, initialLevel = 1})
  objective_policeEvade:SetInitialWantedLevel(1)
  --  m:AddObjective(objective_policeEvade)

  return m
end

function TestMissions.BannerTest()
  MissionManager.HideMenu()
  game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "Salieri - Backyard Trouble", "Some of Morello's gunmen were reported to hang around in our neighbourhood harassing pur people.\nThis can not be tolerated.\nSend Morello a message by taking them out.")
end

function TestMissions.GetInCar()
  local falconerCar = MDM_Car:new("berkley_810",MDM_Utils.GetVector(-898.71429,-181.9543,4),MDM_Utils.GetVector(-0,000001,-0.000004,0.000150))
  falconerCar:SetIndestructable(true)
  --    falconerCar:SetPrimaryColorRGB(48,45,10)
  falconerCar:SetPrimaryColorRGB(100,30,0)
  local mission = MDM_Mission:new({title = "Get in the Car"})

  -- Objective1: Get In The Car
  local objective1 = MDM_GetInCarObjective:new({mission = mission, car = falconerCar, title= "Get in the car"})
  mission:AddObjective(objective1)

  -- Objective2: Drive Back To Salieris
  local objective2 = MDM_GoToObjective:new({mission = mission,position = MDM_Utils.GetVector(-907.94,-210.41,2), title = "Drive back to Salieri's" })
  mission:AddObjective(objective2)

  -- Create Player in Car Detector and Use it while Objective 2 is active
  local detector= MDM_PlayerInCarBannerFeature:new ({car = falconerCar})
  MDM_FeatureUtils.RunWhileObjective(detector,objective2)

  local onCarDestroyed = function()
    mission:SetFailDescription("You destroyed the car")
    mission:Fail()
  end

  local damageDirector = MDM_CallbackFeature:new({
    callback = function()
      if not falconerCar:CanDrive() then
        onCarDestroyed()
      end
    end
  })
  MDM_FeatureUtils.RunWhileObjective(damageDirector,objective2)

  mission:AddAssets({falconerCar})

  return mission
end

function TestMissions.HostileZoneTest()
  local position = MDM_Utils.GetVector(-907.94,-180.41,2)
  local npc1 = MDM_NPC:new({npcId="13604348442857333985",position = position, direction = MDM_Utils.GetVector(0,0,0)})

  local mission = MDM_Mission:new({
    title = "Hostile AreaTest"
  })

  local objective_spawner = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = {npc1}
  })
  mission:AddObjective(objective_spawner)

  local objective = MDM_KillTargetsObjective:new({
    mission = mission,
    targets = {npc1},
  --   onObjectiveStart = function() print("Injury") npc1:GetGameEntity():EnableInjury(true) end
  })
  mission:AddObjective(objective)

  local hostileZone =  MDM_HostileZoneFeature:new({
    position = position,
    radius = 80,
    detectionRadius = 5,
    showArea = true,
    enemies = {npc1}
  }
  )

  MDM_FeatureUtils.RunBetweenObjectives(hostileZone,objective,objective)

  mission:AddAssets({npc1})

  return mission
end

function TestMissions.WalkToTest()
  local npcTarget = MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-908.67175,-185.3815,2.833797), direction = MDM_Utils.GetVector(0.011134353,0.99993801,0)})

  local mover = MDM_NPCGoToDirector:new({
    npc = npcTarget,
    position = MDM_Utils.GetVector(-907.95496,-217.03046,2.8169303)
  })

  local mission = MDM_Mission:new({
    title = "Walk To test",
    startPosition = MDM_Utils.GetVector(-907.95496,-217.03046,2.8169303),
    assets = {npcTarget}
  })

  local objective50_spawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = {npcTarget}
  })



  local objective100_KillTargets = MDM_KillTargetsObjective:new({
    mission = mission,
    title ="Take out your targets",
    targets = {npcTarget},
  })


  mission:AddObjective(MDM_RestorePlayerObjective:new({mission = mission}))
  mission:AddObjective(objective50_spawnerObjective)
  mission:AddObjective(objective100_KillTargets)

  MDM_FeatureUtils.RunWhileObjective(mover,objective100_KillTargets)

  return mission
end

function TestMissions.CivilWanderTest()

  local npcTarget = MDM_NPC:newCivilian({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-908.67175,-185.3815,2.833797), direction = MDM_Utils.GetVector(0.011134353,0.99993801,0)})
  local npcBodyguard1 = MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-907.36566,-190.83984,2.8284881), direction = MDM_Utils.GetVector(0.2797617,0.96006948,0)})
  local npcBodyguard2 = MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-909.70911,-190.3795,2.8368874), direction = MDM_Utils.GetVector(0.1081597,0.99413353,0)})

  local spawnables = {npcTarget,npcBodyguard1,npcBodyguard2}

  local mission = MDM_Mission:new({
    title = "Civil Wander Test",
    startPosition = MDM_Utils.GetVector(-907.95496,-217.03046,2.8169303),
    initialWeather = "mm_110_omerta_cp_050_cs_safehouse",
    assets = spawnables
  })

  local objective50_spawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = spawnables
  })
  mission:AddObjective(objective50_spawnerObjective)

  local objective1_Wander = MDM_CallbackObjective:new ({
    mission = mission,
    title = "Civil Wander",
    callback = function ()
      npcTarget:GetGameEntity():WanderAway()
      --    npcTarget:GetGameEntity():OverrideWanderMoveMode(enums.HumanMoveMode.SPRINT)
      npcTarget:GetGameEntity():SetMovementSpeedMult(2)
      npcBodyguard1:GetGameEntity():Follow(npcTarget:GetGameEntity())
      npcBodyguard2:GetGameEntity():Follow(npcTarget:GetGameEntity())
      return true
    end,
  })
  mission:AddObjective(objective1_Wander)

  local objective100_KillTargets = MDM_KillTargetsObjective:new({
    mission = mission,
    title ="Take out your targets",
    targets = {npcTarget,npcBodyguard1,npcBodyguard2}
  })
  mission:AddObjective(objective100_KillTargets)

  mission:AddObjective(MDM_RestorePlayerObjective:new({mission = mission}))
  return mission

end

function TestMissions.AssassinationMission()
  local mission = MDM_AssassinationMission:new({
    targets = {
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-889.95587,-233.85648,2.8022108), direction = MDM_Utils.GetVector(-0.99879068,-0.049164772,0)})
    },
    bodyguards =  {
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-885.94452,-235.28236,2.8107185), direction = MDM_Utils.GetVector(-0.99366277,-0.11240196,0)}),
      MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-885.86884,-232.52312,2.8139303), direction = MDM_Utils.GetVector(-0.99984533,-0.017589808,0)})
    },
    carAssets = {
      MDM_Car:new({carId = "bolt_v8", position = MDM_Utils.GetVector(-893.50861,-232.69691,3.008189), direction = MDM_Utils.GetVector(-0.05430891,0.99852246,0.0018321915)})
    },
    radius = 100
  })

  return mission
end

function TestMissions.SimpleRace()
  local mission = MDM_SimpleRaceMission:new({
    startPosition = MDM_Utils.GetVector(-892.93268,-216.92448,2.9243827),
    playerCar = {carId = "smith_v12", position = MDM_Utils.GetVector(-898.62866,-206.49626,2.9817207), direction = MDM_Utils.GetVector(-0.0094909342,0.99995327,-0.0018382519)},
    rivalCars = {
      {carId = "smith_v12", position = MDM_Utils.GetVector(-901.00354,-189.40616,2.9492006), direction = MDM_Utils.GetVector(0.019263864,0.99977261,-0.0091460701)},
      {carId = "smith_v12", position = MDM_Utils.GetVector(-896.29266,-189.47711,2.9630671), direction = MDM_Utils.GetVector(-0.013393856,0.9998768,-0.0081892973)},
      {carId = "smith_v12", position = MDM_Utils.GetVector(-896.17072,-198.3961,2.9792886), direction = MDM_Utils.GetVector(-0.00056744472,0.9999972,-0.0022861471)},
      {carId = "smith_v12", position = MDM_Utils.GetVector(-900.65759,-198.55563,2.9772015), direction = MDM_Utils.GetVector(-0.019604612,0.99980384,-0.0028221593)}
    },
    waypoints = {
      MDM_Utils.GetVector(1966.0057,-240.7205,114.784)
    }
  })

  return mission
end

function TestMissions.DistanceDiretorTest()
  local npcTarget = MDM_NPC:newCivilian({npcId = "13604348442857333985", position = MDM_Utils.GetVector(-908.67175,-185.3815,2.833797), direction = MDM_Utils.GetVector(0.011134353,0.99993801,0)})

  local mission = MDM_Mission:new({
    --    title = "Distance Director Test",
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR,
    assets = {npcTarget}
  })

  local objective_100_spawner = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = {npcTarget}
  })

  local objective_200_killTarget = MDM_KillTargetsObjective:new({
    mission = mission,
    targets = {npcTarget}
  })

  local distanceDirector = MDM_EntityDistanceFeature:new({
    entity = npcTarget,
    distance = 50,
    warningDistance = 30,
    warningText = "Get back to your target",
    callback = function() mission:Fail("You lost your target") end
  })
  MDM_FeatureUtils.RunWhileObjective(distanceDirector,objective_200_killTarget)

  mission:AddObjective(objective_200_killTarget)
  mission:AddObjective(objective_100_spawner)
  return mission
end

MDM_UnitTest.RegisterTest({name = "TestMissions.GetInCar", func = TestMissions.GetInCar})
MDM_UnitTest.RegisterTest({name = "TestMissions.BasicDetectionTest", func = TestMissions.BasicDetectionTest})
MDM_UnitTest.RegisterTest({name = "TestMissions.KillMission", func = TestMissions.KillMission})
MDM_UnitTest.RegisterTest({name = "TestMissions.WaypointMission", func = TestMissions.WaypointMission})
MDM_UnitTest.RegisterTest({name = "TestMissions.GangWarTest", func = TestMissions.GangWarTest})
MDM_UnitTest.RegisterTest({name = "TestMissions.DestroyCarInAreaTest", func = TestMissions.DestroyCarInAreaTest})
MDM_UnitTest.RegisterTest({name = "TestMissions.HostileZoneTest", func = TestMissions.HostileZoneTest})
MDM_UnitTest.RegisterTest({name = "TestMissions.DuelTest", func = TestMissions.DuelTest})
MDM_UnitTest.RegisterTest({name = "TestMissions.CivilWanderTest", func = TestMissions.CivilWanderTest})
MDM_UnitTest.RegisterTest({name = "TestMissions.PursuitTest", func = TestMissions.PursuitTest})
MDM_UnitTest.RegisterTest({name = "TestMissions.CarchaseTest", func = TestMissions.CarchaseTest})
MDM_UnitTest.RegisterTest({name = "TestMissions.DistanceDiretorTest", func = TestMissions.DistanceDiretorTest})
MDM_UnitTest.RegisterTest({name = "TestMissions.Patroltest", func = TestMissions.PatrolTest})
