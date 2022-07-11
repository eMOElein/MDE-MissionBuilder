MDM_Area = {

  }

function MDM_Area.ForSphere(config)
  if not config.position then
    error("position not set",2)
  end

  if not(config.radius) then
    error("radius not set",2)
  end

  local area = MDM_SphereArea:new(config)

  return area
end

function MDM_Area:_new (config)
  local area = {}
  setmetatable(area, self)
  self.__index = self

  if not config.position then
    error("position not set",2)
  end

  area.position = config.position
  return area
end

function MDM_Area.Show(self)
  if self:IsShowing() then
    return
  end

  self.showing = true
end

function MDM_Area.IsShowing(self)
  return self.showing
end

function MDM_Area.Hide(self)
  if not self:IsShowing() then
    return
  end

  self.showing = false
end

function MDM_Area.IsInside(self, vector)
  return false
end
