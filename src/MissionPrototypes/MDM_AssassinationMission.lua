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

  mission.targets = {}
  mission.bodyguards = {}
  mission.carAssets = {}

  for _,t in ipairs(args.targets) do
    table.insert(mission.targets,MDM_NPC:new(t))
  end

  if args.bodyguards ~= nil then
    for _,b in ipairs(args.bodyguards) do
      table.insert(mission.bodyguards, MDM_NPC:new(b))
    end
  end

  if args.carAssets ~= nil then
    for _,c in ipairs(args.carAssets) do
      table.insert(mission.carAssets, MDM_Car:new(c))
    end
  end

  mission.position = MDM_Utils.GetFirstElement(mission.targets):GetPos()
  mission.destinationPosition = args.destinationPosition
  mission.radius = args.radius or 100

  local spawnables = {}
  MDM_Utils.AddAll(spawnables,mission.targets)
  MDM_Utils.AddAll(spawnables,mission.bodyguards)
  MDM_Utils.AddAll(spawnables,mission.carAssets)
  mission:AddAssets(spawnables)
  -----------------------
  ------ Objectives -----
  -----------------------
  local objective_000_SpawnerObjective = MDM_SpawnerObjective:new({
    spawnables = spawnables
  })
  mission:AddObjective(objective_000_SpawnerObjective)

  local objective_100_GoToLocation = MDM_GoToObjective:new({
    title = "Go to your targets",
    position = mission.position,
    radius = mission.radius
  })
  mission:AddObjective(objective_100_GoToLocation)

  local objective_200_KillTargets = MDM_KillTargetsObjective:new({
    title = "Eliminate your targets",
    targets = mission.targets
  })
  mission:AddObjective(objective_200_KillTargets)

  if mission.destinationPosition ~= nil then
    local objective_400_GoToDestination = MDM_GoToObjective:new({
      title = "Go to your targets",
      position = mission.destinationPosition,
      radius = mission.radius
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
  MDM_ActivatorUtils.RunWhileObjective(noPoliceZoneDirector,objective_200_KillTargets)

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
