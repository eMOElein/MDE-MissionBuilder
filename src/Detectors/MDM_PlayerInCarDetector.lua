MDM_PlayerInCarDetector = {}
MDM_PlayerInCarDetector = MDM_Detector:new()

local args = {
  car = nil
}

function MDM_PlayerInCarDetector:new (args)
  local detector =  {}
  setmetatable(detector, self)
  self.__index = self

  if args.car and type(args.car) ~= "table" then
    error("car must be of type table",2)
  end

  detector.args = args
  detector.car = args.car or nil
  return detector
end

function MDM_PlayerInCarDetector.Test(self)
  if self.car then
    return self.car:IsPlayerInCar()
  else
    return MDM_VehicleUtils.GetPlayerCurrentVehicle() ~= nil
  end
end

function MDM_PlayerInCarDetector.UnitTest()

end
