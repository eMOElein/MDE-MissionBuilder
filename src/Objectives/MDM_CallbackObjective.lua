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
MDM_CallbackObjective = {}
MDM_CallbackObjective = MDM_Objective:class()

local args = {
  callback = nil
}

function MDM_CallbackObjective:new (args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if not args.callback then
    error("callback not set",2)
  end

  objective.callback = args.callback
  return objective
end

function MDM_CallbackObjective.Update(self)
  MDM_Objective.Update(self)

  local result = self.callback()
  if result then
    self:Succeed()
  end
end

function MDM_CallbackObjective.UnitTest()
  print("---------------MDM_CallbackObjective UnitTest")
  local mission = MDM_Mission:new({
    title = "m"
  })

  local obj = MDM_CallbackObjective:new({
    mission = mission,
    callback = function() print("cbk") return true end
  })

  local obj2 = MDM_CallbackObjective:new({
    mission = mission,
    callback = function() print("cbk2") return true end
  })

  mission:Start()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  print("OK")
end
