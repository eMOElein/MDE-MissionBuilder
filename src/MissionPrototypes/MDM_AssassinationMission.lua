MDM_AssassinationMission = {}

function MDM_AssassinationMission:new(args)
  local mission = MDM_Mission:new(args)

  if args.targets == nil then
    error("targets not set",2)
  end

  if #args.targets == 0 then
    error("targets is empty",2)
  end

  if args.position == nil then
  --    error("position not set",2)
  end

  mission.targets = MDM_List:new()
  mission.bodyguards = MDM_List:new()
  mission.carAssets = MDM_List:new()

  for _,t in ipairs(args.targets) do
    mission.targets:Add(MDM_NPC:new(t))
  end

  if args.bodyguards ~= nil then
    for _,b in ipairs(args.bodyguards) do
      mission.bodyguards:Add(MDM_NPC:new(b))
    end
  end

  if args.carAssets ~= nil then
    for _,c in ipairs(args.carAssets) do
      mission.carAssets:Add(MDM_Car:new(c))
    end
  end

  mission.position = MDM_Utils.GetFirstElement(mission.targets):GetPos()
  mission.destinationPosition = args.destinationPosition
  mission.radius = args.radius or 100

  local spawnables = MDM_List:new()
  spawnables:AddAll(mission.targets)
  spawnables:AddAll(mission.bodyguards)
  spawnables:AddAll(mission.carAssets)
  mission:AddAssets(spawnables)
  -----------------------
  ------ Objectives -----
  -----------------------
  local objective_000_restore = MDM_RestorePlayerObjective:new({mission = mission})
  mission:AddObjective(objective_000_restore)

  local objective_000_SpawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = spawnables
  })
  mission:AddObjective(objective_000_SpawnerObjective)

  local objective_100_GoToLocation = MDM_GoToObjective:new({
    mission = mission,
    title = "Go to your targets",
    position = mission.position,
    radius = mission.radius
  })
  mission:AddObjective(objective_100_GoToLocation)

  local objective_200_KillTargets = MDM_KillTargetsObjective:new({
    mission = mission,
    title = "Eliminate your targets",
    targets = mission.targets
  })
  mission:AddObjective(objective_200_KillTargets)

  local objective_300_leave = MDM_LeaveAreaObjective:new({
    mission = mission,
    title = "Leave the area",
    area = MDM_Area.ForSphere({
      position = mission.position,
      radius = mission.radius
    })
  })
  mission:AddObjective(objective_300_leave)

  if mission.destinationPosition ~= nil then
    local objective_400_GoToDestination = MDM_GoToObjective:new({
      mission = mission,
      title = "Go to your destination",
      position = mission.destinationPosition,
    })
    mission:AddObjective(objective_400_GoToDestination)
  end
  -----------------------
  ------ Directors ------
  -----------------------
  local noPoliceZoneDirector = MDM_PoliceFreeZoneDirector:new({
    mission = mission,
    position = mission.position,
    radius = mission.radius,
    showArea = true
  })
  MDM_ActivatorUtils.RunBetweenObjectives(noPoliceZoneDirector,objective_200_KillTargets,objective_300_leave)

  return mission
end

function MDM_AssassinationMission.UnitTest()
  print("---------------MDM_AssassinationMission")
  local mission = MDM_AssassinationMission:new({
    targets = {
      {npcId = "1", position = MDM_Utils.GetVector(1,2,3), direction = MDM_Utils.GetVector(1,1,1)},
      {npcId = "2", position = MDM_Utils.GetVector(1,2,3), direction = MDM_Utils.GetVector(1,1,1)}},
    bodyguards = {{npcId = "123", position = MDM_Utils.GetVector(1,2,3), direction = MDM_Utils.GetVector(1,1,1)}},
  --    position = MDM_Utils.GetVector(1,1,1)
  })
  mission:Start()
end
