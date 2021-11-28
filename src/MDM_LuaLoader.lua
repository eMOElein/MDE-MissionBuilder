MDM_LuaLoader = {}

MDM_LuaLoader._luas = {
  "Utils/MDM_Utils",
  "Utils/MDM_Math",
  "Core/MDM_Core",
  "Core/MDM_MissionManager",
  "Core/MDM_Chronometer",
  "Enums/MDM_Locations",
  "MDM_Userimports",
  "Utils/MDM_ActivatorUtils",
  "Core/MDM_Updateable",
  "Core/MDM_SpawnManager",
  "Core/MDM_Mission",
  "Core/MDM_MissionProvider",
  "Hud/MDM_Banner",
  "Detectors/MDM_Detector",
  "Detectors/MDM_CarDamageDetector",
  "Detectors/MDM_EntityInCircleDetector",
  "Detectors/MDM_HudTimerZeroDetector",
  "Detectors/MDM_TargetsDeadDetector",
  "Detectors/MDM_NPCDeadDetector",
  "Detectors/MDM_PlayerInCarDetector",
  "Directors/MDM_Director",
  "Directors/MDM_PlayerInCarBannerDirector",
  "Directors/MDM_PoliceFreeZoneDirector",
  "Directors/MDM_HurtNPCDirector",
  "Directors/MDM_DetectorDirector",
  "Directors/MDM_BannerNotificationDirector",
  "Directors/MDM_HostileZoneDirector",
  "Core/MDM_Entity",
  "Entities/MDM_Car",
  "Entities/MDM_NPC",
  "hud/MDM_ObjectivePosition",
  "Menu/MDM_MainMenu",
  "hud/MDM_MapCircle",
  "Objectives/MDM_Objective",
  "Objectives/MDM_GoToObjective",
  "Objectives/MDM_PoliceEvadeObjective",
  "Objectives/MDM_GetInCarObjective",
  "Objectives/MDM_HurtNPCObjective",
  "Objectives/MDM_KillTargetsObjective",
  "Objectives/MDM_MockObjective",
  "Objectives/Functional/MDM_RestorePlayerObjective",
  "Objectives/MDM_CallbackObjective",
  "Objectives/MDM_DestroyCarInAreaObjective",
  "Objectives/MDM_WaveObjective",
  "Objectives/Functional/MDM_FunctionObjective",
  "MissionPrototypes/MDM_GangWarMission",
  "Utils/MDM_VehicleUtils",
  "Utils/MDM_PlayerUtils",
  "Utils/MDM_PoliceUtils",
  "Utils/MDM_HUDUtils",
  "Utils/MDM_NPCUtils",
  "Utils/MDM_Missionutils",
  "Utils/MDM_IOUtils",
  "Test/MDM_TestFunctions",
  "Test/MDM_TestMissions",
  "Plugins/MDM_Plugins",
}

function MDM_LuaLoader.ImportLuas(luas)
  for _,lua in ipairs(luas) do
    --    print("Importing: " ..lua)
    if game then
      local lua = lua ..".lua"
      include(lua)
    else
      require(lua)
    end
  end
end
