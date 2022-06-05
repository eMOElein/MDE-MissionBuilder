MDM_Mission = {}
MDM_Mission = MDM_Updateable:new()

function MDM_Mission:class()
  local mission =  {}
  setmetatable(mission, self)
  self.__index = self

  return mission
end

function MDM_Mission:new (args)
  local mission = MDM_Updateable:new()
  setmetatable(mission, self)
  self.__index = self

  if not args then
    error("args not set",2)
  end

  mission.objectives = {}
  mission.OnActiveObjectiveChangedCallbacks = {}
  mission.OnMissionEndCallbacks = {}
  mission.OnMissionStartCallbacks = {}
  mission.running = false
  mission.currentObjective = 0
  mission.description = ""
  mission.Outcome = 0
  mission.title = args.title
  mission.introText = args.introText
  mission.outroText = args.outroText
  mission.failText = "Mission Failed"
  mission.failDescription = nil
  mission.flagFailed = false
  mission.introductionShown = false
  mission.startPosition = args.startPosition
  mission.startDirection = args.startDirection
  mission.initialOutfit = args.initialOutfit
  mission.initialSeason = args.initialSeason
  mission.initialWeather = args.initialWeather
  mission.assets = {}

  if args.onMissionStart then
    mission:OnMissionStart(args.onMissionStart)
  end

  if args.onMissionEnd then
    mission:OnMissionEnd(args.onMissionEnd)
  end

  if args.assets ~= nil then
    MDM_Mission.AddAssets(mission,args.assets)
  end

  if mission.title then
    mission.titleBanner = MDM_Banner:new(mission:GetTitle())
  end

  mission.missionCompleteBanner = MDM_Banner:new("Mission Passed!")
  return mission
end

function MDM_Mission.AddAsset(self, spawnable_asset)
  if spawnable_asset == nil then
    error("asset is nil",2)
  end

  table.insert(self.assets,spawnable_asset)
end

function MDM_Mission.AddAssets(self, spawnable_assets)
  if not spawnable_assets then
    error("assets value is nil",2)
  end

  for _,a in ipairs(spawnable_assets) do
    if a ~= nil then
      MDM_Mission.AddAsset(self,a)
    end
  end
end

function MDM_Mission.AddObjective(self,objective)
  table.insert(self.objectives,objective)
end

function MDM_Mission.AddObjectives(self,objectives)
  for _,o in ipairs(objectives) do
    self:AddObjective(o)
  end
end

function MDM_Mission.Fail(self,message)
  self:SetOutcome(self,-1)
  self.flagFailed = true

  if message then
    self.failDescription = message
  end

  local cObj = self:GetCurrentObjective()
  if cObj then
    cObj:Fail()
  end

  self:Stop(self)
end

function MDM_Mission.GetAssets(self)
  return self.assets
end

function MDM_Mission.GetCurrentObjective(self)
  return self.objectives[self.currentObjective]
end

function MDM_Mission.GetNextObjective(self)
  return self.objectives[self.currentObjective + 1]
end

function MDM_Mission.OnMissionStart(self,callback)
  table.insert(self.OnMissionStartCallbacks,callback)
end

function MDM_Mission.OnActiveObjectiveChanged(self,callback)
  table.insert(self.OnActiveObjectiveChangedCallbacks,callback)
end

function MDM_Mission.SetInitialOutfit(self,outfitId)
  self.initialOutfit = outfitId
end

function MDM_Mission.GetInitialOutfit(self)
  return self.initialOutfit
end

function MDM_Mission.GetIntroText(self)
  return self.introText
end

function MDM_Mission.GetStartPos(self)
  return self.startPosition
end

function MDM_Mission.SetStartPos(self, startPos)
  self.startPosition = startPos
end

function MDM_Mission.SetIntroText(self,introText)
  self.introText = introText
end

function MDM_Mission.SetOutcome(self,outcome)
  self.outcome = outcome
end

function MDM_Mission.GetTitle(self)
  return self.title
end

function MDM_Mission.SetTitle(self,title)
  self.title = title
end

function MDM_Mission.OnMissionEnd(self, callback)
  table.insert(self.OnMissionEndCallbacks,callback)
end

function MDM_Mission.IsRunning(self)
  return self.running
end

function MDM_Mission.GetInitialSeason(self,seasonNumber)
  return self.initialSeason
end

function MDM_Mission.SetInitialSeason(self,seasonNumber)
  self.initialSeason = seasonNumber
end

function MDM_Mission.GetInitialWeather(self,weatherId)
  return self.initialWeather
end

function MDM_Mission.SetInitialWeather(self,weatherId)
  self.initialWeather = weatherId
end

function MDM_Mission.Start(self)
  if self.running then
    return
  end

  if #self.objectives <= 0 then
    error("mission has no objectives",2)
  end

  if game  and self.introduction then
    game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "", self.introduction)
  end

  self.running = true

  if game then
    if self.titleBanner then
      self.titleBanner.time = 2000
      self.titleBanner:Show()
    end
    game.audio:PlaySimpleEvent("mx_Gameplay_Music_Mission_Complete")
  end

  if self:GetIntroText() and game then
    game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "", self:GetIntroText())
  end

  for _,callback in ipairs(self.OnMissionStartCallbacks) do callback(self) end
  --  MDM_Utils.ForEach(self.OnMissionStartCallbacks,function(callback) callback(self) end)
end

function MDM_Mission.SetFailText(self,text)
  self.failText = text
end

function MDM_Mission.SetFailDescription(self,text)
  self.failDescription = text
end

function MDM_Mission.GetOutroText(self)
  return self.outroText
end

function MDM_Mission.SetOutroText(self,outroText)
  self.outroText = outroText
end

function MDM_Mission.Stop(self)
  if not self.running then
    return
  end

  self.running = false

  local cObj =  self:GetCurrentObjective()
  if cObj and cObj:IsRunning() then
    cObj:Stop()
  end

  --game.audio:PlaySimpleEvent("ui_EF_Textbox_Show")
  --game.audio:PlaySimpleEvent("ui_Store_Menu_Enter")
  --game.audio:PlaySimpleEvent("ui_Store_Menu_Exit")

  for _,callback in ipairs(self.OnMissionEndCallbacks) do
    callback()
  end

  if game then
    if self.flagFailed then
      self.missionCompleteBanner.title = self.failDescription or "Mission Failed!"
      self.missionCompleteBanner.color = 0
    end
    local sound = "mx_Gameplay_Music_Mission_Complete"
    game.audio:PlaySimpleEvent(sound)
    self.missionCompleteBanner.time = 2000
    self.missionCompleteBanner:Show()
  end


  if not self.flagFailed and self:GetOutroText() and game then
    game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "", self:GetOutroText())
  end


  for _,a in ipairs(self.assets) do
    if self.flagFailed then
      a:Despawn()
    else
      MDM_SpawnManager.MarkForDistanceDespawn(a,50)
    end
  end
end

function MDM_Mission.Succeed(self)
  self.flagFailed = false
  self:Stop()
end

function MDM_Mission.Update(self)
  if not self.running then
    return
  end

  local cObj = MDM_Mission.GetCurrentObjective(self)

  MDM_Updateable.Update(self)

  if not cObj then
    cObj  = MDM_Mission.GetNextObjective(self)
    if cObj then --First Objective
      cObj:Start()
      self.currentObjective = self.currentObjective +1
      return
    end
  end

  cObj:Update()

  if cObj:GetOutcome() < 0 then
    self:Fail()
    return
  end

  if cObj:GetOutcome() ~= 0 then
    cObj:Stop()
  end

  local nextObj = MDM_Mission.GetNextObjective(self)

  -- Last Objective
  if cObj:GetOutcome() ~= 0 and not nextObj then
    self:Stop()
  end

  -- Next Objective
  if cObj:GetOutcome() ~= 0 and nextObj then


    nextObj:Start()
    self.currentObjective = self.currentObjective +1
    return
  end
end

function MDM_Mission.UnitTest()
  local onMissionEndCalled = 0

  local  m = MDM_Mission:new({title = "Missiontest",
    onMissionEnd = function() onMissionEndCalled = onMissionEndCalled +1 end
  })

  local  o1 = MDM_MockObjective:new({mission = m})
  local  o2 = MDM_MockObjective:new({mission = m})

  m:AddObjective(o1)
  m:AddObjective(o2)


  m:OnMissionEnd(function() onMissionEndCalled = onMissionEndCalled +1 end)


  m:Start()
  m:Update()
  if not m:IsRunning() then error("mission sould still be running") end
  m:Update()
  m:Update()
  m:Update()
  m:Update()
  m:Update()
  m:Update()
  if m:IsRunning() then error("mission should not be running anymore") end

  m:OnMissionEnd(function() onMissionEndCalled = true end)

  m:Stop()

  if onMissionEndCalled ~= 2 then
    error("onMissionEnd should have been called 2 times")
  end
end
