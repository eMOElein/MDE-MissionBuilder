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
--  mission:AddDirector(timerZeroDetector)
end
