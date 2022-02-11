MDM_SpawnerObjective = {}
MDM_SpawnerObjective = MDM_Objective:class()

function MDM_SpawnerObjective:new(args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if args.spawnables == nil then
    error("spawnables not set",2)
  end

  if type(args.spawnables) ~= "table" then
    error("spawnables is not of type table",2)
  end

  objective.args = args
  objective.spawnables = {}
  MDM_SpawnerObjective.AddSpawnables(objective,args.spawnables)

  return objective
end

function MDM_SpawnerObjective.AddSpawnable(self,spawnable)
  if spawnable == nil then
    error("spawnable is nil")
  end
  table.insert(self.spawnables,spawnable)
end

function MDM_SpawnerObjective.AddSpawnables(self,spawnables)
  for _,s in ipairs(spawnables) do
    MDM_SpawnerObjective.AddSpawnable(self,s)
  end
end

function MDM_SpawnerObjective.Update(self)
  local spawnedNPCs = 0

  MDM_Objective.Update(self)
  if not self.running then
    return
  end

  if not self.spawning then
    for _,spawnable in ipairs(self.spawnables) do
      spawnable:Spawn()
    end
    self.spawning = true
  end

  for _,spawnable in ipairs(self.spawnables) do
    if spawnable:IsSpawned() then
      spawnedNPCs = spawnedNPCs + 1
    end
  end

  if spawnedNPCs == #self.spawnables then
    MDM_Objective.Succeed(self)
  end

end

function MDM_SpawnerObjective.UnitTest()
  print("---------------MDM_SpawnerObjective UnitTest")
  local spawnerObjective = MDM_SpawnerObjective:new({
    mission = MDM_Mission:new({}),
    spawnables = {
      MDM_NPC:new({npcId="1",position=MDM_Utils.GetVector(1,2,3),direction=MDM_Utils.GetVector(1,2,3)}),
      MDM_NPC:new({npcId="1",position=MDM_Utils.GetVector(1,2,3),direction=MDM_Utils.GetVector(1,2,3)})
    }
  })

  spawnerObjective:Update()
  spawnerObjective:Update()

  print("OK")
end
