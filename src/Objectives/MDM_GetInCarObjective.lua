-- MDM_GetInCarObjective
-- An objective where the player has to enter a specific car.
MDM_GetInCarObjective = {}
MDM_GetInCarObjective = MDM_Objective:class()

local args = {
  car = nil
}

function MDM_GetInCarObjective:new (args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if not args.car then
    error("car not set",2)
  end

  objective.car = args.car
  objective.blip = MDM_ObjectivePosition:new(objective:GetTitle(), objective.car:GetPos())

  return objective
end

function MDM_GetInCarObjective.Start(self)
  if self.car and not self.car:IsSpawned() then
    self.car:Spawn()
  end

  MDM_ObjectivePosition.show(self.blip)
  MDM_Objective.Start(self)
end

function MDM_GetInCarObjective.Stop(self)
  MDM_ObjectivePosition.Hide(self.blip)
  MDM_Objective.Stop(self)
end

function MDM_GetInCarObjective.Update(self)
  if self.car and self.car:IsPlayerInCar() then
    MDM_Objective.Succeed(self)
  end

  MDM_Objective.Update(self)
end
