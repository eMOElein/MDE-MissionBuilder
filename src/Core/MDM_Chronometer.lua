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

MDM_Chronometer = {}

function MDM_Chronometer:class()
  local chronometer = {}
  setmetatable(chronometer, self)
  self.__index = self

  return chronometer
end

--- MDM_Chronometer
-- Utility for measuring the amount of runtime since the chronometer was started
--
-- @Param timeProvider a callback that returns a number with a specific amount of passed time since gamestart
function MDM_Chronometer:new(timeProvider)
  if not timeProvider then
    error("timeProvider not set",2)
  end

  if type(timeProvider) ~= "function" then
    error("timeProvider is no function",2)
  end

  local chronometer = MDM_Chronometer:class()
  chronometer.timeProvider = timeProvider
  chronometer.startTime = 0
  return chronometer
end

function MDM_Chronometer.newGlobalChronometer()
  local chronometer = MDM_Chronometer:new(function() return MDM_Core.currentTime end)
  return chronometer
end

function MDM_Chronometer.Start(self)
  self.startTime = self.timeProvider()
end

function MDM_Chronometer.GetTime(self)
  local time = self.timeProvider()
  return time - self.startTime
end
