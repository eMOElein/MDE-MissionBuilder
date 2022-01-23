-- Create a namespace for your plugin.
-- Don't use MDM_* as namespace.
XXX_YourMissions = {
  title = "XXX_YourMissions",
  author = "eMOElein",
  version = "0.1",
  luas = {} -- if your plugin contains additional lua files you can place the paths here. they will be loaded automatically.
}

-- Add your plugin to the plugin list.
MDM_Core.AddPlugin(XXX_YourMissions)

-- When a plugin is successfully loaded it's Initialize() function is called.
-- Wrap your each of your missions in a mission provider and pass them to MDM_Core.missionManager:AddMissionProvider()
function XXX_YourMissions.Initialize()
  local M1_RunAroundTheBlock = {
    title = "Run Around The Block",
    client = "Your Missions",
    missionSupplier = XXX_YourMissions.M1_RunAroundTheBlock -- a callback function that returns the mission we want to play
  }
  MDM_Core.missionManager:AddMissionProvider(M1_RunAroundTheBlock)
end

-- We build a function that returns a mission and use it in the mission provider above as missionSupplier.
function XXX_YourMissions.M1_RunAroundTheBlock()
  local mission = MDM_Mission:new({
    title = "Run Around The Block",
    introText = "Tommy got quite obese from Luigi's excellent food.\nRun around the block to loose some weight.",
    outroText = "What a stress.\nTime for some more of Luigi's calzone",
    initialOutfit = "4784166002411347668",
    initialWeather = "mm_170_plane_cp_060_cine_1750_plane_airport",
    startPosition = MDM_Locations.SALIERIS_BAR_FRONTDOOR
  })

  local objective1 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-908.02795,-270.76718,2.7738907),
    radius = 10,
    title = "Run to the first location"
  })

  local objective2 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-1050.2584,-272.37515,1.8958902),
    radius = 10,
    title = "Run to the second location"
  })

  local objective3 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-1051.5273,-96.92054,2.78895),
    radius = 10,
    title = "Run to the third location"
  })

  local objective4 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-910.51318,-99.115875,4.0460014),
    radius = 10,
    title = "Run to the fourth location"
  })

  local objective5 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-908.99677,-230.64401,2.800674),
    radius = 10,
    title = "Run to the last location"
  })

  -- we create a director that fails the mission if the player enters a car.
  -- we run it while objective1 - objective5 are active.
  local carDirector = MDM_DetectorDirector:new({
    mission = mission, -- we assign the mission to the director so that the director gets updated on each update cycle of the mission.
    detector = MDM_PlayerInCarDetector:new({}),
    callback = function() mission:Fail("Mission Failed: You cheated!!!") end
  })
  MDM_ActivatorUtils.RunBetweenObjectives(carDirector,objective1,objective5)

  -- Add the objectives to the mission
  mission:AddObjectives({
    objective1,
    objective2,
    objective3,
    objective4,
    objective5
  })

  return mission
end
