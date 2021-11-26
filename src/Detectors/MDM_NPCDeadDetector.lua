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

MDM_NPCDeadDetector = {}
MDM_NPCDeadDetector = MDM_Detector:new()

function MDM_NPCDeadDetector:new (args)
  local detector =  {}
  setmetatable(detector, self)
  self.__index = self

  if not args.npcs then
    error("npcs not set",2)
  end

  if type(args.npcs) ~= "table" then
    error("npcs is not of type table",2)
  end

  detector.npcs = args.npcs
  return detector
end

function MDM_NPCDeadDetector.Test(self)
  for index,npc in ipairs(self.npcs) do
    if not npc:IsDead() then
      return false
    end
  end
  return true
end
