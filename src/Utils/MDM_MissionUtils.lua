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

MDM_MissionUtils = {}

--- Starts a timer on the hud that runs within the span of two objectives.
--
-- @param objectiveFrom timer begins with the start of the objective
-- @param objectiveTo timer ends with the stop of the objective
-- @param timerValue timer value im seconds
-- @param callback function that gets called when the timer reaches 0
function MDM_MissionUtils.RunTimerBetweenObjectives(mission, objectiveFrom, objectiveTo, timerValue, callback)
  objectiveFrom:OnObjectiveStart(function() MDM_HUDUtils.StartTimer(timerValue) end)
  objectiveTo:OnObjectiveStop(function() MDM_HUDUtils.StopTimer() end)

  local timerZeroDetector = MDM_HudTimerZeroDetector:new({callback = callback})
  MDM_ActivatorUtils.EnableOnObjectiveStart(timerZeroDetector,objectiveFrom)
  MDM_ActivatorUtils.DisableOnObjectiveStop(timerZeroDetector,objectiveTo)
  mission:AddDirector(timerZeroDetector)
end
