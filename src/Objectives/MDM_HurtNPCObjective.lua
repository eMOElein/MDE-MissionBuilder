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

MDM_HurtNPCObjective = {}
MDM_HurtNPCObjective = MDM_Objective:class()

local args = {
  npc = nil,
  threshold = 50,
  onThreshold = function () end
}

function MDM_HurtNPCObjective:new(args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if not args.npc then
    error("npc not set",2)
  end

  if not args.threshold then
    error("threshold not set",2)
  end

  objective.npc = args.npc
  objective.threshold = args.threshold
  objective.blip = MDM_ObjectivePosition:new(objective:GetTitle(),objective.npc:GetPos())
  objective.onThresholdCallbacks = {}
  if args.onThreshold then objective:OnThreshold(args.onThreshold) end
  return objective
end

function MDM_HurtNPCObjective.OnThreshold(self,callback)
  table.insert(self.onThresholdCallbacks,callback)
end


function MDM_HurtNPCObjective.OnThreshold(self)
  self.npc:GetGameEntity():SwitchBrain(enums.AI_TYPE.CIVILIAN)
  self:SetOutcome(1)
end

function MDM_HurtNPCObjective.Update(self)
  if not self:IsRunning() then
    return
  end

  if self.npc:GetHealth() <= self.threshold then
    self:SetOutcome(1)
  end

end

function MDM_HurtNPCObjective.Start(self)
  --  self.hurtDirector:Enable()
  self.blip:Show()
  MDM_Objective.Start(self)
end

function MDM_HurtNPCObjective.Stop(self)
  --  self.hurtDirector:Disable()
  print("Stop")
  self.blip:Hide()
  MDM_Objective.Stop(self)
end

function MDM_HurtNPCObjective.UnitTest()
  print("---------------MDM_HurtNPCObjective UnitTest")
  
  local npc = MDM_NPC:new("12345",MDM_Utils.GetVector(1,2,3),MDM_Utils.GetVector(4,5,6))

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
  print("OK")
end
