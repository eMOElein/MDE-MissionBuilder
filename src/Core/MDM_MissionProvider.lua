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

MDM_MissionProvider = {}

local args = {
title = "New Mission",
client = "Anonymous",
missionSupplier = nil
}

function MDM_MissionProvider:new(missionProvider, title, client)
  local provider =  {}
  --  setmetatable(provider, self)
  --  self.__index = self


  if type(missionProvider) ~= "function" then
    error("missionProvider is nil or not a function",2)
  end

  provider.title = title
  provider.description = "description"
  provider.client = client
  provider.missionProvider = missionProvider
  return provider
end

function MDM_MissionProvider.ProvideMission(self)
  return self.missionProvider()
end
