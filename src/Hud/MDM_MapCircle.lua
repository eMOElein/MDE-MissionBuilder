-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
