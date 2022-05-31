MDM_Area = {

  }

function MDM_Area.ForSphere(config)
  if not config.position then
    error("position not set",2)
  end

  if not(config.radius) then
    error("radius not set",2)
  end

  local area = MDM_SphereArea:_new(config) -- MDM_SphereArea:_new(config)
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

  self.enabled = true
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

function MDM_Area.UnitTest()

  local area = MDM_Area.ForSphere({
    position = MDM_Vector:new(0,0,0),
    radius = 10
  })

  local pos = MDM_Vector:new(5,0,0)

  if not area:IsInside(pos) then
    error("IsInside should have been true")
  end

  area:Show()

  pos = MDM_Vector:new(30,0,0)
  if area:IsInside(pos) then
    error("IsInside should have been false")
  end

  area:Hide()

  pos = MDM_Vector:new(5,0,0)
  if not area:IsInside(pos) then
    error("IsInside should have been true")
  end


end
