--- MDM_PlayerInCarBannerDirector
-- Director that shows a banner when the player is not inside the monitored car.
MDM_PlayerInCarBannerDirector = {}
MDM_PlayerInCarBannerDirector = MDM_Director:class()

--- The constructor configuration table must contain the following fields.
-- @param mission an instance of MDM_Mission that this director is attached to.
-- @param car an instance of MDM_Car
function MDM_PlayerInCarBannerDirector:new (config)
  if not config.car then
    error("carEntity not set",2)
  end

  local director = MDM_Director:new({mission = config.mission})
  setmetatable(director, self)
  self.__index = self

  director.carEntity = config.car
  director.text = config.text or "Get Back In The Car"
  director.detector = MDM_PlayerInCarDetector:new(config)
  director.banner = MDM_Banner:new(director.text)
  director.banner.color = 0
  director.showing = false
  return director
end

--@Overwrite
function MDM_PlayerInCarBannerDirector.Update(self)
  if not self:IsEnabled() then
    return
  end

  if not self.detector:Test() and not self.banner:IsShowing() then
    self.banner:Show()
  end

  if self.detector:Test() and self.banner:IsShowing() then
    self.banner:Hide()
  end

  MDM_Director.Update(self)
end

--@Overwrite
function MDM_PlayerInCarBannerDirector.Destroy(self)
  self.banner:Hide()
  MDM_Director.Destroy(self)
end

function MDM_PlayerInCarBannerDirector.UnitTest()
  local m = MDM_Mission:new({title = ""})

  local value = false
  local director = MDM_PlayerInCarBannerDirector:new({mission = m,car = {IsPlayerInCar = function() return value end, IsSpawned = function() return true end}})
  director:Enable()
  director:Update()
  if not director.banner:IsShowing() then
    error("banner should be showing")
  end

  value = true
  director:Update()
  if director.banner:IsShowing() then
    error("banner not be showing")
  end

  value = false
  director:Update()
  if not director.banner:IsShowing() then
    error("banner should  be showing")
  end
end
