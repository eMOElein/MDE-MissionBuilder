MDM_KillTargetsObjective = {} -- Unneccessary but IDE needs it to isplay Methods
MDM_KillTargetsObjective = MDM_Objective:class()

local args = {
  targets = nil
}
function MDM_KillTargetsObjective:new (args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if args.targets == nil then
    error("targets not set",2)
  end

  if #args.targets < 1 then
    error("targets is empty",2)
  end

  objective.targets = args.targets
  objective.targetsDeadDetector = MDM_TargetsDeadDetector:new({targets = args.targets,onTargetsDead = function()  end})

  objective.blip = MDM_ObjectivePosition:new(objective:GetTitle() ..":TestMDM_ObjectivePosition",args.targets[1]:GetPos())
  return objective
end

function MDM_KillTargetsObjective.Start(self)
  MDM_Objective.Start(self)
  self.blip:Show()

  MDM_Utils.SpawnAll(self.targets)
end

function MDM_KillTargetsObjective.Update(self)
  if not self.running then
    return
  end


  MDM_Objective.Update(self)

  if self.targets == nil then
    error("targets nil")
  end

  if not self.indicator then
    for _,t in ipairs(self.targets) do
      if t:IsSpawned() then
        game.navigation:SetIconShowByEntity(t:GetGameEntity(), true)
        game.hud:AddEntityIndicator(t:GetGameEntity(), "objective_primary", Math:newVector(0,0,0))
        self.indicator = true
      end
    end
  end


  if self.targetsDeadDetector:Test() then
    MDM_Objective.Succeed(self)

    if self.indicator then
      for _,t in ipairs(self.targets) do
        if t:IsSpawned() then
          game.navigation:SetIconShowByEntity(t:GetGameEntity(), false)
          game.hud:RemoveEntityIndicator(t:GetGameEntity(), "objective_primary", Math:newVector(3,3,3))
          self.indicator = true
        end
      end
    end
  end
end

function MDM_KillTargetsObjective.Stop(self)
  self.blip:Hide()
  MDM_Objective.Stop(self)
end

function MDM_KillTargetsObjective.UnitTest()
  print("---------------KillTargetsObjective:UnitTest")
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
