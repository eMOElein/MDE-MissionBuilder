MDM_NPCGoToDirector = {}
MDM_NPCGoToDirector = MDM_Director:class()

function MDM_NPCGoToDirector:new (args)
  local director = MDM_Director:new(args)
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
  director.detector = MDM_EntityInCircleDetector:new({entity = director.npc, position =  director.position, radius = 1})
  self.previousPerception = nil
  return director
end

function MDM_NPCGoToDirector.Update(self)
  if not MDM_Director.Update(self) then
    return
  end

  local gameEntity = self.npc:GetGameEntity()

  if not gameEntity then
    return false
  end

  if self.npc:IsDead() then
    self:Disable()
    return true
  end

  if self.detector:Test() then
    self:Disable()
    return true
  end

  if not self.moveInitialized then
    --    print("Init with: " ..tostring(self.position))
    gameEntity:MoveVec(self.position)
    self.moveInitialized = true
  end

  if not self.previousPerception then
    self.previousPerception = 0
  end

  local releaseThreshold = 2
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

function MDM_NPCGoToDirector.Disable(self)
  MDM_Director.Disable(self)
  --      print("Disabling MoveTo")
end

function MDM_NPCGoToDirector.UnitTest()
  print("------------MDM_NPCGoToDirecto Test")

  local npc = MDM_NPC:new({ npcId = "123", position = MDM_Utils.GetVector(1,1,1)})
  local director = MDM_NPCGoToDirector:new ({npc = npc, position = MDM_Utils.GetVector(5,5,5)})
  director:Enable()
  director:Update()
  director:Update()
  director:Update()
  director:Update()
  director:Update()
  director:Update()
end
