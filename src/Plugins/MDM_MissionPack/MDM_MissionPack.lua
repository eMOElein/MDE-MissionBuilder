MDM_MissionPack = {
  title = "MDM_MissionPack",
  author = "eMOElein",
  version = "0.1",
  luas = {
    "Plugins/MDM_Missionpack/MDM_LucasBertone",
    "Plugins/MDM_Missionpack/MDM_SalieriMissions",
    "Plugins/MDM_Missionpack/TestMissions"
  }
}

MDM_Core.AddPlugin(MDM_MissionPack)

function MDM_MissionPack.Initialize()
  MDM_MissionPack.InitializeSalieriMissions()
  MDM_MissionPack.InitializeLucasBertoneMissions()
  MDM_MissionPack.InitializeTestMissions()
end

function MDM_MissionPack.InitializeSalieriMissions()
  local client = "Don Salieri"

  local M1_BackyardTrouble = {
    title = "Backyard Trouble",
    client = client,
    missionSupplier = MDM_SalieriMissions.M1_BackyardTrouble
  }
  MDM_Core.missionManager:AddMissionProvider(M1_BackyardTrouble)

  local M2_WhiskyWhopper = {
    title = "Whisky Whopper",
    client = client,
    missionSupplier = MDM_SalieriMissions.M2_WhiskyWhopper
  }
  MDM_Core.missionManager:AddMissionProvider(M2_WhiskyWhopper)

  local M3_GangWar2 = {
    title = "Little Italy Gang War",
    client = client,
    missionSupplier = MDM_SalieriMissions.M4_GangWar2
  }
  MDM_Core.missionManager:AddMissionProvider(M3_GangWar2)
end

function MDM_MissionPack.InitializeLucasBertoneMissions()
  local client = "Lucas Bertone"

  local M1_1_Fairplay = {
    title = "Fairplay 1-1",
    client = client,
    missionSupplier = MDM_LucasBertone.M1_1_Fairplay
  }
  MDM_Core.missionManager:AddMissionProvider(M1_1_Fairplay)

  local M2_1_TripToTheCountry = {
    title = "Trip to the Country 1-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M2_1_TripToTheCountry
  }
  MDM_Core.missionManager:AddMissionProvider(M2_1_TripToTheCountry)

  local M2_2_TripToTheCountry = {
    title = "Trip to the Country 2-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M2_2_TripToTheCountry
  }
  MDM_Core.missionManager:AddMissionProvider(M2_2_TripToTheCountry)

  local M3_1_Omerta = {
    title = "Omerta 1-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M3_1_Omerta
  }
  MDM_Core.missionManager:AddMissionProvider(M3_1_Omerta)

  local M3_2_Omerta = {
    title = "Omerta 2-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M3_2_Omerta
  }
  MDM_Core.missionManager:AddMissionProvider(M3_2_Omerta)

  local M4_1_LuckyBastard = {
    title = "Lucky Bastard 4-1",
    client = client,
    missionSupplier = MDM_LucasBertone.M4_1_LuckyBastard
  }
  MDM_Core.missionManager:AddMissionProvider(M4_1_LuckyBastard)

  local M4_2_LuckyBastard = {
    title = "Lucky Bastard 4-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M4_2_LuckyBastard
  }
  MDM_Core.missionManager:AddMissionProvider(M4_2_LuckyBastard)

  local M5_1_CremeDeLaCreme = {
    title = "Creme de la Creme 1-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M5_1_CremeDeLaCreme
  }
  MDM_Core.missionManager:AddMissionProvider(M5_1_CremeDeLaCreme)

  local M5_2_CremeDeLaCreme = {
    title = "Creme de la Creme 2-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M5_2_CremeDeLaCreme
  }
  MDM_Core.missionManager:AddMissionProvider(M5_2_CremeDeLaCreme)

  local M6_1_Election = {
    title = "Election 1-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M6_1_Election
  }
  MDM_Core.missionManager:AddMissionProvider(M6_1_Election)

  local M7_1_Robbery ={
    title = "Moonlighting 1-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M7_1_Robbery
  }
  MDM_Core.missionManager:AddMissionProvider(M7_1_Robbery)

  local M7_2_Robbery = {
    title = "Moonlighting 2-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M7_2_Robbery
  }
  MDM_Core.missionManager:AddMissionProvider(M7_2_Robbery)
end

function MDM_MissionPack.InitializeTestMissions()
  local client = "DebugMissions"

  local GetInCar = {
    title = "GetInCar",
    client = client,
    missionSupplier = TestMissions.GetInCar
  }
  MDM_Core.missionManager:AddMissionProvider(GetInCar)

  local KillMission = {
    title = "Killtargets Mission",
    client = client,
    missionSupplier = TestMissions.KillMission
  }
  MDM_Core.missionManager:AddMissionProvider(KillMission)

  local WaypointMission = {
    title = "Waypoint Mission",
    client = client,
    missionSupplier = TestMissions.WaypointMission
  }
  MDM_Core.missionManager:AddMissionProvider(WaypointMission)

  local WaveTest = {
    title = "Wave Mission",
    client = client,
    missionSupplier = TestMissions.WaveTest
  }
  MDM_Core.missionManager:AddMissionProvider(WaveTest)

  local GangWarTest = {
    title = "Gang War Mission",
    client = client,
    missionSupplier = TestMissions.GangWarTest
  }
  MDM_Core.missionManager:AddMissionProvider(GangWarTest)

  local WaveTest = {
    title = "Destroy Car in Area",
    client = client,
    missionSupplier = TestMissions.DestroyCarInAreaTest
  }
  MDM_Core.missionManager:AddMissionProvider(WaveTest)

  local hostileZoneTest = {
    title = "Hostile Zone Test",
    client = client,
    missionSupplier = TestMissions.HostileZoneTest
  }
  MDM_Core.missionManager:AddMissionProvider(hostileZoneTest)

  local carchaseTest = {
    title = "Carchase Test",
    client = client,
    missionSupplier = TestMissions.CarchaseTest
  }
  MDM_Core.missionManager:AddMissionProvider(carchaseTest)

  local pursuitTest = {
    title = "Pursuit Test",
    client = client,
    missionSupplier = TestMissions.PursuitTest
  }
  MDM_Core.missionManager:AddMissionProvider(pursuitTest)

  local duelTest = {
    title = "Duel Test",
    client = client,
    missionSupplier = TestMissions.DuelTest
  }
  MDM_Core.missionManager:AddMissionProvider(duelTest)

  local waitObjectiveTest = {
    title = "WaitObjective Test",
    client = client,
    missionSupplier = TestMissions.WaitObjectiveTest
  }
  MDM_Core.missionManager:AddMissionProvider(waitObjectiveTest)

end
