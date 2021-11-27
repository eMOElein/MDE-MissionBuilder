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
local function GetEntity(Name)
  return game.entitywrapper:GetEntityByName("Name")
end

local function createSpawner(model, pos,dir)
  local ent = game.game:CreateCleanEntity(pos, 0, false, false, true)
  ent:SetPos(pos)
  ent:SetDir(dir)
  local entWrapComp = ent:GetComponent("C_EntityWrapperComponent")
  entWrapComp:SetGameEntityType(enums.EntityType.ENTITY)
  entWrapComp:SetModelName(model)
  ent:AddComponent("C_SpawnerComponent")
  ent:AddComponent("C_RuntimeSpawnerComponent")
  return ent -- The Spawner
end

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

function TestMissions.DestroyCarInAreaTest()
  local mission = MDM_Mission:new({title = "Destroy car in Area"})
  local car_smith = MDM_Car:new("smith_v12",MDM_Utils.GetVector(-898.71429,-181.9543,4),MDM_Utils.GetVector(-0,000001,-0.000004,0.000150))
  car_smith:Spawn()
  local objective = MDM_DestroyCarInAreaObjective:new({mission = mission, car = car_smith, position = MDM_Utils.GetVector(-898.71429,-181.9543,4), radius = 20})
  mission:AddObjective(objective)
  MDM_MissionManager.StartMission(mission)
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


  MDM_MissionManager.StartMission(mission)
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
  warConfig.initialPosition = MDM_LocationPositions.SALIERIS_BAR_FRONTDOOR

  local mission = MDM_GangWarMission:new(warConfig)
  MDM_MissionManager.StartMission(mission)

  return mission
end

function TestMissions.SpawnTest()
  if not game then
    return
  end

  print("SpawnTest:")

  local pos = getp():GetPos()
  local dir = MDM_Utils.GetVector(-907.94,-180.41,2)

  print("Pos: " ..tostring(pos))
  print("Dir: " ..tostring(dir))
  local ObjectName = "1711773440634993571"

  local spawner_ent = createSpawner(ObjectName, pos,dir)

  StartThread(function ()
    local spawner = spawner_ent:GetComponent("C_RuntimeSpawnerComponent")
    local SpawnPos = pos
    local SpawnDir = dir
    --   SpawnPos.x = SpawnPos.x + (SpawnDir.x * 3)
    --   SpawnPos.y = SpawnPos.y + (SpawnDir.y * 3)
    --    SpawnDir.x = 0 - SpawnDir.x
    --    SpawnDir.y = 0 - SpawnDir.y
    --    SpawnDir.z = 0
    --   spawner_ent:Deactivate()
    spawner_ent:Activate()
    --    spawner:SetSpawnProfile(spawnId)
    spawner:SetSpawnProfile(ObjectName)
    print("Before")
    Wait(spawner:GetSpawnProfileLoadSyncObject())
    print("After")
    local output = spawner:CreateObject()
    print("Created")
    print("Output: " .. tostring(output))
    output:SetPos(pos)
    output:SetDir(dir)
    output:Activate()
    return
  end)
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
  MDM_MissionManager.StartMission(m)
end

function TestMissions.NPCHurtTest()
  local npc1 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-907.94,-180.41,2),MDM_Utils.GetVector(-0.67485845,0.73794723,0))

  local m = MDM_Mission:new({title = "Test NPC Hurt"})
  local objective1 = MDM_HurtNPCObjective:new({mission = m, npc = npc1, threshold = 80})
  objective1.title = "Hurt NPC - Threshold 80"
  objective1.task = "Hurt the NPC"
  m:AddObjective(objective1)

  if MDM_MissionManager.StartMission(m) then
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

  MDM_MissionManager.StartMission(mission)
end

function TestMissions.EvadeMission()
  local m = MDM_Mission:new({title = "Evade Mission"})
  local objective_policeEvade = MDM_PoliceEvadeObjective:new ({mission = m, initialLevel = 1})
  objective_policeEvade:SetInitialWantedLevel(1)
  --  m:AddObjective(objective_policeEvade)
  MDM_MissionManager.StartMission(m)
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
  MDM_MissionManager.StartMission(mission)
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
  MDM_MissionManager.StartMission(mission)
end
