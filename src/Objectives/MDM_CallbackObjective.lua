--- Exexutes a given callback on each update cycle and succeeds the objective if the callback returns true.
MDM_CallbackObjective = {}

function MDM_CallbackObjective:new (args)
  local objective = MDM_Objective:new(args)

  if not args.callback then
    error("callback not set",2)
  end

  objective.callback = args.callback
  objective:OnUpdate(function() MDM_CallbackObjective._OnUpdate(objective) end)
  return objective
end

function MDM_CallbackObjective._OnUpdate(self)
  local result = self.callback()
  if result then
    self:Succeed()
  end
end
