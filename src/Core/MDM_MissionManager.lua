MDM_MissionManager = {}

local  menuInitialized = false;
local missionInProgressBanner = nil
local activeMission = nil

function MDM_MissionManager:new ()
  local missionManager = {}
  setmetatable(missionManager, self)
  self.__index = self

  missionManager.missionProviders = {}
  missionManager.missionInitialized = false
  self.missionInitialized = false
  self.missionStarted = false
  return missionManager
end

function MDM_MissionManager.ToggleMissionMenu(self)
  if not menuInitialized then
    MDM_MainMenu.Initialize(self.missionProviders)
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
  if not missionProvider.missionSupplier then
    error("mission supplier not set",2)
  end


  if type(missionProvider.missionSupplier) ~= "function" then
    error("mission supplier not of type function",2)
  end

  table.insert(self.missionProviders, missionProvider)
end

function MDM_MissionManager.FetchMissionProviders(self)
  if not self then
    error("self not set",2)
  end

  return self.missionProviders
end

local function _InitializeMission(mission)
  if not mission then
    error("mission not set",2)
  end

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

    if mission.startDirection and game then
      getp():SetDir(mission.startDirection)
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

function MDM_MissionManager.StartMission(self, mission)
  if not mission then
    error("mission not set",2)
  end

  if activeMission then
    _ShowBlockedBanner()
    return false
  end

  if #mission.objectives <= 0 then
    error("mission has no objectives",2)
  end

  MDM_Core.callbackSystem.NotifyCallbacks("on_before_mission_start",{
    mission = mission
  })

  activeMission = mission
  self.missionInitialized = false
  self.missionStarted = false
  -- _InitializeMission(mission)
  MDM_MainMenu.Hide()
  --  mission:Start()
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
  MDM_SpawnManager.Update()

  if not activeMission then
    return
  end

  if game.hud:IsFadingOut() or game.hud:IsFadedOut() then
    return
  end

  if not self.missionInitialized then
    _InitializeMission(activeMission)
    self.missionInitialized = true
    return
  end

  if not self.missionStarted then
    activeMission:Start()
    self.missionStarted = true
  end


  if activeMission and game and getp():IsDeath() then
    activeMission:Fail()
  end

  if activeMission then
    if activeMission.Update then activeMission:Update() end
    if not activeMission:IsRunning() then activeMission = nil end
  end
end
