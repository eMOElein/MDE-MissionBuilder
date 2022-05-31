MDM_SphereArea = {

    _new = function(self,config)
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

      area.IsInside = function(self,other)
        return self.radius >= MDM_Vector.DistanceToPoint(self.position,other)
      end

      area.Show = function(self)
        MDM_Area.Show(self)

        if not self.circleEntity then
          if game then
            self.circleEntity = game.navigation:RegisterCircle(self.position.x, self.position.y, self.radius, "", "", self.color, true)
          else
            self.circleEntity = {}
          end
        end
      end

      area.Hide = function(self)
        MDM_Area.Hide(self)

        if self.circleEntity then
          if game then
            HUD_UnregisterIcon(self.circleEntity)
          end
          self.circleEntity = nil
        end
      end

      return area
    end
}

function MDM_SphereArea.UnitTest()
  local area = MDM_Area.ForSphere({
    position = MDM_Vector:new(0,0,0),
    radius = 5
  })

  local other = MDM_Vector:new(4,0,0)

  if not area:IsInside(other) then
    error("other should be insiede area")
  end

  other = MDM_Vector:new(6,0,0)

  if area:IsInside(other) then
    error("other should be outside area")
  end
end
