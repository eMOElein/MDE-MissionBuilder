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

--- MDM_InvertedDetector
-- A detector that inverts the result of the given detector
--
-- @param detector the detector that should be inverted
MDM_InvertedDirector = {}
MDM_InvertedDirector = MDM_Detector:new()

function MDM_InvertedDirector:new (args)
  local invertedDetector =  {}
  setmetatable(invertedDetector, self)
  self.__index = self

  invertedDetector.detector = args.detector
  return invertedDetector
end

function MDM_InvertedDirector.Test(self)
  return not self.detector:Test()
end
