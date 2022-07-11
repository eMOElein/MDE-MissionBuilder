MDM_HudTimerZeroDetector = MDM_Detector:new()

function MDM_HudTimerZeroDetector:new(args)
  local detector =  {}
  setmetatable(detector, self)
  self.__index = self
  detector.enabled = false

  if not args.callback then
    error("callback not set",2)
  end

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
