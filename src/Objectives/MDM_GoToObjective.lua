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
MDM_GoToObjective = {}
MDM_GoToObjective = MDM_Objective:class()

local args = {
  position = nil,
  radius = nil,
  outroText = nil,
  introText = nil
}
function MDM_GoToObjective:new(args)
  if not args.position then
    error("vector not set",2)
  end

  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  objective.vector = args.position
  objective.radius = args.radius or 20
  objective.title = "go to the location"
  objective.task = "go to the location"
  objective.description = "go to the location"
  objective.blip = MDM_ObjectivePosition:new(objective.title ,objective.vector,objective.radius)
  objective.detector = MDM_EntityInCircleDetector:new({entity = MDM_PlayerUtils.GetPlayer(), position = objective.vector, radius = objective.radius})
  return objective
end


function MDM_GoToObjective:PlayerDistanceToObjective(vector)
  local Distance = 0
  if game then
    Distance = getp():GetPos():DistanceToPoint(vector)
  end
  return Distance
end

function MDM_GoToObjective.Start(self)
  MDM_Objective.Start(self)

  if self.blip then
    self.blip:AddToMap()
  end
end

function MDM_GoToObjective.Stop(self)
  if self.blip then
    self.blip:RemoveFromMap()
  end
  MDM_Objective.Stop(self)
end

function MDM_GoToObjective.Update(self)
  MDM_Objective.Update(self)
  if not self.running then
    return
  end

  if self.detector:Test() then
    self:Succeed()
  end
end

function MDM_GoToObjective.UnitTest()
  print("---------------MDM_GoToObjective UnitTest")
  local vec = MDM_Utils.GetVector(-907.94,-160.41,2)

  local m = MDM_Mission:new({title = "Test"})
  local objective = MDM_GoToObjective:new({mission = m, position = vec})
  objective.title = "Objective 2"
  objective.task = "Go to the marked location"
  objective.description = "Blablabla"

  if not objective then
    error ("objective is nil" ,2)
  end

  if not objective.vector then
    error("objective vector is nil",2)
  end
end
