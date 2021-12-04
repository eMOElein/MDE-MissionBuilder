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

--- MDM_BannerNotificationDirector
-- Shows the given banner when the detectors's test succeeds and hides it when it fails
MDM_BannerNotificationDirector = {}
MDM_BannerNotificationDirector = MDM_Director:class()

--- Configuration
-- Generates the configuration object needed for the constructor
--
-- @param detector
-- @param banner
function MDM_BannerNotificationDirector.Args()
  local configuration = {
    mission = nil,
    detector = nil,
    banner = nil
  }
  return configuration
end

--- Constructor
-- @param detector
-- @param banner
function MDM_BannerNotificationDirector:new (args)
  if not args.detector then
    error("detector not set",2)
  end

  if not args.banner then
    error("banner not set",2)
  end


  local director = MDM_Director:new(args)
  setmetatable(director, self)
  self.__index = self

  director.configuration = args
  return director
end

function MDM_BannerNotificationDirector.Update(self)

  if self.configuration.detector:Test() and not self.configuration.banner:IsShowing(self) then
    self.configuration.banner:Show()
  end

  if not self.configuration.detector:Test() and  self.configuration.banner:IsShowing(self) then
    self.configuration.banner:Hide()
  end


  MDM_Director.Update(self)
end

function MDM_BannerNotificationDirector.Destroy(self)
  self.configuration.banner:Hide()
  MDM_Director.Destroy(self)
end

function MDM_BannerNotificationDirector.UnitTest()
  local value = false

  local mission = MDM_Mission:new({title = ""})
  local detector = {Test = function() return value end}
  local banner = MDM_Banner:new("")

  local  director = MDM_BannerNotificationDirector:new({mission = mission, detector = detector, banner = banner})
  director:Update()

  if banner:IsShowing() then
    error("banner should not be showing")
  end

  value = true
  director:Update()

  if not banner:IsShowing() then
    error("banner should be showing")
  end

  value = false
  director:Update()

  if banner:IsShowing() then
    error("banner should not be showing")
  end
end
