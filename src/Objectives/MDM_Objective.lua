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

MDM_Objective = {}

local arguments = {
  description = "",
  introText = nil,
  outroText = nil,
  task = "",
  title = "New Objective",
  onObjectiveStart = nil,
  onObjectiveEnd = nil
}
function MDM_Objective:class()
  local objective =  {}
  setmetatable(objective, self)
  self.__index = self

  return objective
end

function MDM_Objective:new(args)
  local objective =  MDM_Objective:class()
  setmetatable(objective, self)
  self.__index = self

  -- args consinstency checks
  if not args then error("args not set",2) end
  if type(args) ~= "table" then error("args is not of type table",2) end

  -- initializations
  args.title = args.title or arguments.title
  args.task = args.task or arguments.task
  args.description = args.description or arguments.description

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

function MDM_Objective.OnUpdate(self,callbacks)
  MDM_Utils.AddAll(self.onUpdateCallbacks,callbacks)
end

local function AddQuest(self)
  HUD_AddQuestObjective(self:GetTitle())
  game.hud:UpdateSimpleObjective(self:GetTask(), self:GetDescription(), false, false, self:GetTitle())
end

function MDM_Objective.GetDescription(self)
  return self.args.description
end

function MDM_Objective.GetTask(self)
  return self.args.task
end

function MDM_Objective.GetTitle(self)
  return self.args.title
end

function MDM_Objective.SetDescription(self,description)
  self.args.description = description
end

function MDM_Objective.SetTask(self,task)
  self.args.task = task
end

function MDM_Objective.SetTitle(self,title)
  self.args.title = title
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
    game.hud:UpdateSimpleObjective(self:GetTitle(), "simpleobjective param2", true, true, self:GetTitle())
  end

  if self:GetIntroText() and game then
    game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "", self:GetIntroText())
  end

  MDM_Utils.ForEach(self.onObjectiveStartCallbacks,function(callback) callback(self) end)
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
  return self.args.introText
end

function MDM_Objective.GetOutroText(self)
  return self.args.outroText
end

function MDM_Objective.SetIntroText(self, introText)
  self.args.introText = introText
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
  MDM_Utils.ForEach(self.onObjectiveEndCallbacks,function(callback) callback(self) end)

  if self:GetOutcome() > 0 and self:GetOutroText() and game then
    game.hud:SendMessageMovie("HUD", "OnShowFreerideBanner", "", self:GetOutroText())
  end

end

function MDM_Objective.Succeed(self)
  self:SetOutcome(1)
end

function MDM_Objective.SetInformation(self,title, task, description)
  if not title then
    error("title not set",2)
  end

  if not task then
    task = title
  end

  if not description then
    description = task
  end

  self:SetTitle(title)
  self:SetDescription(description)
  self:SetTask(task)
end

function MDM_Objective.UnitTest()
  print("---------------MDM_Objective UnitTest")
  local cnt = 0
  local m = MDM_Mission:new({title = "test"})
  local o1 = MDM_MockObjective:new({mission = m, ttl = 1})
  m:AddObjective(o1)

  local o2 = MDM_MockObjective:new({mission = m, ttl = 1})
  o2:OnObjectiveStart(function() cnt = cnt+1 end)
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
