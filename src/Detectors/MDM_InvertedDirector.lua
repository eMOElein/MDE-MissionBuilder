--- MDM_InvertedDetector
-- A detector that inverts the result of the given detector
--
-- @param detector the detector that should be inverted
MDM_InvertedDirector = {}
MDM_InvertedDirector = MDM_Detector:new()

function MDM_InvertedDirector:new (args)
  local invertedDetector =  {}
  setmetatable(invertedDetector, self)
  self.__index = self

  invertedDetector.detector = args.detector
  return invertedDetector
end

function MDM_InvertedDirector.Test(self)
  return not self.detector:Test()
end
