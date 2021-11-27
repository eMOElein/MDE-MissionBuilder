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

MDM_MainMenu = {
  missionProviders = {},
  activeMenu = nil
}

local script
local menu

function MDM_MainMenu.Initialize(missionProviders)
  if not missionProviders then
    error("missionProviders not set",2)
  end
  MDM_MainMenu.missionProviders = missionProviders

  if ScriptHook then
    script = ScriptHook.CurrentScript()
  else
    script = {}
  end

  script.CacheMenu = function(self, menu_callback)
    local menu_d = nil
    return function()
      menu_d = menu_d or menu_callback()
      MDM_MainMenu.activeMenu = menu_d
      return menu_d
    end
  end

  menu = MDM_MainMenu.CreateSimpleMenu()
  menu:SetTitle("Main Menu")
  menu:AddButton( "Missions", "Select a Client", script:CacheMenu(MDM_MainMenu._ClientSelectionMenuFactory))
  menu:AddButton( "Debug Menu", "Debug Menu",script:CacheMenu(MDM_MainMenu._DebugMenu) )
end

function MDM_MainMenu.CreateMainMenu(missionProviders)
  local menu = MDM_MainMenu.CreateSimpleMenu()

  if game then
    menu = UI.SimpleMenu()
  end

  menu:SetTitle("Main Menu")
  menu:AddButton("Missions", MDM_MainMenu.ShowclientSelectionMenu)
  menu:AddButton("Debug", function() MDM_MainMenu.ShowMenu(MDM_MainMenu.debugMenu) end)
  return menu
end

function MDM_MainMenu._ClientSelectionMenuFactory()
  local clients = {}

  local menu = MDM_MainMenu.CreateSimpleMenu()
  menu:SetTitle("Clients")

  local missionProviders = MDM_Core.missionManager.missionProviders
  for _,p in pairs(missionProviders) do
    local client = p.client
    if not clients[client] then
      menu:AddButton(client, client, script:CacheMenu(MDM_MainMenu._ClientMenuFactory(client)))
      clients[client] = true
    end
  end

  return menu
end

function MDM_MainMenu._ClientMenuFactory(client)
  return function ()
    local menu = MDM_MainMenu.CreateSimpleMenu()
    menu:SetTitle(client)

    for _,provider in ipairs(MDM_MainMenu.missionProviders) do
      if(client == provider.client) then
        menu:AddButton(provider.title, provider.missionSupplier)
      end
    end
    return menu
  end
end

function MDM_MainMenu.CreateSimpleMenu()
  local entry
  if game then
    return UI.SimpleMenu()
  else
    return {AddButton = function() end, SetTitle = function() end, Activate = function() end, Deactivate = function() end}
  end
end

function MDM_MainMenu.Toggle()
  menu:Toggle()
end

function MDM_MainMenu.Hide()
  if MDM_MainMenu.activeMenu then
    MDM_MainMenu.activeMenu:Deactivate()
  end
end

function MDM_MainMenu._DebugMenu()
  local menu = MDM_MainMenu.CreateSimpleMenu()
  menu:SetTitle("Debug Menu")
  menu:AddButton("Testfunction", MDM_TestFunctions.Test)
  menu:AddButton("Print PlayerPos", MDM_PlayerUtils.PrintPosition)
  menu:AddButton("Print Vehicle Infos", MDM_VehicleUtils.Info)
  menu:AddButton("Stop Active Mission", MDM_MissionManager.StopActiveMission)

  return menu
end

function MDM_MainMenu.UnitTest()
  print("---------------MDM_MainMenu UnitTest")

  MDM_MainMenu.Initialize(MDM_Core.missionManager.missionProviders)

  MDM_MainMenu._ClientSelectionMenuFactory()

  print("passed")
end
