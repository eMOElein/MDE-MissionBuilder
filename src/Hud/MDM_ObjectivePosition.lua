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

MDM_ObjectivePosition = {}

function MDM_ObjectivePosition:new (title, pos,radius,color)
  local blip = {}
  setmetatable(blip, self)
  self.__index = self

  if not pos then
    error("pos not set",2)
  end

  if not title then
    error("title not set",2)
  end

  self.radius = radius or 20
  self.color = color or 4
  blip.title = title
  blip.pos = pos
  blip.mapCircle = MDM_MapCircle:new(blip.pos ,blip.radius,blip.color)

  return blip
end

function MDM_ObjectivePosition:AddToMap()
  MDM_ObjectivePosition.show(self)
end

function MDM_ObjectivePosition:GetPos()
  return self.pos
end

function MDM_ObjectivePosition.Show(self)
  MDM_ObjectivePosition.show(self)
end

function MDM_ObjectivePosition.show(self)
  if self.onMap then
    return
  end

  local AreaRadius = 20

  if game then
    self.objectiveMDM_ObjectivePosition = game.navigation:RegisterObjectivePos(self.pos, "BLIPSTRING1", "BLIPSTRING2", true)
    self.mapCircle:Show()
  end

  self.onMap = true
end

function MDM_ObjectivePosition.Hide(self)
  if self.mapCircle then
    self.mapCircle:Hide()
  end
  if not self.onMap then
    return
  end

  if self.objectiveMDM_ObjectivePosition  then
    HUD_UnregisterIcon(self.objectiveMDM_ObjectivePosition)
    self.objectiveMDM_ObjectivePosition = nil
  end

  if self.objectiveArea then
    self.objectiveArea = nil
  end

  self.onMap = false
end

function MDM_ObjectivePosition:RemoveFromMap()
  MDM_ObjectivePosition.Hide(self)
end
