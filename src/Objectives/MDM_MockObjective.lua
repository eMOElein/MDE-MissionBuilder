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
MDM_MockObjective = {}
MDM_MockObjective = MDM_Objective:class()

local args = {
  ttl = 1
}

function MDM_MockObjective:new (args)
  if not args.mission then
    error("mission not set",2)
  end

  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  objective.ttl = args.ttl or 1
  return objective
end

function MDM_MockObjective.Update(self)
  MDM_Objective.Update(self)
  self.ttl  = self.ttl -1
  if(self.ttl <= 0) then
    self:Succeed()
  end
end
