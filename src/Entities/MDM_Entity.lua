MDM_Entity = {}

function MDM_Entity:class()
  local entity = {}
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function MDM_Entity:new(spawnPos, spawnDir)
  local entity = {}
  setmetatable(entity, self)
  self.__index = self


  entity.respawntime = -1
  entity.isactive = false
  entity.spawned = false
  entity.position = spawnPos
  entity.direction = spawnDir
  entity.gameEntity = nil
  entity.onSpawnedCallbacks = MDM_List:new()
  entity.onDespawnedCallbacks = MDM_List:new()

  return entity
end

function MDM_Entity.GetDirection(self)
  return self.direction
end

function MDM_Entity.GetGameEntity(self)
  return self.gameEntity
end

function MDM_Entity.GetPosition(self)
  if game and self and self:GetGameEntity() and self:GetGameEntity().GetPos ~= nil then
    return self:GetGameEntity():GetPos()
  else
    return self.position
  end
end

function MDM_Entity.IsActive(self)
  return self.isactive
end

--@Overwrite
function MDM_Entity.IsSpawning(self)
  return false
end

function MDM_Entity.SetGameEntity(self,gameEntity)
  if not gameEntity then
    error("gameEntitiy not set",2)
  end
  self.gameEntity = gameEntity
end

--@Overwrite
function MDM_Entity.Spawn(self)
  return false
end

function MDM_Entity.Deactivate(self)
  self.active = false
end

function MDM_Entity.Activate(self)
  self.active = true
end

--@Overwrite
function MDM_Entity.Despawn(self)
  return
end

--@Overwrite
function MDM_Entity.IsSpawned(self)
  return self.spawned
end

function MDM_Entity.OnSpawned(self, callback)
  self.onSpawnedCallbacks:Add(callback)
end

function MDM_Entity.OnDespawned(self, callback)
  self.onDespawnedCallbacks:Add(callback)
end
