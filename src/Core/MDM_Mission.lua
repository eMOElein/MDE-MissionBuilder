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

MDM_Mission = {}
MDM_Mission = MDM_Updateable:new()

local args = {
  introText = nil,
  initialOutfit = nil,
  initialWeather = nil,
  initialSeason = nil,
  outroText = nil,
  startPosition = nil,
  title = "New Mission",
}

function MDM_Mission:new (args)
  local mission = MDM_Updateable:new()
  setmetatable(mission, self)
  self.__index = self

  if not args then
    error("args not set",2)
  end

  if not args.title then
    error("title not set" ,2)
  end

  mission.args = args
  mission.objectives = {}
  mission.directors = {}
  mission.OnActiveObjectiveChangedCallbacks = {}
  mission.OnMissionEndCallbacks = {}
  mission.OnMissionStartCallbacks = {}
  mission.running = false
  mission.currentObjective = 0
  mission.description = ""
  mission.Outcome = 0
  mission.failText = "Mission Failed"
  mission.failDescription = nil
  mission.flagFailed = false
  mission.introductionShown = false
  mission.titleBanner = MDM_Banner:new(mission:GetTitle())
  mission.missionCompleteBanner = MDM_Banner:new("Mission Passed!")
  mission.assets = {}
  return mission
end

function MDM_Mission.AddAsset(self, spawnable_asset)
  table.insert(self.assets,spawnable_asset)
end

function MDM_Mission.AddAssets(self, spawnable_assets)
  if not spawnable_assets then
    error("assets value is nil",2)
  end

  for _,a in ipairs(spawnable_assets) do
    self:AddAsset(a)
  end
end

function MDM_Mission.AddDirector(self,director)
  table.insert(self.directors,director)
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
  self.args.initialOutfit = outfitId
end

function MDM_Mission.GetInitialOutfit(self)
  return self.args.initialOutfit
end

function MDM_Mission.GetIntroText(self)
  return self.args.introText
end

function MDM_Mission.GetStartPos(self)
  return self.args.startPosition
end

function MDM_Mission.SetStartPos(self, startPos)
  self.args.startPosition = startPos
end

function MDM_Mission.SetIntroText(self,introText)
  self.args.introText = introText
end

function MDM_Mission.SetOutcome(self,outcome)
  self.outcome = outcome
end

function MDM_Mission.SetStartPos(self,pos)
  self.args.startPosition = pos
end

function MDM_Mission.GetTitle(self)
  return self.args.title
end

function MDM_Mission.SetTitle(self,title)
  self.args.title = title
end

function MDM_Mission.OnMissionEnd(self, callback)
  table.insert(self.OnMissionEndCallbacks,callback)
end

function MDM_Mission.IsRunning(self)
  return self.running
end

function MDM_Mission.GetInitialSeason(self,seasonNumber)
  return self.args.initialSeason
end

function MDM_Mission.SetInitialSeason(self,seasonNumber)
  self.args.initialSeason = seasonNumber
end

function MDM_Mission.GetInitialWeather(self,weatherId)
  return self.args.initialWeather
end

function MDM_Mission.SetInitialWeather(self,weatherId)
  self.args.initialWeather = weatherId
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
    self.titleBanner.time = 2000
    self.titleBanner:Show()
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
  return self.args.outroText
end

function MDM_Mission.SetOutroText(self,outroText)
  self.args.outroText = outroText
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

  if not self.flagFailed then
    for _,callback in ipairs(self.OnMissionEndCallbacks) do
      callback()
    end
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


  MDM_Utils.DespawnAll(self.assets,50)
  for _,a in ipairs(self.assets) do
    if self.flagFailed then
      a:Despawn()
    else
      MDM_SpawnManager.MarkForRadiusDespawn(a,50)
    end
  end
end

function MDM_Mission.Succeed(self)
  self.flagFailed = false
  self:Stop()
end

function MDM_Mission.UpdateDirectors(self)
  if not self.directors then
    error ("directors not set",2)
  end

  for _,d in ipairs(self.directors) do
    d:Update()
  end
end

function MDM_Mission.Update(self)
  if not self.running then
    return
  end

  self:UpdateDirectors()
  local cObj = MDM_Mission.GetCurrentObjective(self)
  local nextObj = MDM_Mission.GetNextObjective(self)

  MDM_Updateable.Update(self)

  if not cObj then
    cObj  = MDM_Mission.GetNextObjective(self)
    if cObj then --First Objective
      cObj:Start()
      self.currentObjective = self.currentObjective +1
      return
    end
  end

  if cObj:GetOutcome() < 0 then
    self:Fail()
    return
  end

  -- Last Objective
  if cObj:GetOutcome() ~= 0 and not nextObj then
    cObj:Stop()
    self:Stop()
  end

  -- Next Objective
  if cObj:GetOutcome() ~= 0 and nextObj then
    cObj:Stop()


    nextObj:Start()
    self.currentObjective = self.currentObjective +1
    return
  end

  cObj:Update()
end

function MDM_Mission.UnitTest()
  print("---------------MDM_Mission Unit Test")
  local  m = MDM_Mission:new({title = "Missiontest"})

  local  o1 = MDM_MockObjective:new({mission = m})
  MDM_Objective.SetInformation(o1,"M1","","")
  local  o2 = MDM_MockObjective:new({mission = m})
  MDM_Objective.SetInformation(o2,"M2","","")

  m:AddObjective(o1)
  m:AddObjective(o2)

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
end
