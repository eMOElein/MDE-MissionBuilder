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

MDM_PoliceFreeZoneDirector = {}
MDM_PoliceFreeZoneDirector = MDM_Director:class()

local arguments = {
  position = nil,
  radius = nil,
  showArea = false
}
--- MDM_PoliceFreeZoneDirector
-- Creates an area around a radius in which the police is disabled when the player enters it.
-- Police is enabled again when the player leaves the area.
--
-- @param mission WILL BE REMOVED WITH NEXT FEATURE RELEASE !!!!!!!!!
-- @param position the center position of the area
-- @param radius the radius of the area
function MDM_PoliceFreeZoneDirector:new (args)
  if not args.position then
    error("position not set",2)
  end

  if not args.radius then
    error("radius not set",2)
  end

  local director = MDM_Director:new(args)
  setmetatable(director, self)
  self.__index = self

  director.args = args
  director.detector = MDM_EntityInCircleDetector:new({entity = MDM_PlayerUtils.GetPlayer(),position = args.position, radius = args.radius})
  director.area = MDM_MapCircle:new (args.position,args.radius,1)
  director.showArea = false
  return director
end

function MDM_PoliceFreeZoneDirector.Update(self)
  if not self:IsEnabled() then
    return
  end

  self.detector:Test()

  if self.detector:HasEntered() then
    MDM_PoliceUtils.DisablePolice()
  end

  if self.detector:HasLeft() then
    MDM_PoliceUtils.EnablePolice()
  end

  MDM_Director.Update(self)
end

function MDM_PoliceFreeZoneDirector.Enable(self)
  self:ShowArea(self.args.showArea)
  MDM_Director.Enable(self)
end

function MDM_PoliceFreeZoneDirector.Disable(self)
  self:ShowArea(false)
  MDM_PoliceUtils.EnablePolice()
  MDM_Director.Disable(self)
end

--- MDM_PoliceFreeZoneDirector.ShowArea
-- If set to true the area is shown on the map.
-- Good for debugging.
--
-- @param self
-- @param bool
function MDM_PoliceFreeZoneDirector.ShowArea(self,bool)
  if(bool) then
    self.area:Show()
  else
    self.area:Hide()
  end
end

function MDM_PoliceFreeZoneDirector.UnitTest()
  local mission = MDM_Mission:new({title = ""})
  local o1 = MDM_MockObjective:new({mission = mission, ttl = 1})
  mission:AddObjective(o1)

  local director = MDM_PoliceFreeZoneDirector:new({
    position = MDM_Utils.GetVector(0,0,0),
    radius = 50,
    showArea = true
  })

  MDM_ActivatorUtils.EnableOnMissionStart(director,mission)
  MDM_ActivatorUtils.DisableOnMissionEnd(director,mission)

  if director.area:IsShowing() then
    error("area should not be showing",1)
  end

  mission:Start()

  if not director.area:IsShowing() then
    error("area should be showing",1)
  end

  mission:Stop()

  if director.area:IsShowing() then
    error("area should not be showing",1)
  end
end
