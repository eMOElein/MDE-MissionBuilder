MDM_KillTargetsObjective = {}

function MDM_KillTargetsObjective:new (args)
  local objective = MDM_Objective:new(args)

  if args.targets == nil then
    error("targets not set",2)
  end

  if #args.targets < 1 then
    error("targets is empty",2)
  end

  objective.targets = MDM_List:new(args.targets)
  objective:OnObjectiveStart(MDM_KillTargetsObjective._OnObjectiveStart)
  objective:OnObjectiveEnd(MDM_KillTargetsObjective._OnObjectiveEnd)
  objective:OnUpdate(MDM_KillTargetsObjective._OnUpdate)

  return objective
end

function MDM_KillTargetsObjective._OnObjectiveStart(self)
  self.blip = MDM_Blip.ForVector({vector = self.targets[1]:GetPos()})
  self.blip:Show()

  MDM_Utils.SpawnAll(self.targets)

  if not self.targetBlips then
    self.targetBlips = MDM_List:new()
  end

  for _,t in ipairs(self.targets) do
    local  targetBlip = MDM_Blip.ForNPC({npc = t})
    self.targetBlips:Add(targetBlip)
  end
end

function MDM_KillTargetsObjective._TargetsDead(self)
  for _,t in ipairs(self.targets) do
    if not t:IsDead() then
      return false
    end
  end

  return true
end

function MDM_KillTargetsObjective._OnUpdate(self)
  if not MDM_KillTargetsObjective._TargetsDead(self) then
    return
  end

  self:Succeed()
end

function MDM_KillTargetsObjective._OnObjectiveEnd(self)
  if self.blip then
    self.blip:Hide()
  end

  if self.targetBlips then
    self.targetBlips:ForEach(function(blip) blip:Hide() end)
  end
end

function MDM_KillTargetsObjective.UnitTest()
  local npc1 = MDM_NPC:new({npcId="13604348442857333985",position=MDM_Utils.GetVector(-907.94,-180.41,2),direction=MDM_Utils.GetVector(0,0,0)})
  local npc2 = MDM_NPC:new({npcId="13604348442857333985",position=MDM_Utils.GetVector(-907.94,-180.41,2),direction=MDM_Utils.GetVector(0,0,0)})
  local npc3 = MDM_NPC:new({npcId="13604348442857333985",position=MDM_Utils.GetVector(-907.94,-180.41,2),direction=MDM_Utils.GetVector(0,0,0)})

  local m = MDM_Mission:new({title = "TEST: Kill Targets"})
  local killTargetsObjective = MDM_KillTargetsObjective:new({mission = m, targets = {npc1,npc2,npc3}})
  m:AddObjective(killTargetsObjective)

  m:Start()
  m:Update()
  m:Update()
  m:Update()
  m:Update()

  npc1:SetHealth(0)
  npc2:SetHealth(0)
  m:Update()
  if killTargetsObjective:GetOutcome() ~= 0 then
    error("outcome 0 expected but was: " ..killTargetsObjective:GetOutcome(),1)
  end

  npc3:SetHealth(0)
  m:Update()
  if killTargetsObjective:GetOutcome() ~= 1 then
    error("outcome 1 expected but was: " ..killTargetsObjective:GetOutcome(),1)
  end
end
