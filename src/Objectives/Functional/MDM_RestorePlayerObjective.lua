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

MDM_RestorePlayerObjective = {}
MDM_RestorePlayerObjective = MDM_Objective:class()

function MDM_RestorePlayerObjective:new ()
  local objective = MDM_Objective:new({})
  setmetatable(objective, self)
  self.__index = self

  return objective
end

function MDM_RestorePlayerObjective.Update(self)
  if not self:IsRunning() then
    return
  end

  MDM_PlayerUtils.RestorePlayer()
  self:Succeed()
  MDM_Objective.Update(self)
end
