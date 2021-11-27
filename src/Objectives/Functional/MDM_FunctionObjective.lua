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

MDM_FunctionObjective = {}
MDM_FunctionObjective = MDM_Objective:class()

local arguments = {
  callback = nil
}
--- A functional objective that executes the given callback and then succeeds
--
-- @param mission the mission that this objective should be attached to
-- @param the callback that should be executed when the objective becomes active
function MDM_FunctionObjective:new (args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if not args.callback then
    error("callback not set",2)
  end

  if type(args.callback) ~= "function" then
    error("given callback is not a function",2)
  end

  objective.callback = args.callback
  return objective
end

function MDM_FunctionObjective.Update(self)
  if not self:IsRunning() then
    return
  end

  self.callback()
  self:Succeed()
end
