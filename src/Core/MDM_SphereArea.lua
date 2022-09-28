MDM_SphereArea = {}

function MDM_SphereArea:new(config)
  if not config.radius then
    error("radius not set",2)
  end

  if type(config.radius) ~= "number" then
    error("radius must be of type number",2)
  end

  if not config.position then
    error("position not set",2)
  end

  local area = MDM_Area:_new(config)

  area.position = config.position
  area.radius = config.radius
  area.color = config.color or 4
  area.SetPosition = MDM_SphereArea.SetPosition

  area.IsInside = MDM_SphereArea._IsInside
  area.Show = MDM_SphereArea._Show
  area.Hide = MDM_SphereArea._Hide

  return area
end

function MDM_SphereArea.SetPosition(self,position)
  self.position = position
end
function MDM_SphereArea._Hide(self)
  MDM_Area.Hide(self)

  if self.circleEntity then
    if game then
      HUD_UnregisterIcon(self.circleEntity)
    end
    self.circleEntity = nil
  end

  return self
end

function MDM_SphereArea._IsInside(self,other)
  return self.radius >= MDM_Vector.DistanceToPoint(self.position,other)
end

function MDM_SphereArea._Show(self)
  MDM_Area.Show(self)

  if not self.circleEntity then
    if game then
      self.circleEntity = game.navigation:RegisterCircle(self.position.x, self.position.y, self.radius, "", "", self.color, true)
    else
      self.circleEntity = {}
    end
  end

  return self
end
