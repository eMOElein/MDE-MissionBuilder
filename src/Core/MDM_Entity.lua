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

  return entity
end

function MDM_Entity.GetDir(self)
  return self.dir
end

function MDM_Entity.GetGameEntity(self)
  return self.gameEntity
end

function MDM_Entity.GetPos(self)
  if not self then
    print("warning self should not be nil!!!")
  end

  if game and self and self:GetGameEntity() and self:GetGameEntity():GetPos() then
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
function MDM_Entity.Spawn()
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

function MDM_Entity.Spawn(self)
  return
end

--@Overwrite
function MDM_Entity.IsSpawned(self)
  return self.spawned
end

function MDM_Entity.SetRespawnTime(self,respawntime)
  self.respawntime = respawntime
end

function MDM_Entity.GetRespawnTime(self)
  return self.respawntime
end
