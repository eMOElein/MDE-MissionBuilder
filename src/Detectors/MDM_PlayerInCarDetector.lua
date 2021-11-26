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
car = nil --Mandatory
}

function MDM_PlayerInCarDetector:new (args)
  local detector =  {}
  setmetatable(detector, self)
  self.__index = self

  if not args.car then
    error("car is nil",2)
  end

  if type(args.car) ~= "table" then
    error("car must be of type table",2)
  end

  detector.car = args.car
  return detector
end

function MDM_PlayerInCarDetector.Test(self)
  return self.car:IsPlayerInCar()
end

function MDM_PlayerInCarDetector.UnitTest()
  local value = false
  local detector = MDM_PlayerInCarDetector:new({car = {IsPlayerInCar = function() return value end}})

  if detector:Test() then
    error("test should have failed ",1)
  end

  value = true

  if not detector:Test() then
    error("test should not have failed ",1)
  end
end
