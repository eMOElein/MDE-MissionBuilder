MDM_HUDUtils = {}

function MDM_HUDUtils.StartTimer(timerValue)
  if game then
    game.hud:TimerSet(timerValue)
    game.hud:TimerShow(true)
    game.hud:TimerStart(true)
  end
end

function MDM_HUDUtils.HideTimer()
  if game then
    game.hud:TimerShow(false)
  end
end

function MDM_HUDUtils.StopTimer()
  if game then
    game.hud:TimerSet(0)
    game.hud:TimerShow(false)
    game.hud:TimerStop(true)
  end
end

function MDM_HUDUtils.GetTimerValue()
  if game then
    local time = game.hud:TimerGetTime()
    if time then
      return time
    else
    end
  end

  return 0
end
