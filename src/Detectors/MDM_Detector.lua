MDM_Detector = {}

function MDM_Detector:class()
  local detector =  {}
  setmetatable(detector, self)
  self.__index = self
  return detector
end

function MDM_Detector:new (args)
  local detector =  MDM_Detector:class()
  detector.enabled = false
  detector.onEnabledCallbacks = {}
  detector.onDisabledCallbacks = {}
  detector.callbacks = {}


  if args~= nil and args.callback ~= nil then
    MDM_Detector.AddCallback(detector,args.callback)
  end

  return detector
end

function MDM_Detector.OnDisabled(self,callbacks)
  MDM_Utils.AddAll(self.onDisabledCallbacks,callbacks)
end

function MDM_Detector.OnEnabled(self,callbacks)
  MDM_Utils.AddAll(self.onEnabledCallbacks,callbacks)
end

function MDM_Detector.IsEnabled(self)
  return self.enabled
end

function MDM_Detector.Enable(self)
  self.enabled = true
  MDM_Utils.ForEach(self.onEnabledCallbacks,function(callback) callback(self) end)
end

function MDM_Detector.Test(self)
  return false
end

function MDM_Detector.AddCallback(self,callback)
  table.insert(self.callbacks,callback)
end

function MDM_Detector.NotifyCallbacks(self,args)
  args.detector = self

  for _,callback in ipairs(self.callbacks) do
    callback(args)
  end
end

function MDM_Detector.Disable(self)
  self.enabled = false
  MDM_Utils.ForEach(self.onDisabledCallbacks,function(callback) callback() end)
end

function MDM_Detector.Update(self)

end
