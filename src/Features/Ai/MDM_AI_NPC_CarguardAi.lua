MDM_AI_NPC_CarguardAi = {}

function MDM_AI_NPC_CarguardAi:new(args)
  if not args then
    error("args not set",2)
  end

  if not args.npc then
    error("npc not set",2)
  end

  local carguardAi = MDM_Feature:new(args)

  carguardAi.npc = args.npc
  carguardAi.cars = MDM_List:new(args.cars)
  carguardAi.engineStates = {}
  carguardAi.detectionRange = args.detectionRange or 35
  carguardAi.hearingDistance = args.hearingDistance or 20

  if args.car then
    carguardAi.cars:Add(args.car)
  end

  if not carguardAi.cars or #carguardAi.cars == 0 then
    error("cars not set",2)
  end

  carguardAi:OnEnabled(MDM_AI_NPC_CarguardAi._OnEnabled)
  carguardAi:OnUpdate(MDM_AI_NPC_CarguardAi._OnUpdate)
  carguardAi:OnDisabled(MDM_AI_NPC_CarguardAi._OnDisabled)

  return carguardAi
end


function MDM_AI_NPC_CarguardAi._OnEnabled(self)
  print("EnableAi")
end

function MDM_AI_NPC_CarguardAi._OnDisabled(self)
  print("DisableAi")
end

function MDM_AI_NPC_CarguardAi._OnUpdate(self)
  if not self.npc then
    return
  end

  if not self.npc:IsSpawned() then
    return
  end

  --  print("updating")

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

  if self.attacking then
    return
  end

  MDM_AI_NPC_CarguardAi._EngineState(self)

  MDM_AI_NPC_CarguardAi._Detection(self)
end

function MDM_AI_NPC_CarguardAi._Detection(self)
  local gameEntity = self.npc:GetGameEntity()

  if not gameEntity then
    return
  end

  for _,car in ipairs(self.cars) do
    if self.npc:GetPosition():DistanceToPoint(MDM_PlayerUtils.GetPos()) <= self.detectionRange then
      if MDM_Utils.Player.IsInCar(car) and gameEntity:GetSeePlayer() then
        self.attacking = true
        self.npc:AttackPlayer()
      end
    end
  end
end

function MDM_AI_NPC_CarguardAi._EngineState(self)
  for _,car in ipairs(self.cars) do
    local current = car:IsEngineOn()
    local previous = self.engineStates[car]
    self.engineStates[car] = current

    if not self.attacking then
      local gameEntity = self.npc:GetGameEntity()

      -- on engine turned on
      if current and not previous then
        print("Distance: " ..self.npc:GetPosition():DistanceToPoint(MDM_PlayerUtils.GetPos()))
        if self.npc:GetPosition():DistanceToPoint(MDM_PlayerUtils.GetPos()) <= 2 then

        end
        gameEntity:TurnAtVec(car:GetPosition(),1)
      end

      -- on engine turned off
      if not current and previous then
      end
    end
  end

end
