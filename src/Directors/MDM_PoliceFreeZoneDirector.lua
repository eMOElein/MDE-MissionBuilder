MDM_PoliceFreeZoneDirector = {}
MDM_PoliceFreeZoneDirector = MDM_Director:class()

local arguments = {
  position = nil,
  radius = nil,
  showArea = false
}
--- MDM_PoliceFreeZoneDirector
-- Creates an area around a point in which the police is disabled when the player enters it.
-- Police is enabled again when the player leaves the area.
--
function MDM_PoliceFreeZoneDirector:new (args)
  local director = MDM_Director:new(args)
  setmetatable(director, self)
  self.__index = self

  if not args.position then
    error("position not set",2)
  end

  if not args.radius then
    error("radius not set",2)
  end

  director.args = args
  director.area = MDM_Area.ForSphere({
    position = args.position,
    radius = args.radius
  })
  director.showArea = false

  if args.showArea ~= nil then
    director.showArea = args.showArea
  end

  return director
end

function MDM_PoliceFreeZoneDirector.Update(self)
  if not self:IsEnabled() then
    return
  end

  --entered area
  local isInArea =  MDM_Utils.Player.IsInArea(self.area)
  if isInArea and not self.previousInArea then
    MDM_PoliceUtils.DisablePolice()
  end

  --left area
  if not isInArea and self.previousInArea then
    MDM_PoliceUtils.EnablePolice()
  end

  self.previousInArea = isInArea

  MDM_Director.Update(self)
end

function MDM_PoliceFreeZoneDirector.Enable(self)
  self:ShowArea(self.args.showArea)
  MDM_Director.Enable(self)
end

function MDM_PoliceFreeZoneDirector.Disable(self)
  self:ShowArea(false)
  self.previousInArea = false
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
