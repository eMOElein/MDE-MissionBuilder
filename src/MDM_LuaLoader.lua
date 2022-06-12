MDM_LuaLoader = {}

MDM_LuaLoader._luas = {
  "Core/MDM_List",
  "Core/MDM_Vector",
  "Utils/MDM_VehicleUtils",
  "Utils/MDM_PlayerUtils",
  "Utils/MDM_PoliceUtils",
  "Utils/MDM_HUDUtils",
  "Utils/MDM_NPCUtils",
  "Utils/MDM_Missionutils",
  "Utils/MDM_IOUtils",
  "Utils/MDM_Utils",
  "Utils/MDM_Math",
  "Utils/MDM_SpawnUtils",
  "Core/MDM_DefaultCallbackSystem",
  "Core/MDM_DefaultCallbackMonitor",
  "Core/MDM_Core",
  "Core/MDM_MissionManager",
  "Enums/MDM_Districts",
  "Enums/MDM_Locations",
  "Utils/MDM_ActivatorUtils",
  "Core/MDM_Updateable",
  "Core/MDM_SpawnManager",
  "Core/MDM_Mission",
  "Core/MDM_Area",
  "Core/MDM_SphereArea",
  "Hud/MDM_Banner",
  "Hud/MDM_Blip",
  "Detectors/MDM_Detector",
  "Detectors/MDM_CarDamageDetector",
  "Detectors/MDM_EntityInCircleDetector",
  "Detectors/MDM_HudTimerZeroDetector",
  "Detectors/MDM_TargetsDeadDetector",
  "Detectors/MDM_NPCDeadDetector",
  "Detectors/MDM_NPCHealthDetector",
  "Detectors/MDM_PlayerInCarDetector",
  "Detectors/MDM_InvertedDetector",
  "Directors/MDM_Director",
  "Directors/MDM_PlayerInCarBannerDirector",
  "Directors/MDM_PoliceFreeZoneDirector",
  "Directors/MDM_HurtNPCDirector",
  "Directors/MDM_NPCGoToDirector",
  "Directors/MDM_NPCIdleAnimationDirector",
  "Directors/MDM_DetectorDirector",
  "Directors/MDM_BannerNotificationDirector",
  "Directors/MDM_HostileZoneDirector",
  "Directors/MDM_EntityDistanceDirector",
  "Entities/MDM_Entity",
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
  "Objectives/MDM_SpeakToObjective",
  "Objectives/Functional/MDM_RestorePlayerObjective",
  "Objectives/Functional/MDM_SpawnerObjective",
  "Objectives/MDM_CallbackObjective",
  "Objectives/MDM_DriveToObjective",
  "Objectives/MDM_DestroyCarInAreaObjective",
  "Objectives/MDM_WaitObjective",
  "Objectives/MDM_DetectorObjective",
  "MissionPrototypes/MDM_GangWarMission",
  "MissionPrototypes/MDM_AssassinationMission",
  "MissionPrototypes/MDM_CarTheftMission",
  "MissionPrototypes/MDM_SimpleRaceMission",
  "MissionPrototypes/MDM_ShootoutMission",
  "MissionPrototypes/Configurations/MDM_AssassinationMissionConfigurations",
  "MissionPrototypes/Configurations/MDM_CarTheftMissionConfigurations",
  "MissionPrototypes/Configurations/MDM_ShootoutMissionConfigurations",
  "Test/MDM_TestFunctions",
  "Plugins/MDM_Plugins",
}

function MDM_LuaLoader.ImportLuas(luas)
  for _,lua in ipairs(luas) do
    if game then
      local lua = lua ..".lua"
      include(lua)
    else
      require(lua)
    end
  end
end
