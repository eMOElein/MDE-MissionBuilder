MDM_SpawnManager = {}

local despawns = MDM_List:new()

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

  -- Some entitys can get dirty under certain circumstances and are missing their methods. If they are dirty they get despawned immediately.
  if spawnable:GetGameEntity() and spawnable:GetGameEntity().GetPos  then
    table.insert(despawns,{spawnable = spawnable, evaluator = function() return MDM_Utils.DistanceToPlayer(spawnable) > distance end})
  else
    spawnable:Despawn()
  end
end

function MDM_SpawnManager.MarkForFunctionDespawn(spawnable, evaluator)
  table.insert(despawns,{spawnable = spawnable, evaluator = evaluator})
end

function MDM_SpawnManager.MarkForTimeDespawn(spawnable, time)
--TODO: Despawn after X milliseconds
end

function MDM_SpawnManager.Update()
  for index,despawn in ipairs(despawns) do
    if despawn.spawnable:GetGameEntity() == nil then
      despawns:Remove(despawn)
      return
    end

    local eval = despawn.evaluator()
    local spawnable = despawn.spawnable
    if eval then
      despawns:Remove(despawn)
      if spawnable:IsSpawned() and not MDM_SpawnManager._IsEntityDirty(spawnable) then
        spawnable:Despawn()
      end
    end
  end
end

function MDM_SpawnManager._IsEntityDirty(entity)
  if entity:IsSpawned() and not entity:GetGameEntity() then
    return true
  end

  if not entity:GetGameEntity().GetPos then
    return true
  end
end
