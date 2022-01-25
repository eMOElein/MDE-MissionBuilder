MDM_GetInCarObjective = {}
MDM_GetInCarObjective = MDM_Objective:class()

function MDM_GetInCarObjective:new (args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if not args.car then
    error("car not set",2)
  end

  objective.car = args.car

  return objective
end

function MDM_GetInCarObjective.Start(self)
  if self.car and not self.car:IsSpawned() then
    self.car:Spawn()
  end

  MDM_Objective.Start(self)
end

function MDM_GetInCarObjective.Stop(self)
  MDM_Objective.Stop(self)
end

function MDM_GetInCarObjective.Update(self)
  MDM_Objective.Update(self)

  if game and not self.markersAdded and self.car:GetGameEntity() ~= nil then
    self.mapMarker = game.navigation:RegisterObjectiveEntityDirect(self.car:GetGameEntity(), "Unknown 1", "Unknown 2", true)
    game.hud:AddEntityIndicator(self.car:GetGameEntity(), "objective_primary", MDM_Utils.GetVector(0,0,2))
    self.markersAdded = true
  end

  if self.car and self.car:IsPlayerInCar() then
    if game and self.markersAdded and self.car:GetGameEntity() ~= nil then
      game.hud:RemoveEntityIndicator(self.car:GetGameEntity())
      HUD_UnregisterIcon(self.mapMarker)
    end

    MDM_Objective.Succeed(self)
  end

end
