MDM_MapCircle = {}

function MDM_MapCircle:new (vector,radius,color)
  local circle =  {}
  setmetatable(circle, self)
  self.__index = self

  circle.vector = vector
  circle.radius = radius
  circle.color = color
  circle.showing = false
  return circle
end

function MDM_MapCircle.UpdateVector(self, vector)
  self.vector = vector
  if not self.showing then
    MDM_MapCircle.Hide(self)
    MDM_MapCircle.Show(self)
  end
end

function MDM_MapCircle.IsShowing(self)
  return self.showing
end

function MDM_MapCircle.Show(self)
  if not self.showing then
    if game then
      self.circleEntity = game.navigation:RegisterCircle(self.vector.x, self.vector.y, self.radius, "", "", self.color, true)
    end
    self.showing = true
  end
end

function MDM_MapCircle.Hide(self)
  if self.showing then
    if game then
      HUD_UnregisterIcon(self.circleEntity)
      self.circleEntity = nil
    end
    self.showing = false
  end
end

function MDM_MapCircle.UnitTest()
  local  circle = MDM_MapCircle:new (MDM_Utils.GetVector(0,0,0),15,10)
  circle:Show()

  if not circle:IsShowing() then
    error("map circle should be showing",1)
  end

  circle:Hide()

  if circle:IsShowing() then
    error("map circle should not be showing",1)
  end
end
