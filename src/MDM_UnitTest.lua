require("MDM_LuaLoader")

MDM_UnitTest = {
  _tests = {}
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
  MDM_UnitTest.TestVector()
  MDM_UnitTest.TestVectorDistance()
  MDM_DefaultCallbackSystem.UnitTest()
  MDM_Updateable.UnitTest()
  MDM_MapCircle.UnitTest()
  ----------------
  --- Entities ---
  ----------------
  MDM_NPC.UnitTest()
  MDM_Car.UnitTest()
  ----------------
  ----- HUD ------
  MDM_Banner.UnitTest()
  ----------------
  --- Detectors --
  ----------------
  MDM_EntityInCircleDetector.UnitTest()
  MDM_TargetsDeadDetector.UnitTest()
  MDM_CarDamageDetector.UnitTest()
  MDM_PlayerInCarDetector.UnitTest()
  MDM_NPCHealthDetector.UnitTest()
  MDM_DetectorObjective.UnitTest()
  ----------------
  --- Directors --
  ----------------
  MDM_Director.UnitTest()
  MDM_PlayerInCarBannerDirector.UnitTest()
  MDM_PoliceFreeZoneDirector.UnitTest()
  MDM_BannerNotificationDirector.UnitTest()
  MDM_HostileZoneDirector.UnitTest()
  MDM_NPCGoToDirector.UnitTest()
  ----------------
  -- Objectives --
  ----------------
  MDM_Objective.UnitTest()
  MDM_GoToObjective.UnitTest()
  MDM_DestroyCarInAreaObjective.UnitTest()
  MDM_KillTargetsObjective.UnitTest()
  MDM_HurtNPCObjective.UnitTest()
  MDM_CallbackObjective.UnitTest()
  MDM_WaitObjective.UnitTest()
  MDM_SpawnerObjective.UnitTest()
  MDM_CallbackObjective.UnitTest()
  ----------------
  --Initialize Plugins
  ----------------
  MDM_Core._Initialize()
  MDM_MainMenu.UnitTest()
  ----------------
  --- Missions ---
  ----------------
  MDM_Mission.UnitTest()
  MDM_TestMissions.TestMissions()
  MDM_GangWarMission.UnitTest()
  MDM_SimpleRaceMission.UnitTest()
  MDM_ActivatorUtils.UnitTest()

  for _,test in ipairs(MDM_UnitTest._tests) do
    print("------------------:"..test.name)
    test.func()
    print("OK")
  end
  print("ALL OK!")
end

function MDM_UnitTest.TestVector()
  print("---------------Unit Test Vector")
  local vec = MDM_Utils.GetVector(1,2,3)
  if vec.x ~= 1 or vec.y ~= 2 or vec.z ~= 3 then
    error("vector test failed",2)
  end
end

function MDM_UnitTest.TestVectorDistance()
  print("---------------Unit Test VectorDistance")
  local vec = MDM_Utils.GetVector(2,0,0)
  local vec2 = MDM_Utils.GetVector(5,0,0)
  local distance = MDM_Utils.VectorDistance(vec,vec2)

  if distance ~= 3 then
    error("expected distance is 3 but was: " ..distance)
  end
end

MDM_LuaLoader.ImportLuas(MDM_LuaLoader._luas)
MDM_Core._Initialize()

all()

MDM_AssassinationMissionConfigurations.PickRandomAssassination()
MDM_AssassinationMissionConfigurations.CreateRandomAssassinationMission()
