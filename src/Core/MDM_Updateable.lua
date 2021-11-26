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

-- An Updateable must contain the following methods:
-- Update() which gets called whenever the updateable should update it's status
-- OnUpdate(callback) which receives a callback method that gets's called whenever the Update() method is called.

MDM_Updateable = {}

function MDM_Updateable:new ()
  local updateable = {}
  setmetatable(updateable, self)
  self.__index = self

  updateable.OnUpdateCallbacks = {}
  return updateable
end

function MDM_Updateable.Update(self)
  self:FireOnUpdate()
end

function MDM_Updateable.FireOnUpdate(self)
  MDM_Utils.ForEach(self.OnUpdateCallbacks,function(callback) callback() end)
end

function MDM_Updateable.OnUpdate(self,callback)
  table.insert(self.OnUpdateCallbacks,callback)
end


function MDM_Updateable.UnitTest()
  print("---------------MDM_Updateable: Unit Test")
  local mission = MDM_Mission:new({title = ""});
  local counter = 0;

  mission:AddObjective(MDM_RestorePlayerObjective:new(mission))
  mission:Start(self)
  mission:OnUpdate(function() counter = counter + 1 end)
  mission:Update();
  mission:Update();

  if counter ~= 2 then
    error("onUpdate not called correctly")
  end
end
