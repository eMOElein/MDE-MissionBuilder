MDM_MissionUtils = {}

--- Starts a timer on the hud that runs within the span of two objectives.
--
-- @param objectiveFrom timer begins with the start of the objective
-- @param objectiveTo timer ends with the stop of the objective
-- @param timerValue timer value im seconds
-- @param callback function that gets called when the timer reaches 0
function MDM_MissionUtils.RunTimerBetweenObjectives(mission, objectiveFrom, objectiveTo, timerValue, callback)
  objectiveFrom:OnObjectiveStart(function()
    MDM_HUDUtils.StartTimer(timerValue)
  end)

  objectiveTo:OnObjectiveEnd(function()
    MDM_HUDUtils.StopTimer()
    MDM_HUDUtils.HideTimer()
  end)

  local timerZeroDetector = MDM_CallbackFeature:new({
    callback = function()
      local time = game.hud:TimerGetTime()
      if time and time == 0 then
        callback()
      end
    end
  })
  MDM_FeatureUtils.EnableOnObjectiveStart(timerZeroDetector,objectiveFrom)
  MDM_FeatureUtils.DisableOnObjectiveStop(timerZeroDetector,objectiveTo)
end
