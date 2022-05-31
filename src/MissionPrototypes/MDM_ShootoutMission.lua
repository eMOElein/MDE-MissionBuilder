MDM_ShootoutMission = {}

function MDM_ShootoutMission:new(config)
  if not config.position then
    error("position not set",2)
  end

  if not config.enemies then
    error("enemies not set",2)
  end

  if not config.allies then
    error("allies not set",2)
  end

  local mission = MDM_Mission:new(config)

  mission.allies = MDM_List:new()
  if config.allies then
    mission.allies:AddAll(MDM_List:new(config.allies):Map(function(ally) return MDM_NPC:newFriend(ally) end))
  end

  mission.enemies = MDM_List:new()
  if config.enemies then
    mission.enemies:AddAll(MDM_List:new(config.enemies):Map(function(enemy) return MDM_NPC:newFriend(enemy) end))
  end


  mission.carAssets = MDM_List:new()
  if config.carAssets then
    mission.carAssets:AddAll(MDM_List:new(config.carAssets):Map(function(car)return MDM_Car:new(car) end))
  end

  local assets = MDM_List:new()
  assets:AddAll(mission.allies)
  assets:AddAll(mission.enemies)
  assets:AddAll(mission.carAssets)

  mission:AddAssets(assets)
  ------------------------------------
  ------------ Objectives ------------
  ------------------------------------
  local objective_0500_SpawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = MDM_List:new(assets)
  })

  local objective_1000_GoToBrawl = MDM_GoToObjective:new({
    mission = mission,
    position = config.position,
    radius = config.radius or 100
  })

  local objective_2000_KillEnemies = MDM_KillTargetsObjective:new({
    mission = mission,
    targets = mission.enemies,
    onObjectiveStart = function() MDM_ShootoutMission._InitiateShootout(mission) end
  })

  mission:AddObjective(objective_0500_SpawnerObjective)
  mission:AddObjective(objective_1000_GoToBrawl)
  mission:AddObjective(objective_2000_KillEnemies)
  return mission
end

function MDM_ShootoutMission._InitiateShootout(mission)
  local allies = mission.allies
  local enemies = mission.enemies

  for _,enemy in ipairs(enemies) do
    enemy:MakeEnemy()
  end

  MDM_ShootoutMission._AttackRoundRobin(allies, enemies)
  MDM_ShootoutMission._AttackRoundRobin(enemies, allies)

  MDM_ShootoutMission._AttackPlayer(enemies, 50)
end

function MDM_ShootoutMission._AttackPlayer(shooters, chance)
  local chance = chance or 100

  MDM_List:new(shooters):ForEach(function(shooter)
    local random = math.random(1,100)
    if(random <= chance) then
      shooter:AttackPlayer()
    end
  end)

end

function MDM_ShootoutMission._AttackRoundRobin(shooters, targets)
  local targetIndex = 1

  for _,shooter in ipairs(shooters) do
    if targetIndex > #targets then
      targetIndex = 1
    end

    local shooterEntity = shooter:GetGameEntity()
    local targetEntity = targets[targetIndex]:GetGameEntity()

    if shooterEntity ~= nil and targetEntity ~= nil then
      shooterEntity:Attack(targetEntity)
      targetIndex = targetIndex+1
    end
  end
end

function MDM_ShootoutMission.UnitTest()
  local config = MDM_ShootoutMissionConfigurations.shootouts[1]

  local mission = MDM_ShootoutMission:new(config)
  mission:Start()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()

end
