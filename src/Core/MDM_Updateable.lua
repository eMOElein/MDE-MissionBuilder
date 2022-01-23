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
