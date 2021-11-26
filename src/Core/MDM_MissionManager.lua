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

MDM_MissionManager = {}

local  menuInitialized = false;
local missionInProgressBanner = nil
local activeMission = nil

function MDM_MissionManager:new ()
  local missionManager = {}
  setmetatable(missionManager, self)
  self.__index = self

  missionManager.missionProviders = {}
  return missionManager
end

function MDM_MissionManager.ToggleMissionMenu(self)
  if not menuInitialized then
    MDM_MainMenu.Initialize(self:FetchMissionProviders())
    menuInitialized = true
  end
  MDM_MainMenu.Toggle()
end

function MDM_MissionManager.HideMenu()
  if activeMenu and activeMenu:IsActive() then
    activeMenu:Deactivate()
  end
end

function MDM_MissionManager.AddMissionProvider(self,missionProvider)
  --  print("Adding Mission: " ..missionProvider.title)
  table.insert(self.missionProviders, missionProvider)
end

function MDM_MissionManager.FetchMissionProviders(self)
  if not self then
    error("self not set",2)
  end

  return self.missionProviders
end

local function _InitializeMission(mission)
  if game then
    local initialWeather = mission:GetInitialWeather()
    if initialWeather then
      game.gfx:SetWeatherSet(initialWeather, 0, 0)
    end

    local initialSeason = GetInitialSeason
    if initialSeason then
      game.traffic:CloseSeason()
      game.traffic:OpenSeason(initialSeason)
    end

    local initialOutfit = mission:GetInitialOutfit()
    if initialOutfit then
      game.outfits:SetCurrentOutfit(initialOutfit)
    end

    if mission:GetStartPos() and game then
      getp():Teleport(mission:GetStartPos(), getp():GetDir(), true)
    end
  end
end

local function _ShowBlockedBanner()
  if not missionInProgressBanner then
    missionInProgressBanner = MDM_Banner:new("Mission in progress")
  end


  if game then
    game.audio:PlaySimpleEvent("mx_Gameplay_Music_Mission_Complete")
    --    game.hud:SendMessageMovie("HUD", "OnShowFreerideNotification", "Mission in progress", "", 1)
    missionInProgressBanner:Show()
    StartThread(function ()
      Sleep(1000)
      --      game.hud:SendMessageMovie("HUD", "OnHideFreerideNotification")
      missionInProgressBanner:Hide()
    end)
  end
end

function MDM_MissionManager.StartMission(mission)
  if activeMission then
    _ShowBlockedBanner()
    return false
  end

  if #mission.objectives <= 0 then
    error("mission has no objectives",2)
  end

  activeMission = mission
  _InitializeMission(mission)
  MDM_MainMenu.Deactivate()
  mission:Start()
  return true
end


function MDM_MissionManager.StopActiveMission()
  if activeMission then
    local m = activeMission
    activeMission = nil
    m:Fail("Mision Canceled!")
  end
end

function MDM_MissionManager.Update(self)
  if game.hud:IsFadingOut() or game.hud:IsFadedOut() then
    return
  end

  if activeMission then
    if activeMission.Update then activeMission:Update() end
    if not activeMission:IsRunning() then activeMission = nil end
  end

  MDM_SpawnManager.Update()
end

local function PrintInfo()
  if(game ~= nil) then
    print("Printing Game:")
    print(MDM_Utils.tprint(game))
    print("Printing Police:")
    print(MDM_Utils.tprint(game.police))
    print("Printing game.police:GetActiveZones:")
    print(MDM_Utils.tprint(game.police:GetActiveZones()))
  end
end
