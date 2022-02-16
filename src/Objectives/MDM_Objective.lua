MDM_Objective = {}

function MDM_Objective:class()
  local objective =  {}
  setmetatable(objective, self)
  self.__index = self

  return objective
end

function MDM_Objective:new(args)
  local objective = MDM_Objective:class()
  setmetatable(objective, self)
  self.__index = self

  -- args consinstency checks
  if args == nil then error("args not set",2) end
  if type(args) ~= "table" then error("args is not of type table",2) end

  if not args.mission then
    error("mission not set",2)
  end

  -- initializations
  objective.mission = args.mission
  objective.title = args.title or "New Objective"
  objective.introText = args.introText
  objective.outroText = args.outroText
  objective.task = args.task or ""
  objective.description = args.description or ""

  objective.args = args
  objective.mission = args.mission
  objective.running = false
  objective.outcome = 0
  objective.onObjectiveEndCallbacks = {}
  objective.onObjectiveStartCallbacks = {}
  objective.onUpdateCallbacks = {}
  objective.flagFailed = false

  if args.onObjectiveStart then objective:OnObjectiveStart(args.onObjectiveStart) end
  if args.onObjectiveEnd then objective:OnObjectiveEnd(args.onObjectiveEnd) end
  if args.onUpdate then objective:OnUpdate(args.onUpdate) end
  --  if args.mission then objective.mission:AddObjective(objective) end
  return objective
end

function MDM_Objective.SetOutcome(self,outcome)
  self.outcome = outcome
end

function MDM_Objective.Fail(self)
  self.flagFailed = true
  self:SetOutcome(-1)
end

function MDM_Objective.GetOutcome(self)
  return self.outcome
end

function MDM_Objective.GetMission(self)
  return self.mission
end

function MDM_Objective.IsRunning(self)
  return self.running
end

function MDM_Objective.OnUpdate(self,callback)
  if callback == nil then
    error("callback not set",2)
  end

  if type(callback) ~= "function" then
    error("callback is not of type function",2)
  end

  table.insert(self.onUpdateCallbacks,callback)
end

function MDM_Objective.GetDescription(self)
  return self.description
end

function MDM_Objective.GetTask(self)
  return self.task
end

function MDM_Objective.GetTitle(self)
  return self.title
end

function MDM_Objective.SetDescription(self,description)
  self.description = description
end

function MDM_Objective.SetTask(self,task)
  self.task = task
end

function MDM_Objective.SetTitle(self,title)
  self.title = title
end

function MDM_Objective:RemoveQuest()
end

function MDM_Objective.Start(self)
  if self.running then
    return
  end

  self.running = true

  if game then
    self.entity  = game.game:CreateCleanEntity(Math:newVector(-1225,-390,0), 0, false, false, true)
    if self.title then
      game.hud:UpdateSimpleObjective(self:GetTitle(), "param 2", true, true, "param 3")
    end
  end

  if self:GetIntroText() and game then
    game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "", self:GetIntroText())
  end

  for _,callback in ipairs(self.onObjectiveStartCallbacks) do
    callback()
  end
end

function MDM_Objective.OnObjectiveStop(self,callback)
  MDM_Objective.OnObjectiveEnd(self,callback)
end

function MDM_Objective.OnObjectiveEnd(self,callback)
  table.insert(self.onObjectiveEndCallbacks,callback)
end

function MDM_Objective.OnObjectiveStart(self,callback)
  table.insert(self.onObjectiveStartCallbacks,callback)
end

function MDM_Objective.Update(self)
  if self.running == false then
    return
  end

  MDM_Utils.Callbacks(self.onUpdateCallbacks)
end

function MDM_Objective.GetIntroText(self)
  return self.introText
end

function MDM_Objective.GetOutroText(self)
  return self.outroText
end

function MDM_Objective.SetIntroText(self, introText)
  self.introText = introText
end

function MDM_Objective.SetOutrotext(self, outroText)
  self.outroText = outroText
end

function MDM_Objective.Stop(self)
  if not self.running then
    return
  end

  if game then
    HUD_RemoveQuestObjective(self:GetTitle())
    game.hud:RemoveEntityIndicator(self.entity)
  end

  self.entity = nil
  self.running = false

  --Call onObjective End Callbacks
  for _,callback in ipairs(self.onObjectiveEndCallbacks) do
    callback(self)
  end

  if self:GetOutcome() > 0 and self:GetOutroText() and game then
    game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "", self:GetOutroText())
  end

end

function MDM_Objective.Succeed(self)
  self:SetOutcome(1)
end

function MDM_Objective.UnitTest()
  local cnt = 0
  local m = MDM_Mission:new({title = "test"})
  local o1 = MDM_MockObjective:new({mission = m, ttl = 1})

  local o2 = MDM_MockObjective:new({mission = m, ttl = 1})
  o2:OnObjectiveStart(function() cnt = cnt+1 end)

  m:AddObjective(o1)
  m:AddObjective(o2)

  m:Start()
  m:Update()
  m:Update()
  m:Update()

  if cnt == 0 then
    error("cnt should be > 0")
  end

  m:Stop()
end
