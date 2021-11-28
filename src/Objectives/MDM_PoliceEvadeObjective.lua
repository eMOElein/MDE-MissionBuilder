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

MDM_PoliceEvadeObjective = MDM_Objective:class()

local args = {
  initialLevel = 1
}
function MDM_PoliceEvadeObjective:new (args)
  if not args.initialLevel then
    error("initial level not set",2)
  end

  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self
  objective.title = "Evade the police"
  objective.task = "Evade the police"
  objective.description = "Evade the police"
  objective.initLevel = args.initialLevel
  return objective
end

function MDM_PoliceEvadeObjective.SetInitialWantedLevel(self,level)
  self.initLevel = level
end

function MDM_PoliceEvadeObjective.Update(self)
  if not self.running then
    return
  end

  if not MDM_PoliceUtils.IsPlayerHunted() then
    MDM_Objective.SetOutcome(self,1)
  else
  end

  MDM_Objective.Update(self)
end

function MDM_PoliceEvadeObjective.Start(self)
  if self.initLevel > 0 then
    MDM_PoliceUtils.SetWantedLevel(self.initLevel)
  end
  MDM_Objective.Start(self)
end
