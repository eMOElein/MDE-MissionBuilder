MDM_MissionPack = {
  title = "MDM_MissionPack",
  author = "eMOElein",
  version = "0.1",
  luas = {
    "Plugins/MDM_MissionPack/MDM_LucasBertone",
    "Plugins/MDM_MissionPack/MDM_SalieriMissions",
    "Plugins/MDM_MissionPack/TestMissions",
    "Plugins/MDM_MissionPack/MDM_FrankMissions"
  }
}

MDM_Core.AddPlugin(MDM_MissionPack)

function MDM_MissionPack.Initialize()
  local client_frank = "Frank Colletti"
  local client_salieri = "Don Salieri"
  local client_lucas_bertone = "Lucas Bertone"
  local client_vincenzo = "Vincenzo"

  MDM_MissionPack.missions = {
    -----------------
    -- Don Salieri --
    -----------------
    {
      title = "Backyard Trouble",
      client = client_salieri,
      missionSupplier = MDM_SalieriMissions.M1_BackyardTrouble
    },
    {
      title = "Whisky Whopper",
      client = client_salieri,
      missionSupplier = MDM_SalieriMissions.M2_WhiskyWhopper
    },
    {
      title = "Little Italy Gang War",
      client = client_salieri,
      missionSupplier = MDM_SalieriMissions.M4_GangWar2
    },
    {
      title = "The Camino Escalation",
      client = client_salieri,
      missionSupplier = MDM_SalieriMissions.M5_The_Camino_Escalation
    },
    --------------------
    -- Frank Colletti --
    --------------------
    {
      title = "M1_Test",
      client = client_frank,
      missionSupplier = MDM_FrankMissions.M1_Test
    },
    -------------------
    -- Lucas Bertone --
    -------------------
    {
      title = "Fairplay 1-1",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M1_1_Fairplay
    },
    {
      title = "Trip to the Country 1-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M2_1_TripToTheCountry
    },
    {
      title = "Trip to the Country 2-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M2_2_TripToTheCountry
    },
    {
      title = "Omerta 1-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M3_1_Omerta
    },
    {
      title = "Omerta 2-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M3_2_Omerta
    },
    {
      title = "Lucky Bastard 4-1",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M4_1_LuckyBastard
    },
    {
      title = "Lucky Bastard 4-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M4_2_LuckyBastard
    },
    {
      title = "Creme de la Creme 1-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M5_1_CremeDeLaCreme
    },
    {
      title = "Creme de la Creme 2-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M5_2_CremeDeLaCreme
    },
    {
      title = "Election 1-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M6_1_Election
    },
    {
      title = "Election 2-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M6_2_Election
    },
    {
      title = "Moonlighting 1-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M7_1_Robbery
    },
    {
      title = "Moonlighting 2-2",
      client = client_lucas_bertone,
      missionSupplier = MDM_LucasBertone.M7_2_Robbery
    },
    --------------
    -- Vincenzo --
    --------------
    {
      title = "Random Assassination",
      client = client_vincenzo,
      missionSupplier = MDM_AssassinationMissionConfigurations.CreateRandomAssassinationMission
    },
    {
      title = "Random Shootout",
      client = client_vincenzo,
      missionSupplier = MDM_ShootoutMissionConfigurations.CreateRandomShootoutMission
    }
  }

  --  MDM_MissionPack.InitializeSalieriMissions()
  --  MDM_MissionPack.InitializeLucasBertoneMissions()
  --  MDM_MissionPack.InitializeFrankMissions()
  --  MDM_MissionPack.InitializeVincenzoMissions()
  MDM_MissionPack.InitializeRalphMissions()
  MDM_MissionPack.InitializeTestMissions()

end

function MDM_MissionPack.InitializeFrankMissions()
  local client = "Frank Colletti"

  local M1_Test = {
    title = "M1_Test",
    client = client,
    missionSupplier = MDM_FrankMissions.M1_Test
  }
  MDM_Core.missionManager:AddMissionProvider(M1_Test)
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

  local M5_Escalation = {
    title = "The Camino Escalation",
    client = client,
    missionSupplier = MDM_SalieriMissions.M5_The_Camino_Escalation
  }
  MDM_Core.missionManager:AddMissionProvider(M5_Escalation)
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

  local M6_2_Election = {
    title = "Election 2-2",
    client = client,
    missionSupplier = MDM_LucasBertone.M6_2_Election
  }
  MDM_Core.missionManager:AddMissionProvider(M6_2_Election)

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

  local BasicDetection = {
    title = "Basic Detection",
    client = client,
    missionSupplier =  TestMissions.BasicDetectionTest
  }
  MDM_Core.missionManager:AddMissionProvider(BasicDetection)

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

  local PatrolMission = {
    title = "NPC Patrol",
    client = client,
    missionSupplier = TestMissions.PatrolTest
  }
  MDM_Core.missionManager:AddMissionProvider(PatrolMission)

  local WaypointMission = {
    title = "Waypoint Mission",
    client = client,
    missionSupplier = TestMissions.WaypointMission
  }
  MDM_Core.missionManager:AddMissionProvider(WaypointMission)

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

  local civilWanderTest = {
    title = "Civil Wander Test",
    client = client,
    missionSupplier = TestMissions.CivilWanderTest
  }
  MDM_Core.missionManager:AddMissionProvider(civilWanderTest)

  local assassinationMissionTest = {
    title = "Assassination Mission Test",
    client = client,
    missionSupplier = TestMissions.AssassinationMission
  }
  MDM_Core.missionManager:AddMissionProvider(assassinationMissionTest)

  local simpleRaceMissionTest = {
    title = "SimpleRace Test",
    client = client,
    missionSupplier =   TestMissions.SimpleRace
  }
  MDM_Core.missionManager:AddMissionProvider(simpleRaceMissionTest)

  local walkToTest = {
    title = "Walk To Test",
    client = client,
    missionSupplier =   TestMissions.WalkToTest
  }
  MDM_Core.missionManager:AddMissionProvider(walkToTest)

  local distanceDirectorTest = {
    title = "Distance Director Test",
    client = client,
    missionSupplier = TestMissions.DistanceDiretorTest
  }
  MDM_Core.missionManager:AddMissionProvider(distanceDirectorTest)
end

function MDM_MissionPack.InitializeVincenzoMissions()
  local client = "Vincenzo"

  local assassinationMissionTest = {
    title = "Random Assassination",
    client = client,
    missionSupplier = MDM_AssassinationMissionConfigurations.CreateRandomAssassinationMission
  }

  local shootoutMission = {
    title = "Random Shootout",
    client = client,
    missionSupplier = MDM_ShootoutMissionConfigurations.CreateRandomShootoutMission
  }

  MDM_Core.missionManager:AddMissionProvider(assassinationMissionTest)
  MDM_Core.missionManager:AddMissionProvider(shootoutMission)
end

function MDM_MissionPack.InitializeRalphMissions()
  local client = "Ralph"

  local cartheftMissionTest = {
    title = "Random Car Theft",
    client = client,
    missionSupplier = function()
      local config = MDM_List.GetRandom(MDM_CarTheftMissionConfigurations.carThefts)
      local mission = MDM_CarTheftMission:new(config)
      return mission
    end
  }

  MDM_Core.missionManager:AddMissionProvider(cartheftMissionTest)
end
