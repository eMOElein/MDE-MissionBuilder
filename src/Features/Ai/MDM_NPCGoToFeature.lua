MDM_NPCGoToFeature = {}
MDM_NPCGoToFeature = MDM_Feature:class()

function MDM_NPCGoToFeature:new (args)
  local director = MDM_Feature:new(args)
  setmetatable(director, self)
  self.__index = self


  if not args.npc then
    error("npc not set",2)
  end

  if not args.position then
    error("position not set",2)
  end

  director.npc = args.npc
  director.position = args.position
  director.onPositionReachedCallbacks = MDM_List:new()
  --  director.IsPositionReached = MDM_NPCGoToFeature.IsPositionReached
  --  director.OnPositionReached = MDM_NPCGoToFeature.OnPositionReached
  --  director._OnPositionReached = MDM_NPCGoToFeature._OnPositionReached
  --  director.SetPositionReached = MDM_NPCGoToFeature.SetPositionReached
  --  director.IsPositionReached = MDM_NPCGoToFeature.IsPositionReached
  --  director.SetPosition = MDM_NPCGoToFeature.SetPosition

  director.area = MDM_Area.ForSphere({
    position = director.position,
    radius = 0.1
  })

  director.previousPerception = nil

  director:OnUpdate(MDM_NPCGoToFeature._OnUpdate)

  return director
end

function MDM_NPCGoToFeature.IsPositionReached(self)
  return self.positionReached
end

function MDM_NPCGoToFeature.SetPositionReached(self,positionReached)
  self.positionReached = positionReached
end

function MDM_NPCGoToFeature._OnPositionReached(self)
  self:SetPositionReached(true)
  self.onPositionReachedCallbacks:ForEach(function(c) c() end)
end

function MDM_NPCGoToFeature.OnPositionReached(self,callback)
  self.onPositionReachedCallbacks:Add(callback)
end

function MDM_NPCGoToFeature._OnUpdate(self)
  if self:IsPositionReached() then
    return
  end

  local gameEntity = self.npc:GetGameEntity()
  local releaseThreshold = 2

  if not gameEntity then
    return
  end

  if self.npc:IsDead() then
    return
  end

  self.area:Show()

  if self.area:IsInside(self.npc:GetPosition()) then
    self:_OnPositionReached()
    return true
  end


  --  if not self.moveInitialized and
  if gameEntity:GetEnemyPerceptionState() <= releaseThreshold then
    --    print("MoveTo: " ..tostring(self.position))
    gameEntity:MoveVec(self.position)
    self.moveInitialized = true
  end

  if not self.previousPerception then
    self.previousPerception = 0
  end

  --  if gameEntity:GetEnemyPerceptionState() > releaseThreshold and self.previousPerception <= releaseThreshold then
  --    gameEntity:MoveVec(gameEntity:GetPos())
  --  end

  --  if gameEntity:GetEnemyPerceptionState() <=releaseThreshold and self.previousPerception > releaseThreshold then
  --    gameEntity:MoveVec(self.position)
  --  end

  --  print("Perception: " ..gameEntity:GetEnemyPerceptionState())
  self.previousPerception = gameEntity:GetEnemyPerceptionState()
end

function MDM_NPCGoToFeature.SetPosition(self, position)
  --  print("SetPosition: " ..tostring(position))

  self.area = MDM_Area.ForSphere({
    position = position,
    radius = 0.1
  })

  self.position = position
  self:SetPositionReached(false)
  self.moveInitialized = false
end

function MDM_NPCGoToFeature.UnitTest()
  local npc = MDM_NPC:new({ npcId = "123", position = MDM_Utils.GetVector(1,1,1)})
  local director = MDM_NPCGoToFeature:new ({npc = npc, position = MDM_Utils.GetVector(5,5,5)})
  director:Enable()
  director:Update()
  director:Update()
  director:Update()
  director:Update()
  director:Update()
  director:Update()
end
