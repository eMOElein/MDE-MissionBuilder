-----------------------------------
-- DEPRECATED DO NOT USE !!! ------
-----------------------------------
MDM_HurtNPCObjective = {}

function MDM_HurtNPCObjective:new(args)
  local objective = MDM_Objective:new(args)

  if not args.npc then
    error("npc not set",2)
  end

  if not args.threshold then
    error("threshold not set",2)
  end

  objective.npc = args.npc
  objective.threshold = args.threshold
  objective.onThresholdCallbacks = {}

  objective:OnObjectiveStart(MDM_HurtNPCObjective._OnObjectiveStart)
  objective:OnObjectiveEnd(MDM_HurtNPCObjective._OnObjectiveEnd)
  objective:OnUpdate(MDM_HurtNPCObjective._OnUpdate)

  return objective
end

function MDM_HurtNPCObjective.OnThreshold(self)

end

function MDM_HurtNPCObjective._OnUpdate(self)
  if self.npc:GetHealth() <= self.threshold then
    self:Succeed()
  end
end

function MDM_HurtNPCObjective._OnObjectiveStart(self)
  if not self.blip then
    self.blip = MDM_Blip.ForNPC({npc=self.npc})
  end

  self.blip:Show()
end

function MDM_HurtNPCObjective._OnObjectiveEnd(self)
  self.blip:Hide()
end

function MDM_HurtNPCObjective.UnitTest()
  local npc = MDM_NPC:new({npcId="12345",position=MDM_Utils.GetVector(1,2,3),direction=MDM_Utils.GetVector(4,5,6)})

  local mission = MDM_Mission:new({title = "test"})
  local objective = MDM_HurtNPCObjective:new({mission = mission, npc = npc, threshold = 70})
  mission:AddObjective(objective)

  mission:Start()
  mission:Update()
  npc:SetHealth(80)
  mission:Update()

  if objective:GetOutcome() ~= 0 then
    error("outcome 0 expected but was: " ..objective:GetOutcome(),1)
  end

  npc:SetHealth(60)
  mission:Update()

  if objective:GetOutcome() ~= 1 then
    error("outcome 1 expected but was: " ..objective:GetOutcome(),1)
  end
end
