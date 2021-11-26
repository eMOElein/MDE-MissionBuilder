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

MDM_NPC = {}
MDM_NPC = MDM_Entity:class()

function MDM_NPC:new(npcId,pos,dir)
  local npc = MDM_Entity:new(pos,dir)
  setmetatable(npc, self)
  self.__index = self

  if not npcId then
    error("npcId not set",2)
  end

  npc.npcId = npcId
  npc.game_id = nil
  npc.game_GUID = nil
  npc.game_npc = nil
  npc.spawner = nil
  npc.spawning = false
  npc.spawned = false
  npc.godmode = false
  npc.health = 100
  npc.onSpawnedCallbacks = {}

  --attributes
  npc.pos = pos
  npc.dir = dir or MDM_Utils.GetVector(0,0,0)

  if game then
    npc.aitype = enums.AI_TYPE.ENEMY
  end

  return npc
end

function MDM_NPC.AttackPlayer(self)
  local ent = self:GetGameEntity()

  local func = function()
    local ent = self:GetGameEntity()
    if ent then
      ent:Attack(getp())
    end
  end

  -- Execute function immediately if entity is already spawned.
  -- If not then wait till entity is spawned.
  if ent then
    func()
  else
    self:OnSpawned(func)
  end
end

function MDM_NPC.AttackPlayer(self)
  local ent = self:GetGameEntity()

  local func = function()
    local ent = self:GetGameEntity()
    if ent then
      ent:Attack(getp())
    end
  end

  -- Execute function immediately if entity is already spawned.
  -- If not then wait till entity is spawned.
  if ent then
    func()
  else
    self:OnSpawned(func)
  end
end

function MDM_NPC.GetPos(self)
  if self.ent then
    return ent:GetPos()
  end
end

function MDM_NPC.newCivilian(npcId,pos,dir)
  local npc = MDM_NPC:new(npcId,pos,dir)

  if game then
    npc.aitype = enums.AI_TYPE.CIVILIAN
  end
end

--Human:Patrol
--Human:PatrolWayPoints

function MDM_NPC:newFriend(npcId,pos,dir)
  --Human:NeverLoseTrackOfPlayer
  local npc = MDM_NPC:new(npcId,pos,dir)

  if game then
    npc.aitype = enums.AI_TYPE.FRIEND
  end

  return npc
end

local function createSpawner(pos,dir)
  local ent = game.game:CreateCleanEntity(pos, 0, false, false, true)
  ent:SetPos(pos)
  ent:SetDir(dir)
  local entWrapComp = ent:GetComponent("C_EntityWrapperComponent")
  entWrapComp:SetGameEntityType(enums.EntityType.ITEM_NAVDUMMY)
  entWrapComp:SetModelName("spawn_special")
  ent:AddComponent("C_SpawnerComponent")
  ent:AddComponent("C_RuntimeSpawnerComponent")
  return ent -- The Spawner
end

function MDM_NPC.Despawn(self)
  local entity = self:GetGameEntity()
  if entity then
    entity:SetPreventCleaning(false)
    entity:DespawnImmunity(false)
    entity:Deactivate()
  end
end

function MDM_NPC.GetHealth(self)
  local npc = self:GetGameEntity()

  if npc then
    return npc.health
  end
  return self.health
end

function MDM_NPC.GetPos(self)
  local gameEntity = self:GetGameEntity()

  if gameEntity then
    return gameEntity:GetPos()
  else
    return self.pos
  end
end

function MDM_NPC.Godmode(self,bool)
  if not self then
    error("self not set",2)
  end

  self.godmode = bool
  local ent = self:GetGameEntity()

  if ent and bool then
    ent:SetDemigod(true)
    ent:EnableInjury(false)
    ent.invulnerability = true
  end

  if ent and not bool then
    --    print("Set Godmode: " .. tostring(bool))
    ent:SetDemigod(false)
    ent:EnableInjury(true)
    ent.invulnerability = false
  end
end

function MDM_NPC.OnSpawned(self,callback)
  table.insert(self.onSpawnedCallbacks,callback)
end

local function SpawnNPC(self,callback, spawnId, pos, dir)
  if not game then
    return
  end

  if not self.spawner then
    self.spawner = createSpawner(self.pos,self.dir)
  end

  local spawner_ent = self.spawner

  StartThread(function ()
    local spawner = spawner_ent:GetComponent("C_RuntimeSpawnerComponent")

    spawner_ent:Activate()
    spawner:SetSpawnProfile(spawnId)
    Wait(spawner:GetSpawnProfileLoadSyncObject())
    local output = spawner:CreateObject()
    output:SetPos(pos)
    output:SetDir(dir)
    output:Activate()
    --    spawner:TransferObjectToTrafficRaw(output) -- !!!!! DONT'T ACTIVATE !!!!! CAUSES THE NPC TO DESPAWN WHEN OUT OF SIGHT LIKE THE NORMAL TRAFFIC DOES !!!!!
    local NPCGUID = output:GetGUID()
    local NPC = game.entitywrapper:GetEntityByGUID(NPCGUID)
    self:SetGameEntity(NPC)
    --    if NPCCurrentAI == enums.AI_TYPE.CIVILIAN then
    --      print("Civilian NPC - Won't shoot")
    --    else
    --      enums.AI_TYPE.ENEMY
    --      NPC:SwitchBrain(enums.AI_TYPE.FRIEND)
    --    end
    --    table.insert(SpawnedNPCs, NPCGUID)
    -- NPC:SwitchBrain(self.aitype)
    -- NPC:SetPreventCleaning(true) !!!!!!!!!!!!!!!!!!!!!!!!!
    --NPC:DespawnImmunity() !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    --    NPC:Follow(game.game:GetActivePlayer(), "RUN", 1, 1.5)
    callback(NPCGUID,NPC)
    return
  end)
end

function MDM_NPC.IsDead(self)
  local npc = self:GetGameEntity()
  if npc then
    return npc:IsDeath()
  end

  local val = self:GetHealth() == 0
  return val
end


function MDM_NPC.MakeAlly(self,bool)

  local npc = self:GetGameEntity()
  if (bool) then
    self:Godmode(true)
    if npc then
      ai.wingmanmanager:RegisterWingman(npc)
      ai.wingmanmanager:AllowTeleportationIntoCar(npc, true)
      npc:InventorySetUnlimitedAmmo(true)
      --  npc:SetBattleArchetype("13171896828202914858") -- archetype_machinegunner_ally -- thompson ally battle ai
      npc:SetBattleArchetype("15073972356402045215") -- archetype_triggerman_ally -- thompson ally battle ai
      --    npc:MimicFriend(true)
      npc:Follow(getp(), "RUN", 1, 2)
      npc:NeverLoseTrackOfPlayer(true)
      npc:DbgTesting_HelperInventory_AddWeapon("smg_trench_a_v1", 500) -- needed for battlearchetye to work if model is not equipped with thompson.
      npc.aitype = enums.AI_TYPE.FRIEND
    end
  else
    self:Godmode(false)
    if npc then
      ai.wingmanmanager:UnregisterWingman(npc)
      ai.wingmanmanager:AllowTeleportationIntoCar(npc, false)
      npc:InventorySetUnlimitedAmmo(false)
      npc:MimicFriend(false)
      npc:NeverLoseTrackOfPlayer(false)
      npc:Forget(true)
      --      npc:RunAwayAndDespawn(nil, 20, 20)
      npc:Follow(npc, "RUN", 2, 2)

      -- npc:StopDynamicMove() !!!!!!!!!!!!!!!!!!!!
      -- npc:Block() !!!!!!!!!!!!!!!!!!!!
      --npc:WanderAway(true)

    end
  end
end


function MDM_NPC.SetHealth(self,health)
  local npc = self:GetGameEntity()
  if npc then
    npc.health = health
  else
    self.health = health
  end
end

function MDM_NPC.Spawn(self)
  if self:IsSpawned() or self.spawning then
    return
  end

  self.spawning = true

  local callback = function(game_GUID, game_npc)
    self.spawning = false
    self.spawned = true
    self.game_npc = game_npc
    self.game_GUID = game_GUID
    self:SetGameEntity(game_npc)

    if self.aitype then
      game_npc:SwitchBrain(self.aitype)
    end
    --    print("Callback Set God: " .. tostring(game_npc) .. " - " .. tostring(self:GetGameEntity()) )
    --    print("Self: " .. tostring(self) .. " GM: " .. tostring(self.godmode) )
    MDM_NPC.Godmode(self,self.godmode)
    self:Godmode()
    --    MDM_Utils.RmoveTrowableWeapons(self) -- Trying to remove molovotvs from enemies but does not work

    for i,callback in ipairs(self.onSpawnedCallbacks) do
      callback()
    end
  end

  SpawnNPC(self,callback, self.npcId,self.pos,self.dir)
end

function MDM_NPC.UnitTest ()
  print("---------------MDM_NPC UnitTest")
  local npc1 = MDM_NPC:new("123",MDM_Utils.GetVector(0,0,0),MDM_Utils.GetVector(0,0,0))

  if not npc1:GetHealth() == 100 then
    error("health 100 expected")
  end

  npc1:SetHealth(0)
  if not npc1:GetHealth() == 0 then
    error("health 0 expected")
  end

  if not npc1:IsDead() then
    error("wrong dead state")
  end
end
