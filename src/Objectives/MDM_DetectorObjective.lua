MDM_DetectorObjective = {}
MDM_DetectorObjective = MDM_Objective:class()

function MDM_DetectorObjective:new (args)
  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  if args.detector == nil then
    error("detector not set",2)
  end

  objective.detector = args.detector

  return objective
end

function MDM_DetectorObjective.Update(self)
  MDM_Objective.Update(self)
  if not self.running then
    return
  end

  if self.detector:Test() then
    self:Succeed()
  end
end

function MDM_DetectorObjective.UnitTest()
  local detector = MDM_Detector:new({})
  detector.Test = function() return false end

  local mission = MDM_Mission:new({})
  local detectorObjective = MDM_DetectorObjective:new({mission = mission, detector = detector})
  detectorObjective:Start()

  detectorObjective:Update()
  if detectorObjective:GetOutcome() ~= 0 then
    error("outcome should be 0 but was "..detectorObjective:GetOutcome(),2)
  end

  detector.Test = function() return true end
  detectorObjective:Update()
  if detectorObjective:GetOutcome() ~= 1 then
    error("outcome should be 1 but was "..detectorObjective:GetOutcome(),2)
  end
end
