MDM_LeaveAreaObjective = {}


function MDM_LeaveAreaObjective:new(config)
  if not config.area then
    error("area not set",2)
  end

  local objective = MDM_Objective:new(config)

  objective.area = config.area
  objective:OnUpdate(MDM_LeaveAreaObjective._OnUpdate)

  return objective
end

function MDM_LeaveAreaObjective._OnUpdate(self)
  if not MDM_Utils.Player.IsInArea(self.area) then
    self:Succeed()
  end
end
