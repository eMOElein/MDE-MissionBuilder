MDM_AI_NPC_BasicPatrol = {}
MDM_AI_NPC_BasicPatrol = MDM_Feature:class()

function MDM_AI_NPC_BasicPatrol:new(args)
  local patrolAi = MDM_Feature:new(args)
  setmetatable(patrolAi, self)
  self.__index = self

  if not args then
    error("args not set",2)
  end

  if not args.npc then
    error("npc not set",2)
  end

  if not args.positions then
    error("positions not set",2)
  end

  if  #args.positions < 1  then
    error("positions in list",2)
  end

  patrolAi:OnEnabled(MDM_AI_NPC_BasicPatrol._OnEnabled)
  patrolAi:OnUpdate(MDM_AI_NPC_BasicPatrol._OnUpdate)
  patrolAi:OnDisabled(MDM_AI_NPC_BasicPatrol._OnDisabled)

  -- patrolAi._GetFetchNext = MDM_AI_NPC_BasicPatrol._GetFetchNext
  -- patrolAi._GetNextPosition = MDM_AI_NPC_BasicPatrol._GetNextPosition
  -- patrolAi._SetFetchNext = MDM_AI_NPC_BasicPatrol._SetFetchNext
  -- patrolAi._OnPositionReached = MDM_AI_NPC_BasicPatrol._OnPositionReached

  patrolAi.npc = args.npc
  patrolAi.positions = MDM_List:new(args.positions)

  patrolAi.gotoAi = MDM_NPCGoToFeature:new ({npc = patrolAi.npc, position = MDM_Vector:new(0,0,0)})
  patrolAi.gotoAi:OnPositionReached(function() MDM_AI_NPC_BasicPatrol._SetFetchNext(patrolAi, true) end)
  MDM_FeatureUtils.TieToFeature(patrolAi.gotoAi, patrolAi)

  return patrolAi
end

function MDM_AI_NPC_BasicPatrol._GetNextPosition(self)
  if not self.currentPosition then
    return self.positions:Get(1)
  end

  local index = self.positions:IndexOf(self.currentPosition)

  if index < self.positions:Size() then
    index = index+1
    return self.positions:Get(index)
  end


  if self.loop then
    return self.positions:Get(1)
  end

  return nil
end

function MDM_AI_NPC_BasicPatrol._OnEnabled(self)
  print("EnableAi")
  self:_SetFetchNext(true)
end

function MDM_AI_NPC_BasicPatrol._OnDisabled(self)
  print("DisableAi")
  self:_SetFetchNext(false)
end

function MDM_AI_NPC_BasicPatrol._OnUpdate(self)
  if not self:_GetFetchNext() then
    return
  end

  if not self.npc then
    return
  end

  if not self.npc:IsSpawned() then
    return
  end

  local releaseThreshold = 2
  local gameEntity = self.npc:GetGameEntity()

  if not gameEntity then
    return
  end

  if not gameEntity.GetEnemyPerceptionState then
    return
  end

  if gameEntity:GetEnemyPerceptionState() > releaseThreshold then
    return
  end

  self.currentPosition = self:_GetNextPosition(self)

  if(self.currentPosition) then
    self.gotoAi:SetPosition(self.currentPosition)
    self:_SetFetchNext(false)
  end

end

function  MDM_AI_NPC_BasicPatrol._GetFetchNext(self)
  return self.fetchNext
end

function  MDM_AI_NPC_BasicPatrol._SetFetchNext(self, running)
  self.fetchNext = running
end
