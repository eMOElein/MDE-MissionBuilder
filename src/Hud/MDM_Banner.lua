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

MDM_Banner = {}

function MDM_Banner:class()
  local banner = {}
  setmetatable(banner, self)
  self.__index = self

  return banner
end

function MDM_Banner:new(title)
  local banner = MDM_Banner:class()
  banner.title = title
  banner.showing = false
  banner.color = 1
  banner.time = 0
  return banner
end

function MDM_Banner.SetColor(self,color)
  self.color = color
  return self
end

function MDM_Banner.IsShowing(self)
  return self.showing
end

function MDM_Banner.Show(self)
  if game then
    game.hud:SendMessageMovie("HUD", "OnShowFreerideNotification", self.title, "", self.color)

    if self.time > 0 then
      StartThread(function ()
        Sleep(self.time)
        self:Hide()
      end)
    end
  end

  self.showing = true
end

function MDM_Banner.Hide(self)
  if game then
    game.hud:SendMessageMovie("HUD", "OnHideFreerideNotification")
  end
  self.showing = false
end

function MDM_Banner.UnitTest()
  print("---------------MDM_Banner Unit Test")
  local banner = MDM_Banner:new("MyBanner")
  banner.time = 2000

  if  banner:IsShowing() then
    error("banner should not be showing",1)
  end

  banner:Show()

  if not banner:IsShowing() then
    error("banner should be showing",1)
  end

  banner:Hide()

  if  banner:IsShowing() then
    error("banner should not be showing",1)
  end
end
