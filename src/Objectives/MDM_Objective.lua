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

  if args == nil then
    error("args not set",2)
  end

  if type(args) ~= "table" then
    error("args is not of type table",2)
  end

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
  objective.onObjectiveEndCallbacks = MDM_List:new()
  objective.onObjectiveStartCallbacks = MDM_List:new()
  objective.onUpdateCallbacks = MDM_List:new()
  objective.flagFailed = false

  if args.onObjectiveStart then objective:OnObjectiveStart(args.onObjectiveStart) end
  if args.onObjectiveEnd then objective:OnObjectiveEnd(args.onObjectiveEnd) end
  if args.onUpdate then objective:OnUpdate(args.onUpdate) end

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

function MDM_Objective.Start(self)
  if self.running then
    return
  end

  self.running = true

  if game then
    if self.title then
      game.hud:UpdateSimpleObjective(self.title, "param 2", true, true, "param 3")
    end
  end

  if self:GetIntroText() and game then
    game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "", self:GetIntroText())
  end

  for _,callback in ipairs(self.onObjectiveStartCallbacks) do
    callback(self)
  end
end

function MDM_Objective.OnObjectiveStop(self,callback)
  self:OnObjectiveEnd(callback)
end

function MDM_Objective.OnObjectiveEnd(self,callback)
  if not callback or type(callback) ~= "function" then
    error("callback not set or not of type table")
  end

  table.insert(self.onObjectiveEndCallbacks,callback)
end

function MDM_Objective.OnObjectiveStart(self,callback)
  table.insert(self.onObjectiveStartCallbacks,callback)
end

function MDM_Objective.Update(self)
  if self.running == false then
    return
  end

  self.onUpdateCallbacks:ForEach(function(callback) callback(self) end)
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
    HUD_RemoveQuestObjective(self.title)
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
