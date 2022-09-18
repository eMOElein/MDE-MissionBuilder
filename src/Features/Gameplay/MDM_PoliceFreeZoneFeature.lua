MDM_PoliceFreeZoneFeature = {}
--- MDM_PoliceFreeZoneFeature
-- Creates an area around a point in which the police is disabled when the player enters it.
-- Police is enabled again when the player leaves the area or the feature is disabled.
--
function MDM_PoliceFreeZoneFeature:new (args)
  local director = MDM_Feature:new(args)

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

  director.ShowArea = MDM_PoliceFreeZoneFeature.ShowArea

  director:OnEnabled(MDM_PoliceFreeZoneFeature._OnEnabled)
  director:OnDisabled(MDM_PoliceFreeZoneFeature._OnDisabled)
  director:OnUpdate(MDM_PoliceFreeZoneFeature._OnUpdate)

  return director
end

function MDM_PoliceFreeZoneFeature._OnUpdate(self)
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
end

function MDM_PoliceFreeZoneFeature._OnEnabled(self)
  self:ShowArea(self.args.showArea)
end

function MDM_PoliceFreeZoneFeature._OnDisabled(self)
  self:ShowArea(false)
  self.previousInArea = false
  MDM_PoliceUtils.EnablePolice()
end

--- MDM_PoliceFreeZoneFeature.ShowArea
-- If set to true the area is shown on the map.
-- Good for debugging.
--
-- @param self
-- @param bool
function MDM_PoliceFreeZoneFeature.ShowArea(self,bool)
  if(bool) then
    self.area:Show()
  else
    self.area:Hide()
  end
end

function MDM_PoliceFreeZoneFeature.UnitTest()
  local mission = MDM_Mission:new({title = ""})
  local o1 = MDM_MockObjective:new({mission = mission, ttl = 1})
  mission:AddObjective(o1)

  local director = MDM_PoliceFreeZoneFeature:new({
    position = MDM_Utils.GetVector(0,0,0),
    radius = 50,
    showArea = true
  })

  MDM_FeatureUtils.EnableOnMissionStart(director,mission)
  MDM_FeatureUtils.DisableOnMissionEnd(director,mission)

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
