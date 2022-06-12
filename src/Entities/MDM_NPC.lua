MDM_NPC = {}
MDM_NPC = MDM_Entity:class()

function MDM_NPC.ForConfigs(configs)
  return MDM_List:new(configs):Map(function(config) return MDM_NPC:new(config) end)
end

function MDM_NPC:new(args)
  local npc = MDM_Entity:new(args.position,args.direction)
  setmetatable(npc, self)
  self.__index = self

  if type(args) ~= "table" then
    error("args is not of type table",2)
  end

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
  npc.health = args.health or 100
  npc.battleArchetype = args.battleArchetype

  --attributes
  npc.pos = args.position
  npc.dir = args.direction or MDM_Utils.GetVector(0,0,0)
  npc.ally = args.ally

  if args.idleAnimation then
    self.idleAnimation = MDM_NPCIdleAnimationDirector:new({
      npc = npc,
      animation = args.idleAnimation
    })
  end

  return npc
end

function MDM_NPC.AttackPlayer(self)
  local ent = self:GetGameEntity()

  local func = function()
    local ent = self:GetGameEntity()
    if ent then
      ent:Attack(getp())
      ent:NeverLoseTrackOfPlayer(true)
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

function MDM_NPC.SetPos(self,position)
  self.pos = position
end

function MDM_NPC:newCivilian(args)
  local npc = MDM_NPC:new(args)

  if game then
    npc.aiType = enums.AI_TYPE.CIVILIAN
  end

  return npc
end

function MDM_NPC:newAlly(args)
  local npc = MDM_NPC:newFriend(args)
  npc.ally = true

  return npc
end

function MDM_NPC:newEnemy(args)
  local npc = MDM_NPC:newFriend(args)

  if game then
    npc.aiType = enums.AI_TYPE.ENEMY
  end

  return npc
end

--Human:Patrol
--Human:PatrolWayPoints

function MDM_NPC:newFriend(args)
  --Human:NeverLoseTrackOfPlayer
  local npc = MDM_NPC:new(args)

  if game then
    npc.aiType = enums.AI_TYPE.FRIEND
  end

  return npc
end

local function _CreateSpawner(pos,dir)
  local entity = game.game:CreateCleanEntity(pos, 0, false, false, true)
  entity:SetPos(pos)
  entity:SetDir(dir)
  local entityWrapper = entity:GetComponent("C_EntityWrapperComponent")
  entityWrapper:SetGameEntityType(enums.EntityType.ITEM_NAVDUMMY)
  entityWrapper:SetModelName("spawn_special")
  entity:AddComponent("C_SpawnerComponent")
  entity:AddComponent("C_RuntimeSpawnerComponent")
  return entity -- the Spawner
end

function MDM_NPC.Despawn(self)
  if not self:IsSpawned() then
    return
  end

  if  not self:_IsDirty() then
    local entity = self:GetGameEntity()
    if entity then
      entity:SetPreventCleaning(false)
      entity:DespawnImmunity(false)
      entity:Deactivate()
      self.spawner:Deactivate()
    end
  end

  for _,callback in ipairs(self.onDespawnedCallbacks) do
    callback()
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

  if gameEntity and gameEntity.GetPos then
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

    --spawnId =
    runtimeSpawner:SetSpawnProfile(spawnId)
    Wait(runtimeSpawner:GetSpawnProfileLoadSyncObject())

    local object = runtimeSpawner:CreateObject()
    object:SetPos(pos)
    object:SetDir(dir)
    object:Activate()

    local npcGuid = object:GetGUID()
    local npcEntity = game.entitywrapper:GetEntityByGUID(npcGuid)

    if self.battleArchetype ~= nil then
      npcEntity:SetBattleArchetype(self.battleArchetype)
    end

    if self.health and type(self.health) == "number" then
      npcEntity.health = self.health
    end

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

  return self:GetHealth() == 0
end

function MDM_NPC._IsDirty(self)
  if self:IsSpawned() and not self:GetGameEntity() then
    return true
  end

  if self:GetGameEntity() and not self:GetGameEntity().GetPos then
    return true
  end
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
      npc.aiType = enums.AI_TYPE.FRIEND
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

    if self.aiType then
      game_npc:SwitchBrain(self.aiType)
    end

    MDM_NPC.Godmode(self,self.godmode)
    self:Godmode()

    if self.ally then
      self:MakeAlly(true)
    end

    for _,callback in ipairs(self.onSpawnedCallbacks) do
      callback()
    end
  end

  _SpawnNPC(self,callback, self.npcId,self.pos,self.dir)
end

function MDM_NPC.MakeEnemy(self)
  self:_SetAiType(enums.AI_TYPE.ENEMY)
end

function MDM_NPC._SetAiType(self,aiType)
  if self.aiType ~= aiType then
    self.aiType = aiType
    if self.aiType and self:GetGameEntity() then
      self:GetGameEntity():SwitchBrain(self.aiType)
    end
  end
end

function MDM_NPC.UnitTest ()
  local npc1 = MDM_NPC:new({npcId = "123",position = MDM_Utils.GetVector(0,0,0),direction = MDM_Utils.GetVector(0,0,0)})

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
