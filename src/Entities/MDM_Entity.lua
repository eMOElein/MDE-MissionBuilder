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

  --  if type(spawnPos) ~= "table" then
  --    error("no spawnPos",2)
  --  end
  --
  --    if type(spawnDir) ~= "table" then
  --    error("no spawnDir",2)
  --  end


  entity.respawntime = -1
  entity.isactive = false
  entity.spawned = false
  entity.spawnPos = spawnPos
  entity.spawnDir = spawnDir
  entity.gameEntity = nil
  entity.onSpawnedCallbacks = MDM_List:new()
  entity.onDespawnedCallbacks = MDM_List:new()

  return entity
end

function MDM_Entity.GetDir(self)
  return self.dir
end

function MDM_Entity.GetGameEntity(self)
  return self.gameEntity
end

function MDM_Entity.GetPos(self)
  if game and self and self:GetGameEntity() and self:GetGameEntity().GetPos ~= nil then
    return self:GetGameEntity():GetPos()
  else
    return self.spawnPos
  end
end

function MDM_Entity.GetSpawnPos(self)
  return self.spawnPos
end

function MDM_Entity.GetSpawnDir(self)
  return self.spawnDir
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
