MDM_DetectorDirector = {}
MDM_DetectorDirector = MDM_Director:class()

local arguments = {
  detector = nil,
  callback = nil
}

function MDM_DetectorDirector:new (args)
  if not args.detector then
    error("detector not set",2)
  end

  if not args.callback then
    error("callback not set",2)
  end

  if type(args.callback) ~= "function" then
    error("provided callback is no function",2)
  end

  local director = MDM_Director:new(args)
  setmetatable(director, self)
  self.__index = self

  director.detector = args.detector
  director.callback = args.callback
  return director
end

function MDM_DetectorDirector.Update(self)
  MDM_Director.Update(self)

  if not self:IsEnabled() then
    return
  end

  if(self.detector:Test()) then
    self.callback()
  end
end
