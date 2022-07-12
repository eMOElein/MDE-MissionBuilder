MDM_NPCIdleAnimationDirector = {}

function MDM_NPCIdleAnimationDirector:new (args)
  if not args.animation then
    error("animation not set",2)
  end

  if not args.npc then
    error("npc not set",2)
  end

  if not args.npc.npcId then
    error("npc has no npcId",2)
  end

  local director = MDM_Director:new(args)
  director.npc = args.npc
  director.animation = args.animation

  director:OnEnabled(function() MDM_NPCIdleAnimationDirector._OnEnabled(director) end)
  director:OnUpdate(function() MDM_NPCIdleAnimationDirector._OnUpdate(director) end)
  director:OnDisabled(function() MDM_NPCIdleAnimationDirector._OnDisabled(director) end)

  if director.npc:IsSpawned() then
    director:Enable()
  else
    director.npc:OnSpawned(function() director:Enable() end)
    director.npc:OnDespawned(function() director:Disable() end)
  end

  return director
end

function MDM_NPCIdleAnimationDirector._PlayAnimation(self)
  if self.animation ~= nil and type(self.animation) == "string" then
    local entity = self.npc:GetGameEntity()
    if not entity then
      return
    end

    entity:PlayAnimation(self.animation, true)
  end
end

function MDM_NPCIdleAnimationDirector._StopAnimation(self)
  local entity = self.npc:GetGameEntity()
  if not entity then
    return
  end

  if entity.StopAllAnimations then
    entity:StopAllAnimations()
  end
end


function MDM_NPCIdleAnimationDirector._OnEnabled(self)
  MDM_NPCIdleAnimationDirector._PlayAnimation(self)
end

function MDM_NPCIdleAnimationDirector._OnDisabled(self)
  MDM_NPCIdleAnimationDirector._StopAnimation(self)
end

function MDM_NPCIdleAnimationDirector._OnUpdate(self)
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
