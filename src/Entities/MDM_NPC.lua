MDM_NPC = {}
MDM_NPC = MDM_Entity:class()

local arguments = {
  npcId = nil, --MANDATORY
  position = nil, --MANDATORY
  direction = nil,
  aiType = nil
}

function MDM_NPC:fromArgs(args)
  local npc = MDM_Entity:new(args.position,args.direction)
  setmetatable(npc, self)
  self.__index = self

  if not args.npcId then
    error("npcId not set",2)
  end

  if not args.position then
    error("position not set",2)
  end


  npc.args = args
  npc.npcId = args.npcId
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
  npc.pos = args.position
  npc.dir = args.direction or MDM_Utils.GetVector(0,0,0)

  return npc
end

function MDM_NPC:new(npcId,pos,dir)
  return MDM_NPC:fromArgs({
    npcId = npcId,
    position = pos,
    direction = dir
  })
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
    return self.ent:GetPos()
  else
    return self.pos
  end
end

function MDM_NPC:newCivilian(npcId,pos,dir)
  local npc = MDM_NPC:new(npcId,pos,dir)

  if game then
    npc.aitype = enums.AI_TYPE.CIVILIAN
  end

  return npc
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

local function _CreateSpawner(pos,dir)
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

local function _SpawnNPC(self,callback, spawnId, pos, dir)
  if not game then
    return
  end

  if not self.spawner then
    self.spawner = _CreateSpawner(self.pos,self.dir)
    self.spawner:Activate()
  end

  StartThread(function ()
    local runtimeSpawner = self.spawner:GetComponent("C_RuntimeSpawnerComponent")

    runtimeSpawner:SetSpawnProfile(spawnId)
    Wait(runtimeSpawner:GetSpawnProfileLoadSyncObject())

    local output = runtimeSpawner:CreateObject()
    output:SetPos(pos)
    output:SetDir(dir)
    output:Activate()

    local npcGuid = output:GetGUID()
    local npcEntity = game.entitywrapper:GetEntityByGUID(npcGuid)
    self:SetGameEntity(npcEntity)

    local returnArgs = {
      guid = npcGuid,
      entity = npcEntity
    }

    callback(returnArgs,npcGuid,npcEntity)
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

  local callback = function(args,game_GUID, game_npc)
    self.spawning = false
    self.spawned = true
    self.game_npc = args.entity
    self.game_GUID = args.guid
    self:SetGameEntity(args.entity)

    if self.aitype then
      game_npc:SwitchBrain(self.aitype)
    end

    MDM_NPC.Godmode(self,self.godmode)
    self:Godmode()

    for _,callback in ipairs(self.onSpawnedCallbacks) do
      callback()
    end
  end

  _SpawnNPC(self,callback, self.npcId,self.pos,self.dir)
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
