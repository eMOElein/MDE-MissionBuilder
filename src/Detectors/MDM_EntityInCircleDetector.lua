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

MDM_EntityInCircleDetector = {}
MDM_EntityInCircleDetector = MDM_Detector:new()

local arguments = {
  entity = nil,
  position = nil,
  radius = nil
}
function MDM_EntityInCircleDetector:new (args)
  if not args.entity then
    error("entity not set",2)
  end

  if not args.position then
    error("pos not set",2)
  end

  if not args.radius then
    error ("radius not set",2)
  end

  local detector =  MDM_Detector:new()
  setmetatable(detector, self)
  self.__index = self
  detector.entity = args.entity
  detector.pos = args.position
  detector.radius = args.radius
  self.entered = false
  self.left = false
  self.inside = false
  self.previous = false
  return detector
end

function MDM_EntityInCircleDetector.HasEntered(self)
  return self.entered
end

function MDM_EntityInCircleDetector.HasLeft(self)
  return self.left
end

function MDM_EntityInCircleDetector.Test(self)
  local distance = MDM_Utils.VectorDistance(self.entity:GetPos(),self.pos)

  self.inside = distance <= self.radius
  self.entered =  not self.previous and self.inside
  self.left = self.previous and not self.inside
  self.previous = self.inside
  return self.inside
end

function MDM_EntityInCircleDetector.UnitTest()
  print("---------------MDM_EntityInCircle: UnitTest")

  local pos1 = MDM_Utils.GetVector(0,0,0)
  local pos2 = MDM_Utils.GetVector(500,500,500)

  local npc1 = MDM_NPC:new("12345",pos1,pos1)
  local detector1 = MDM_EntityInCircleDetector:new ({entity = npc1, position = pos2, radius = 50})
  if detector1:Test() then
    error("false expected but was: " ..tostring(detector1:Test()),1)
  end

  local npc2 = MDM_NPC:new("12345",pos2,pos1)
  local detector2 = MDM_EntityInCircleDetector:new ({entity = npc2, position = pos2, radius = 50})
  if not detector2:Test() then
    error("true expected but was: " ..tostring(detector2:Test()),1)
  end
end
