--- MDM_InvertedDetector
-- A detector that returns the inverted result of the given detector
--
-- @param detector the detector that should be inverted
MDM_InvertedDetector = {}
MDM_InvertedDirector = MDM_Detector:new()

function MDM_InvertedDetector:new (args)
  local invertedDetector =  {}
  setmetatable(invertedDetector, self)
  self.__index = self

  invertedDetector.detector = args.detector
  return invertedDetector
end

function MDM_InvertedDetector.Test(self)
  return not self.detector:Test()
end
