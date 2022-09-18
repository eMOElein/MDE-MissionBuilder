MDM_NPCGoToFeature = {}

function MDM_NPCGoToFeature:new (args)
  local director = MDM_Feature:new(args)

  if not args.npc then
    error("npc not set",2)
  end

  if not args.position then
    error("position not set",2)
  end

  director.npc = args.npc
  director.position = args.position
  director.onPositionReachedCallbacks = MDM_List:new()
  director.area = MDM_Area.ForSphere({
    position = director.position,
    radius = 1
  })

  director.previousPerception = nil

  director:OnUpdate(MDM_NPCGoToFeature._OnUpdate)

  return director
end

function MDM_NPCGoToFeature._OnPositionReached(self)
  self.onPositionReachedCallbacks:ForEach(function(c) c() end)
end

function MDM_NPCGoToFeature.OnPositionReached(self,callback)
  self.onPositionReachedCallbacks:add(callback)
end

function MDM_NPCGoToFeature._OnUpdate(self)
  local gameEntity = self.npc:GetGameEntity()
  local releaseThreshold = 2

  if not gameEntity then
    return false
  end

  if self.npc:IsDead() then
    self:Disable()
    return true
  end

  if self.area:IsInside(self.npc:GetPosition()) then
    self:_OnPositionReached()
    self:Disable()
    return true
  end

  if not self.moveInitialized and gameEntity:GetEnemyPerceptionState() <= releaseThreshold then
    --    print("Init with: " ..tostring(self.position))
    gameEntity:MoveVec(self.position)
    self.moveInitialized = true
  end

  if not self.previousPerception then
    self.previousPerception = 0
  end

  if gameEntity:GetEnemyPerceptionState() > releaseThreshold and self.previousPerception <= releaseThreshold then
    --   print("Release with: " ..tostring(gameEntity:GetPos()))
    gameEntity:MoveVec(gameEntity:GetPos())
  end

  if gameEntity:GetEnemyPerceptionState() <=releaseThreshold and self.previousPerception > releaseThreshold then
    --   print("Continue")
    gameEntity:MoveVec(self.position)
  end

  --  print("Perception: " ..gameEntity:GetEnemyPerceptionState())
  self.previousPerception = gameEntity:GetEnemyPerceptionState()
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
