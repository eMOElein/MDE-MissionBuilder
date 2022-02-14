MDM_WaitObjective = {}
MDM_WaitObjective = MDM_Objective:class()

function MDM_WaitObjective:new(args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if args.seconds == nil then
    error("seconds",2)
  end

  if type(args.seconds) ~= "number" then
    error("seconds is not of type number",2)
  end

  objective.args = args

  if args.bannerText ~= nil then
    objective.timerBanner = MDM_Banner:new(args.bannerText)
  end

  return objective
end

function MDM_WaitObjective.Start(self)
  MDM_Objective.Start(self)
end

function MDM_WaitObjective.Stop(self)
  MDM_Objective.Stop(self)
end

function MDM_WaitObjective.Update(self)
  MDM_Objective.Update(self)
  if not self.running then
    return
  end

  if not self.timerStarted then
    MDM_HUDUtils.StartTimer(self.args.seconds)
    self.timerStarted = true

    if self.timerBanner ~= nil then
      self.timerBanner:Show()
    end
  end


  if self.timerStarted then
    self.time = MDM_Math.Round(MDM_HUDUtils.GetTimerValue(),1)
    MDM_HUDUtils.HideTimer()

    if self.time ~= self.lastTime then
      self.lastTime = self.time

      if self.timerBanner ~= nil then
        self.timerBanner.title = self.args.bannerText .." " ..tostring(self.time)
        self.timerBanner:Show()
      end
    end

    if MDM_HUDUtils.GetTimerValue()  == 0 then
      MDM_HUDUtils.StopTimer()

      if self.timerBanner ~= nil then
        self.timerBanner:Hide()
      end

      MDM_Objective.Succeed(self)
    end

  end
end

function MDM_WaitObjective.UnitTest()
  MDM_WaitObjective:new({
    mission = MDM_Mission:new({}),
    seconds = 10
  })
end
