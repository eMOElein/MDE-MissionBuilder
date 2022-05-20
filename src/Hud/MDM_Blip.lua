MDM_Blip = {}
MDM_Blip.instances = 0

function MDM_Blip.ForNPC(config)
  if not config.npc then
    error("npc not set",2)
  end

  if type(config.npc) ~= "table" then
    error("npc must be of type MDM_NPC",2)
  end

  local blip =  MDM_Blip:_new({
    entity = config.npc
  })

  blip:Show()
  return blip
end

function MDM_Blip.ForVector(config)
  if not config.vector then
    error("vector not set",2)
  end

  local blip =  MDM_Blip.MDM_VectorBlip:_new(config)
  blip:Show()
  return blip
end

function MDM_Blip:_new(config)
  print("NEWBLIP")
  if not config.entity then
    error("entity not set",2)
  end

  local blip = {}
  setmetatable(blip, self)
  self.__index = self

  blip.entity = config.entity
  blip.onupdate = function() MDM_Blip._OnUpdate(blip) end

  MDM_Blip.instances = MDM_Blip.instances +1
  blip.instance = MDM_Blip.instances
  return blip
end

function MDM_Blip.Show(self)
  if self:IsShowing() then
    return
  end

  self:_SetShowing(true)
  MDM_Core.callbackSystem.RegisterCallback("on_update",self.onupdate)
end

function MDM_Blip._OnUpdate(self)
  if self:IsShowing() and not self.marker and self.entity:GetGameEntity() ~= nil then
    self.marker = {}

    if game then
      self.marker = game.navigation:RegisterObjectiveEntityDirect(self.entity:GetGameEntity(), "Unknown 1", "Unknown 2", true)
      game.hud:AddEntityIndicator(self.entity:GetGameEntity(), "objective_primary", MDM_Vector:new(0,0,0))
    end
    MDM_Core.callbackSystem.UnregisterCallback("on_update",self.onupdate)
  end

end

function MDM_Blip.IsShowing(self)
  return self.showing
end

function MDM_Blip._SetShowing(self,showing)
  self.showing = showing
end

function MDM_Blip.Hide(self)
  MDM_Core.callbackSystem.UnregisterCallback("on_update",self.onupdate)
  self:_SetShowing(false)

  if game and self.marker  then
    HUD_UnregisterIcon(self.marker)
    game.hud:RemoveEntityIndicator(self.entity:GetGameEntity(), "objective_primary", MDM_Vector:new(0,0,0))
    self.marker = nil
  end
end

MDM_Blip.MDM_VectorBlip = {

    _new = function (self, config)
      if not config.vector then
        error("vector not set",2)
      end

      local entity = {}
      if(game) then
        entity = game.game:CreateCleanEntity(config.vector, 0, false, false, true)
        entity:SetPos(config.vector)
        entity:Activate()
      end

      local blip = MDM_Blip:_new({entity = {
        GetGameEntity = function ()
          return entity
        end
      }})


      blip.hide = function()
        blip.entity:SetPreventCleaning(false)
        blip.entity:DespawnImmunity(false)
        blip.entity:Deactivate()

        MDM_Blip.Hide(blip)
      end
      return blip
    end

}

function MDM_Blip.UnitTest()
  local npc = MDM_NPC:new({npcId="ddf", position = MDM_Vector:new(1,1,1)})
  local blip = MDM_Blip.ForNPC({npc = npc})


  local counter = 0
  blip.onupdate = function() counter = counter + 1 print("IncC")end
  blip:Show()
  MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})
  blip:Show()
  MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})
  blip:Hide()
  MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})
  blip:Show()
  MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})

  if counter ~= 1 then
    error("expected value" ..1 .."but was" .. counter)
  end

  local vectorBlip = MDM_Blip.ForVector({vector = MDM_Vector:new(1,2,3)})
  vectorBlip:Show()
  MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})
  MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})
  MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})
  vectorBlip:Hide()
  MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})
end
