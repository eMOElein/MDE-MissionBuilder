MDM_NPCIdleAnimationFeature = {}

function MDM_NPCIdleAnimationFeature:new (args)
  if not args.animation then
    error("animation not set",2)
  end

  if not args.npc then
    error("npc not set",2)
  end

  if not args.npc.npcId then
    error("npc has no npcId",2)
  end

  local director = MDM_Feature:new(args)
  director.npc = args.npc
  director.animation = args.animation

  director:OnEnabled(MDM_NPCIdleAnimationFeature._OnEnabled)
  director:OnUpdate(MDM_NPCIdleAnimationFeature._OnUpdate)
  director:OnDisabled(MDM_NPCIdleAnimationFeature._OnDisabled)

  if director.npc:IsSpawned() then
    director:Enable()
  else
    director.npc:OnSpawned(function() director:Enable() end)
    director.npc:OnDespawned(function() director:Disable() end)
  end

  return director
end

function MDM_NPCIdleAnimationFeature._PlayAnimation(self)
  if self.animation ~= nil and type(self.animation) == "string" then
    local entity = self.npc:GetGameEntity()
    if not entity then
      return
    end

    entity:PlayAnimation(self.animation, true)
  end
end

function MDM_NPCIdleAnimationFeature._StopAnimation(self)
  local entity = self.npc:GetGameEntity()
  if not entity then
    return
  end

  if entity.StopAllAnimations then
    entity:StopAllAnimations()
  end
end


function MDM_NPCIdleAnimationFeature._OnEnabled(self)
  MDM_NPCIdleAnimationFeature._PlayAnimation(self)
end

function MDM_NPCIdleAnimationFeature._OnDisabled(self)
  MDM_NPCIdleAnimationFeature._StopAnimation(self)
end

function MDM_NPCIdleAnimationFeature._OnUpdate(self)
  local releaseThreshold = 2
  local gameEntity = self.npc:GetGameEntity()

  if not gameEntity then
    return
  end

  if not gameEntity.GetEnemyPerceptionState then
    return
  end

  if gameEntity:GetEnemyPerceptionState() > releaseThreshold then
    self:Disable()
  end

end
