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

MDM_HudTimerZeroDetector = MDM_Detector:new()

function MDM_HudTimerZeroDetector:new(args)
  local detector =  {}
  setmetatable(detector, self)
  self.__index = self
  detector.enabled = false
  detector.callback = args.callback
  return detector
end

function MDM_Detector.Update(self)
  if not self:IsEnabled() then
    return
  end

  if self.callback and self:Test() then
    self.callback()
  end
end

function MDM_Detector.Test(self)
  local time = game.hud:TimerGetTime()
  return time and time == 0
end
