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

MDM_PlayerInCarDetector = {}
MDM_PlayerInCarDetector = MDM_Detector:new()

local args = {
  car = nil
}

function MDM_PlayerInCarDetector:new (args)
  local detector =  {}
  setmetatable(detector, self)
  self.__index = self

  if args.car and type(args.car) ~= "table" then
    error("car must be of type table",2)
  end

  detector.args = args
  detector.car = args.car or nil
  return detector
end

function MDM_PlayerInCarDetector.Test(self)
  if self.car then
    return self.car:IsPlayerInCar()
  else
    return MDM_VehicleUtils.GetPlayerCurrentVehicle() ~= nil
  end
end

function MDM_PlayerInCarDetector.UnitTest()

end
