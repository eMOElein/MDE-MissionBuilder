MDM_MockObjective = {}
MDM_MockObjective = MDM_Objective:class()

local args = {
  ttl = 1
}

function MDM_MockObjective:new (args)
  if not args.mission then
    error("mission not set",2)
  end

  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  objective.ttl = args.ttl or 1
  return objective
end

function MDM_MockObjective.Update(self)
  MDM_Objective.Update(self)
  self.ttl  = self.ttl -1
  if(self.ttl <= 0) then
    self:Succeed()
  end
end
