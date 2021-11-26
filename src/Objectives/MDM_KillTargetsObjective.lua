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

MDM_KillTargetsObjective = {} -- Unneccessary but IDE needs it to isplay Methods
MDM_KillTargetsObjective = MDM_Objective:class()

local args = {
  targets = nil
}
function MDM_KillTargetsObjective:new (args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  objective.targets = args.targets

  objective._targetsDeadDetector = MDM_TargetsDeadDetector:new({targets = args.targets,onTargetsDead = function() MDM_Objective.SetOutcome(objective,1) end})

  objective.blip = MDM_ObjectivePosition:new(objective:GetTitle() ..":TestMDM_ObjectivePosition",objective.targets[1]:GetPos())
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
  self._targetsDeadDetector:Test()
  MDM_Objective.Update(self)
end

function MDM_KillTargetsObjective.Stop(self)
  self.blip:Hide()
  MDM_Objective.Stop(self)
end

function MDM_KillTargetsObjective.UnitTest()
  print("---------------KillTargetsObjective:UnitTest")
  local npc1 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-907.94,-180.41,2),MDM_Utils.GetVector(0,0,0))
  local npc2 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-907.94,-182.41,2),MDM_Utils.GetVector(0,0,0))
  local npc3 = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-907.94,-184.41,2),MDM_Utils.GetVector(0,0,0))

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
