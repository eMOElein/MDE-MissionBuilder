MDM_RestorePlayerObjective = {}
MDM_RestorePlayerObjective = MDM_Objective:class()

function MDM_RestorePlayerObjective:new ()
  local objective = MDM_Objective:new({})
  setmetatable(objective, self)
  self.__index = self

  return objective
end

function MDM_RestorePlayerObjective.Update(self)
  if not self:IsRunning() then
    return
  end

  MDM_PlayerUtils.RestorePlayer()
  self:Succeed()
  MDM_Objective.Update(self)
end
