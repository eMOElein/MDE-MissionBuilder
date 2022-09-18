--- MDM_PlayerInCarBannerFeature
-- Director that shows a banner when the player is not inside the monitored car.
MDM_PlayerInCarBannerFeature = {}

--- The constructor configuration table must contain the following fields.
-- @param mission an instance of MDM_Mission that this director is attached to.
-- @param car an instance of MDM_Car
function MDM_PlayerInCarBannerFeature:new (config)
  if not config.car then
    error("carEntity not set",2)
  end

  local director = MDM_Feature:new({mission = config.mission})

  director.carEntity = config.car
  director.text = config.text or "Get Back In The Car"
  director.banner = MDM_Banner:new(director.text)
  director.banner.color = 0
  director.showing = false

  director:OnUpdate(MDM_PlayerInCarBannerFeature._OnUpdate)

  return director
end

function MDM_PlayerInCarBannerFeature._OnUpdate(self)
  if not MDM_Utils.Player.IsInCar(self.car) and not self.banner:IsShowing() then
    self.banner:Show()
  end

  if MDM_Utils.Player.IsInCar(self.car) and self.banner:IsShowing() then
    self.banner:Hide()
  end
end

--@Overwrite
function MDM_PlayerInCarBannerFeature.Destroy(self)
  self.banner:Hide()
  MDM_Feature.Destroy(self)
end

function MDM_PlayerInCarBannerFeature.UnitTest()
  local m = MDM_Mission:new({title = ""})

  local director = MDM_PlayerInCarBannerFeature:new({mission = m,car = {}})
  director:Enable()
  director:Update()


end
