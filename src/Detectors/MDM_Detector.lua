MDM_Detector = {}

function MDM_Detector:class()
  local director =  {}
  setmetatable(director, self)
  self.__index = self
  return director
end

function MDM_Detector:new ()
  local director =  MDM_Detector:class()
  director.enabled = false
  director.onEnabledCallbacks = {}
  director.onDisabledCallbacks = {}
  
  return director
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

function MDM_Detector.Disable(self)
  self.enabled = false
  MDM_Utils.ForEach(self.onDisabledCallbacks,function(callback) callback() end)
end

function MDM_Detector.Update(self)

end
