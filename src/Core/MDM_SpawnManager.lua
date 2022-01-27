MDM_SpawnManager = {}

local despawns = {}

function MDM_SpawnManager.MarkForDistanceDespawn(spawnable, distance)
  if not spawnable then
    error("spawnable not set",2)
  end

  if not distance then
    error("distance not set",2)
  end

  if not type(distance) == "number" then
    error("distance is no number")
  end

  table.insert(despawns,{spawnable = spawnable, evaluator = function() return MDM_Utils.DistanceToPlayer(spawnable) > distance end})
end

function MDM_SpawnManager.MarkForFunctionDespawn(spawnable, evaluator)
  table.insert(despawns,{spawnable = spawnable, evaluator = evaluator})
end

function MDM_SpawnManager.MarkForTimeDespawn(spawnable, time)
--TODO: Despawn after X milliseconds
end

function MDM_SpawnManager.Update()
  for index,despawn in ipairs(despawns) do
    local eval = despawn.evaluator()
    local spawnable = despawn.spawnable
    if eval and spawnable:IsSpawned() then
      spawnable:Despawn()
    end
  end
end
