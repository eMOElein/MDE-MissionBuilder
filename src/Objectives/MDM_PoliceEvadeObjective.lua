MDM_PoliceEvadeObjective = {}

local args = {
  initialLevel = 1
}
function MDM_PoliceEvadeObjective:new (args)
  if not args.initialLevel then
    error("initial level not set",2)
  end

  local objective = MDM_Objective:new(args)
  objective.title = args.title or "Evade the police"
  objective.task = args.task or "Evade the police"
  objective.description = args.description or "Evade the police"
  objective.initLevel = args.initialLevel

  objective:OnObjectiveStart(MDM_PoliceEvadeObjective._OnObjectiveStart)
  objective:OnUpdate(MDM_PoliceEvadeObjective._OnUpdate)
  return objective
end

function MDM_PoliceEvadeObjective.SetInitialWantedLevel(self,level)
  self.initLevel = level
end

function MDM_PoliceEvadeObjective._OnUpdate(self)
  if not MDM_PoliceUtils.IsPlayerHunted() then
    MDM_Objective.SetOutcome(self,1)
  else
  end
end

function MDM_PoliceEvadeObjective._OnObjectiveStart(self)
  if self.initLevel > 0 then
    MDM_PoliceUtils.SetWantedLevel(self.initLevel)
  end
end
