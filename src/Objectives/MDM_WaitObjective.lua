MDM_WaitObjective = {}

function MDM_WaitObjective:new(args)
  local objective = MDM_Objective:new(args)

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

  objective:OnUpdate(MDM_WaitObjective._OnUpdate)

  return objective
end


function MDM_WaitObjective._OnUpdate(self)
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

      self:Succeed()
    end

  end
end

function MDM_WaitObjective.UnitTest()
  MDM_WaitObjective:new({
    mission = MDM_Mission:new({}),
    seconds = 10
  })
end
