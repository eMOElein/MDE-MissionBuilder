MDM_NPCIdleAnimationDirector = {}
MDM_NPCIdleAnimationDirector = MDM_Director:class()


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
  setmetatable(director, self)
  self.__index = self

  director.npc = args.npc
  director.animation = args.animation

  if director.npc:IsSpawned() then
    director:Enable()
  else
    director.npc:OnSpawned(function() director:Enable() end)
    director.npc:OnDespawned(function() director:Disable() end)
  end

  director._on_Update = function() MDM_NPCIdleAnimationDirector.Update(director) end

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

  function MDM_NPCIdleAnimationDirector._StopAnimation(self)
    local entity = self.npc:GetGameEntity()
    if not entity then
      return
    end

    if entity.StopAllAnimations then
      entity:StopAllAnimations()
    end
  end
end

function MDM_NPCIdleAnimationDirector.Enable(self)
  --  print("Enabling")
  if self:IsEnabled() then
    return
  end

  MDM_Director.Enable(self)

  -- MDM_Core.callbackSystem.RegisterCallback("on_update",self._on_Update)
  MDM_NPCIdleAnimationDirector._PlayAnimation(self)

end

function MDM_NPCIdleAnimationDirector.Disable(self)
  --  print("Disabling")
  if not self:IsEnabled() then
    return
  end

  MDM_Director.Disable(self)


  --  MDM_Core.callbackSystem.UnregisterCallback("on_update",self._on_Update)
  MDM_NPCIdleAnimationDirector._StopAnimation(self)
end

function MDM_NPCIdleAnimationDirector.Update(self)
  --  print("Updating")
  if not self:IsEnabled() then
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
    MDM_NPCIdleAnimationDirector.Disable(self)
  end

end
