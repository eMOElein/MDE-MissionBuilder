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
--
--////////////////////////////////////////////////////////////////////////////////////////////
-- MDM_CarDamageDetector:
--
-- Monitors a given cars damage values and notifies the given callbacks
-- when a given damage threshold is reached
--////////////////////////////////////////////////////////////////////////////////////////////
MDM_CarDamageDetector = {}
MDM_CarDamageDetector = MDM_Detector:class()
---Constructor.
-- Creates a new MDM_CarDamageDetector object.
--
-- @param car The car that should be monitored.
--
-- @param threshold The threshold where the test should succeed and the callbacks should be notfied if there are any.
--                   0=OK 100=Destroyed.
--                   Default is 100.
--
-- @param flagMotorDamage true/false decides whether the motor damage is considered for the threshold or not.
--                        Default is true.
--
-- @param flagCarDamage true/false decides whether the car damage is considered for the threshold or not.
--                      Default is true.
function MDM_CarDamageDetector:new(args)
  if not args.car then
    error("car not set",2)
  end

  local director =  MDM_Detector:new()
  setmetatable(director, self)
  self.__index = self

  director.car = args.car
  director.flagMotorDamage = args.flagMotorDamage or true
  director.flagCarDamage = args.flagCarDamage or true
  director.threshold = args.threshold or 100
  director.callbacks = {}
  return director
end

-- Sets the callback functions that should ne notified when the threshold is reached
-- Callbacks are notified as long as the detector is enabled.
function MDM_CarDamageDetector.OnThreshold(self,callbacks)
  MDM_Utils.AddAll(self.callbacks,callbacks)
end


function MDM_CarDamageDetector.Test(self)
  --print("MDM_CarDamageDetector:Test: Threshold=" ..self.threshold .. " Motor=" .. self.car:GetMotorDamage() .." Car=" ..self.car:GetCarDamage())
  local car = self.car
  if car and car:IsSpawned() then
    if self.flagMotorDamage and car:GetMotorDamage() >= self.threshold then
      return true
    end

    if self.flagCarDamage and car:GetCarDamage() >= self.threshold then
      return true
    end
  end
  return false
end

function MDM_CarDamageDetector.UnitTest()
  local car = MDM_Car:new("123",MDM_Utils.GetVector(1,1,1),MDM_Utils.GetVector(1,1,1))

  local called = false
  local detector = MDM_CarDamageDetector:new({car = car, threshold = 100, flagMotorDamage = true, flagCarDamage = true})

  if detector:Test() then
    error("test should have failed",1)
  end
  if called then
    error("called should not be set",1)
  end

  MDM_Car:Explode()
end
