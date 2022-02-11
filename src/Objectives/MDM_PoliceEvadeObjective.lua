MDM_PoliceEvadeObjective = MDM_Objective:class()

local args = {
  initialLevel = 1
}
function MDM_PoliceEvadeObjective:new (args)
  if not args.initialLevel then
    error("initial level not set",2)
  end

  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self
  objective.title = args.title or "Evade the police"
  objective.task = args.task or "Evade the police"
  objective.description = args.description or "Evade the police"
  objective.initLevel = args.initialLevel
  return objective
end

function MDM_PoliceEvadeObjective.SetInitialWantedLevel(self,level)
  self.initLevel = level
end

function MDM_PoliceEvadeObjective.Update(self)
  if not self.running then
    return
  end

  if not MDM_PoliceUtils.IsPlayerHunted() then
    MDM_Objective.SetOutcome(self,1)
  else
  end

  MDM_Objective.Update(self)
end

function MDM_PoliceEvadeObjective.Start(self)
  if self.initLevel > 0 then
    MDM_PoliceUtils.SetWantedLevel(self.initLevel)
  end
  MDM_Objective.Start(self)
end
