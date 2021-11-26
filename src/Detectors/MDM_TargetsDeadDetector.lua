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

MDM_TargetsDeadDetector = {}
MDM_TargetsDeadDetector = MDM_Detector:class()

function MDM_TargetsDeadDetector:new(args)
  local detector =  MDM_Detector:new()
  setmetatable(detector, self)
  self.__index = self

  detector.npcList = args.targets
  detector.onTargetsDeadCallbacks = {}
  detector:OnTargetsDead(args.onTargetsDead)
  return detector
end

function MDM_TargetsDeadDetector.Enable(self)
  self.enabled = true
end

function MDM_TargetsDeadDetector.OnTargetsDead(self, callback)
  table.insert(self.onTargetsDeadCallbacks,callback)
end

function MDM_TargetsDeadDetector.Test(self)
  local cnt = 0
  for index, npc in ipairs(self.npcList) do
    if npc:IsDead() then
      cnt = cnt +1
    end
  end

  if cnt == #self.npcList then
    MDM_Utils.ForEach(self.onTargetsDeadCallbacks,function(callback) callback() end)
  end

end

function MDM_TargetsDeadDetector.UnitTest()
  print("---------------MDM_TargetsDeadDetector UnitTest")

  local deadCounter = 0
  local npc1 = MDM_NPC:new("1234",{1,1,1},{1,1,1})
  local npc2 = MDM_NPC:new("1234",{1,1,1},{1,1,1})

  local detector = MDM_TargetsDeadDetector:new({targets = {npc1,npc2}, onTargetsDead = function () deadCounter = deadCounter +1 end})

  detector:Enable()

  if not detector:IsEnabled() then
    error("director should be enabled",1)
  end


  npc1:SetHealth(0)
  detector:Test()
  if deadCounter ~= 0 then
    error("expected value " ..0 .." but was " ..deadCounter,1)
  end

  npc2:SetHealth(0)
  detector:Test()
  if deadCounter ~= 1 then
    error("expected value " ..1 .." but was " ..deadCounter,1)
  end
end
