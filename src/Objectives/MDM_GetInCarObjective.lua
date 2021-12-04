-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- MDM_GetInCarObjective
-- An objective where the player has to enter a specific car.
MDM_GetInCarObjective = {}
MDM_GetInCarObjective = MDM_Objective:class()

local args = {
  car = nil
}
--- MDM_GetInCarObjective:new
-- The constructor configuration  table must contain the following fields
--
-- @param mission an instance of MDM_Mission that this objective should be attached to
-- @param car an instance of MDM_Car
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
