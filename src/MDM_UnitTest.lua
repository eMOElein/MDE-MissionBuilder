require("MDM_LuaLoader")

MDM_UnitTest = {
  _tests = {},
  _luas = {
    "UnitTests/MDM_Director_Test",
    "UnitTests/MDM_AreaTest",
    "UnitTests/MDM_SphereAreaTest",
    "UnitTests/MDM_CarTest",
    "UnitTests/MDM_NPCTest",
    "UnitTests/MDM_MissionTest",
    "UnitTests/MDM_ObjectiveTest",
    "UnitTests/MDM_CallbackObjectiveTest"
  }
}

function MDM_UnitTest.RegisterTest(args)
  if args.name == nil then
    error("name not set",2)
  end

  if not args.func then
    error("func not set",2)
  end

  if type(args.func) ~= "function" then
    error("args is not of type function",2)
  end

  local test = {}
  test.name = args.name
  test.func = args.func

  table.insert(MDM_UnitTest._tests,test)
end

function all()
  ----------------
  ----- Core -----
  ----------------
  MDM_UnitTest.RegisterTest({name = "MDM_DefaultCallbackSystem.UnitTest", func = MDM_DefaultCallbackSystem.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_Updateable.UnitTest", func = MDM_Updateable.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_AreaTest.UnitTest", func = MDM_AreaTest.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_SphereAreaTest.UnitTest", func =  MDM_SphereAreaTest.UnitTest})
  ----------------
  --- Entities ---
  ----------------
  MDM_UnitTest.RegisterTest({name = "MDM_NPCTest.UnitTest", func = MDM_NPCTest.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_CarTest.UnitTest", func = MDM_CarTest.UnitTest})
  ----------------
  --- Directors --
  ----------------
  MDM_UnitTest.RegisterTest({name = "MDM_Director_Test.UnitTest", func = MDM_Director_Test.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_PlayerInCarBannerDirector.UnitTest", func = MDM_PlayerInCarBannerDirector.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_PoliceFreeZoneDirector.UnitTest", func = MDM_PoliceFreeZoneDirector.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_HostileZoneDirector.UnitTest", func = MDM_HostileZoneDirector.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_NPCGoToDirector.UnitTest", func = MDM_NPCGoToDirector.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_EntityDistanceDirector.UnitTest", func = MDM_EntityDistanceDirector.UnitTest})
  ----------------
  -- Objectives --
  ----------------
  MDM_UnitTest.RegisterTest({name = "MDM_ObjectiveTest.UnitTest", func = MDM_ObjectiveTest.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_GoToObjective.UnitTest", func = MDM_GoToObjective.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_DestroyCarInAreaObjective.UnitTest", func = MDM_DestroyCarInAreaObjective.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_KillTargetsObjective.UnitTest", func = MDM_KillTargetsObjective.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_HurtNPCObjective.UnitTest", func = MDM_HurtNPCObjective.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_CallbackObjectiveTest.UnitTest", func = MDM_CallbackObjectiveTest.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_WaitObjective.UnitTest", func = MDM_WaitObjective.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_SpawnerObjective.UnitTest", func = MDM_SpawnerObjective.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_GetInCarObjective.UnitTest", func = MDM_GetInCarObjective.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_DriveToObjective.UnitTest", func = MDM_DriveToObjective.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_SpeakToObjective.UnitTest", func = MDM_SpeakToObjective.UnitTest})
  ----------------
  --- Missions ---
  ----------------
  MDM_UnitTest.RegisterTest({name = "MDM_GangWarMission.UnitTest", func = MDM_GangWarMission.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_SimpleRaceMission.UnitTest", func = MDM_SimpleRaceMission.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_ActivatorUtils.UnitTest", func = MDM_ActivatorUtils.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_AssassinationMissionConfigurations.CreateRandomAssassinationMission", func = MDM_AssassinationMissionConfigurations.CreateRandomAssassinationMission})
  MDM_UnitTest.RegisterTest({name = "MDM_CarTheftMission.UnitTest" , func = MDM_CarTheftMission.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_ShootoutMission.UnitTest" , func = MDM_ShootoutMission.UnitTest})
  ----------------
  ----- HUD ------
  ----------------
  MDM_UnitTest.RegisterTest({name = "MDM_Banner.UnitTest", func = MDM_Banner.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_MapCircle.UnitTest", func = MDM_MapCircle.UnitTest})
  MDM_UnitTest.RegisterTest({name = "MDM_Blip.UnitTest",func = MDM_Blip.UnitTest})
  -----------------
  ----- Utils -----
  -----------------
  MDM_UnitTest.RegisterTest({name = "MDM_UnitTest.TestVector", func = MDM_UnitTest.TestVector})
  MDM_UnitTest.RegisterTest({name = "MDM_UnitTest.TestVectorDistance", func = MDM_UnitTest.TestVectorDistance})

  MDM_UnitTest.RegisterTest({name = "MDM_Core._Initialize", func = MDM_Core._Initialize})
  MDM_UnitTest.RegisterTest({name = "MDM_Core._InitializePlugins", func = MDM_Core._InitializePlugins})

  MDM_UnitTest.RegisterTest({name = "MDM_MainMenu.UnitTest", func = MDM_MainMenu.UnitTest})

  for _,test in ipairs(MDM_UnitTest._tests) do
    print("------------------:"..test.name)
    test.func()
    print("OK")
  end
end

function MDM_UnitTest.TestVector()
  local vec = MDM_Utils.GetVector(1,2,3)
  if vec.x ~= 1 or vec.y ~= 2 or vec.z ~= 3 then
    error("vector test failed",2)
  end
end

function MDM_UnitTest.TestVectorDistance()
  local vec = MDM_Utils.GetVector(2,0,0)
  local vec2 = MDM_Utils.GetVector(2,3,0)
  local distance = MDM_Utils.VectorDistance(vec,vec2)

  if distance ~= 3 then
    error("expected distance is 3 but was: " ..distance)
  end
end

MDM_LuaLoader.ImportLuas(MDM_LuaLoader._luas)
MDM_LuaLoader.ImportLuas(MDM_UnitTest._luas)
all()
MDM_ShootoutMission.UnitTest()
print("ALL OK!")

