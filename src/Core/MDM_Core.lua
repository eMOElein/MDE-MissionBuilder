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

MDM_Core = {
  _plugins = {},
  missionManager = nil

}

function MDM_Core._Update()
  local LoadedMap = game.director:CityGetActiveName()
  if LoadedMap == "Lost Heaven" and not game.hud:IsLoadingScreenUp() then
    MDM_Core.missionManager:Update()
  end
end

function MDM_Core.AddPlugin(plugin)
  table.insert(MDM_Core._plugins,plugin)
end

function MDM_Core._Initialize()
  MDM_Core.missionManager = MDM_MissionManager:new()
  MDM_Core._InitializePlugins()
end

function MDM_Core._InitializePlugins()
  for _, lua in ipairs(MDM_Plugins.luas) do

    print("importing plugin: " ..lua)
    MDM_LuaLoader.ImportLuas({lua})
  end

  for _,plugin in ipairs(MDM_Core._plugins) do
    if plugin.luas then
      MDM_LuaLoader.ImportLuas(plugin.luas)
    end
    print("initializing plugin: " ..plugin.title)
    plugin.Initialize()
  end
end
