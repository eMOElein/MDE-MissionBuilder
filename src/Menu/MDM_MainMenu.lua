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
  MenuItems = {}
}

local script
MDM_MainMenu.mainMenu = nil
MDM_MainMenu.clientSelectionMenu = nil
MDM_MainMenu.activeMenu = nil
MDM_MainMenu.clientMenus = nil

local menu

--function script:CacheMenu(menu_callback)
--  local menu_d = nil
--  return function()
--    menu_d = menu_d or menu_callback()
--    return menu_d
--  end
--end

function MDM_MainMenu.Initialize(missionProviders)
  print("Initializing Main Menu!!!!")
  if not missionProviders then
    error("missionProviders not set",2)
  end

  script = ScriptHook.CurrentScript()

  script.CacheMenu = function(self, menu_callback)
    local menu_d = nil
    return function()
      menu_d = menu_d or menu_callback()
      return menu_d
    end
  end

  menu = MDM_MainMenu.CreateSimpleMenu()
  MainMenu = menu

  MainMenu:SetTitle("Main Menu")
  MDM_MainMenu.missionProviders = missionProviders

  local menu = UI.SimpleMenu()
  MainMenu = menu

  --  print("Create MainMenu")
  MDM_MainMenu.mainMenu = MDM_MainMenu.CreateMainMenu()
  --  print("Create Client Selection menu")
  MDM_MainMenu.clientSelectionMenu = MDM_MainMenu._CreateClientSelectionMenu()
  --  print("Create Client Menus")
  MDM_MainMenu.clientMenus = MDM_MainMenu._CreateClientMenus()
  --  print("Create Debug Menu")
  MDM_MainMenu.debugMenu = MDM_MainMenu._CreateDebugMenu()
  MDM_MainMenu.activeMenu = nil;

  table.insert(MDM_MainMenu.MenuItems, { "Client Selection", "Select a Client", ScriptHook.CurrentScript():CacheMenu(MDM_MainMenu._CreateClientSelectionMenu)})
  table.insert(MDM_MainMenu.MenuItems, { "Debug Menu", "Debug Menu", ScriptHook.CurrentScript():CacheMenu(MDM_MainMenu._CreateDebugMenu) })

  for _,data in ipairs(MDM_MainMenu.MenuItems) do
    menu:AddButton(unpack(data))
  end
end

function MDM_MainMenu.ShowMenu(menu)
  if not menu then
    error("menu not set",2)
  end

  if MDM_MainMenu.activeMenu then
    MDM_MainMenu.activeMenu:Deactivate()
  end

  MDM_MainMenu.activeMenu = menu
  MDM_MainMenu.activeMenu:Activate()
end

function MDM_MainMenu.ShowclientSelectionMenu()
  if not MDM_MainMenu.clientSelectionMenu then
    error("cleintsMenu is nil")
  end

  MDM_MainMenu.ShowMenu(MDM_MainMenu.clientSelectionMenu)
end

function MDM_MainMenu.CreateMainMenu(missionProviders)
  local menu = MDM_MainMenu.CreateSimpleMenu()

  if game then
    menu = UI.SimpleMenu()
  end

  menu:SetTitle("Main Menu")
  menu:AddButton("Missions", MDM_MainMenu.ShowclientSelectionMenu)
  --  menu:AddButton("Options", function() end)
  menu:AddButton("Debug", function() MDM_MainMenu.ShowMenu(MDM_MainMenu.debugMenu) end)
  return menu
end

function MDM_MainMenu.ClientMenu(client)
  menu = MDM_MainMenu.CreateSimpleMenu()
  menu:SetTitle(client)

  for _,provider in ipairs(MDM_MainMenu.missionProviders) do
    if(client == prodiver.client) then
      menu:AddButton(provider.title, provider.missionSupplier)
    end
  end
end

function MDM_MainMenu.ShowClientMissions(client)
  local menu = MDM_MainMenu.clientMenus[client]
  if not menu then
    error("no clientMissionMenu found for client: " .. client)
  end

  MDM_MainMenu.ShowMenu(menu)
end

function MDM_MainMenu._CreateClientMenus()
  local menus = {}

  local missionProviders = MDM_MainMenu.missionProviders
  for i,p in ipairs(missionProviders) do
    if not menus[p.client] then
      menus[p.client] = MDM_MainMenu.CreateSimpleMenu()
      menus[p.client]:SetTitle(p.client)
    end

    if not p.missionSupplier then
      error("missionSupplier is nil")
    end

    local menu =  menus[p.client]
    menu:AddButton(p.title, p.missionSupplier)
  end

  return menus
end

function MDM_MainMenu._GetClientMenu(client)
  for i,o in ipairs(MDM_MainMenu.clientMenus) do
    if o.client == client then
      return o.menu
    end
  end
end


function MDM_MainMenu._CreateClientSelectionMenu()
  local clients = {}

  local menu = MDM_MainMenu.CreateSimpleMenu()
  menu:SetTitle("Clients")

  local missionProviders = MDM_Core.missionManager.missionProviders
  for _,p in pairs(missionProviders) do
    local client = p.client
    if not clients[client] then
      --     menu:AddButton( { p.client, p.client, ScriptHook.CurrentScript():CacheMenu(MDM_MainMenu._CreateClientSelectionMenu)})

      local  func = function ()  return MDM_MainMenu._GetClientMenu(client) end

      --     menu:AddButon(client, client, ScriptHook.CurrentScript():CacheMenu(func))
      menu:AddButton(p.client,function()  MDM_MainMenu.ShowClientMissions(client) end)
      clients[client] = true
    end
  end

  return menu
end

function MDM_MainMenu.CreateSimpleMenu()
  local entry
  if game then
    return UI.SimpleMenu()
  else
    return {AddButton = function() end, SetTitle = function() end, Activate = function() end, Deactivate = function() end}
  end
end

function MDM_MainMenu.Activate()
  if not MDM_MainMenu.activeMenu then
    MDM_MainMenu.activeMenu = MDM_MainMenu.mainMenu
    MDM_MainMenu.activeMenu:Activate()
  end
end

function MDM_MainMenu.Deactivate()
  if MDM_MainMenu.activeMenu then
    MDM_MainMenu.activeMenu:Deactivate()
    MDM_MainMenu.activeMenu = nil
  end
end

function MDM_MainMenu.Toggle()
  MainMenu:Toggle()
end

function MDM_MainMenu._CreateDebugMenu()
  local menu = MDM_MainMenu.CreateSimpleMenu()
  menu:SetTitle("Debug Menu")
  menu:AddButton("Testfunction", MDM_TestFunctions.Test)
  menu:AddButton("Print PlayerPos", MDM_PlayerUtils.PrintPosition)
  menu:AddButton("Print Vehicle Infos", MDM_VehicleUtils.Info)
  menu:AddButton("Stop Active Mission", MDM_MissionManager.StopActiveMission)
  --menu:AddButton("Try File Reading", MDM_IOUtils.readMissionLuas) -- minimizes the game and does nothing. do not use.

  return menu
end

function MDM_MainMenu.UnitTest()
  print("---------------MDM_MainMenu UnitTest")
  local providers = {}
  MDM_Utils.ForEach(MDM_SalieriMissions.GetMissionProviders(), function(p) table.insert(providers,p)end)
  MDM_Utils.ForEach(MDM_LucasBertone.GetMissionProviders(), function(p) table.insert(providers,p)end)

  MDM_MainMenu.Initialize(providers)

  if not MDM_MainMenu.clientSelectionMenu then
    error("cientsMenu is nil",1)
  end

  MDM_MainMenu.ShowclientSelectionMenu()

  if MDM_MainMenu.activeMenu ~= MDM_MainMenu.clientSelectionMenu then
    error("activeMenu does not match clientSelectionMenu",1)
  end

  if not MDM_MainMenu.clientMenus then
    error("clientMenus is nil",1)
  end

  MDM_MainMenu.activeMenu = nil
  MDM_MainMenu.ShowClientMissions("Don Salieri")
  if not MDM_MainMenu.activeMenu then
    error("activeMenu is nil",1)
  end

  print("passed")
end
