MDM_AI_NPC_Carguard = {}

function MDM_AI_NPC_Carguard:new(args)
  if not args then
    error("args not set",2)
  end

  if not args.npc then
    error("npc not set",2)
  end

  if not args.cars then
    error("cars not set",2)
  end


  local director = MDM_Feature:new(args)

  director.npc = args.npc
  director.cars = args.cars
  director.engineStates = {}
  director.detectionRange = 30

  director:OnEnabled(MDM_AI_NPC_Carguard._OnEnabled)
  director:OnUpdate(MDM_AI_NPC_Carguard._OnUpdate)
  director:OnDisabled(MDM_AI_NPC_Carguard._OnDisabled)

  return director
end


function MDM_AI_NPC_Carguard._OnEnabled(self)

end

function MDM_AI_NPC_Carguard._OnDisabled(self)

end

function MDM_AI_NPC_Carguard._OnUpdate(self)
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

  MDM_AI_NPC_Carguard._EngineState(self)

  if self.attacking then
    return
  end

  MDM_AI_NPC_Carguard._Detection(self)
end

function MDM_AI_NPC_Carguard._Detection(self)
  local gameEntity = self.npc:GetGameEntity()

  if not gameEntity then
    return
  end

  for _,car in ipairs(self.cars) do
    if self.npc:GetPosition():DistanceToPoint(MDM_PlayerUtils.GetPos()) <= self.detectionRange then
      if MDM_Utils.Player.IsInCar(car) and gameEntity:GetSeePlayer() then
        self.attacking = true
        self.npc:AttackPlayer()
        break
      end
    end
  end
end

function MDM_AI_NPC_Carguard._EngineState(self)
  for _,car in ipairs(self.cars) do
    local current = car:IsEngineOn()
    local previous = self.engineStates[car]
    self.engineStates[car] = current

    if not self.attacking then
      local gameEntity = self.npc:GetGameEntity()

      -- on engine turned on
      if current and not previous then
        gameEntity:TurnAtVec(car:GetPosition(),1)
      end

      -- on engine turned off
      if not current and previous then
      end
    end
  end

end
