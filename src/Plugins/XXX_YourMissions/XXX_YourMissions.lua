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

-- We want to create a new mission for the player
-- So we build a function that creates and returns one.
function XXX_YourMissions.M1_RunAroundTheBlock()
  local mission = MDM_Mission:new({
    title = "Run Around The Block",
    introText = "Tommy got quite obese from Luigi's excellent food.\nRun around the block to loose some weight.",
    outroText = "What a stress.\nTime for some more of Luigi's calzone",
    initialOutfit = "4784166002411347668",
    initialWeather = "mm_170_plane_cp_060_cine_1750_plane_airport",
  --    startPosition = MDM_Utils.GetVector(-908.99677,-230.64401,2.800674), MDM_Utils.GetVector(0.57007295,0.82159406,0) --currently blocks the game when introtext is set. Workaround needed.
  })

  local objective1 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-908.02795,-270.76718,2.7738907),
    title = "Run to the first location"
  })

  local objective2 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-1050.2584,-272.37515,1.8958902),
    title = "Run to the second location"
  })

  local objective3 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-1051.5273,-96.92054,2.78895),
    title = "Run to the third location"
  })

  local objective4 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-910.51318,-99.115875,4.0460014),
    title = "Run to the fourth location"
  })

  local objective5 = MDM_GoToObjective:new({
    position = MDM_Utils.GetVector(-908.99677,-230.64401,2.800674),
    title = "Run to the last location"
  })

  -- Add the objectives to the mission
  mission:AddObjectives({
    objective1,
    objective2,
    objective3,
    objective4,
    objective5
  })


  MDM_MissionManager.StartMission(mission)
  return mission
end

-- When a plugin is successfully loaded it's Initialize() function is called.
-- Wrap your missions in mission providers and pass them to MDM_Core.missionManager:AddMissionProvider()
function XXX_YourMissions.Initialize()
  local M1_RunAroundTheBlock = {
    title = "Run Around The Block",
    client = "Your Missions",
    missionSupplier = XXX_YourMissions.M1_RunAroundTheBlock -- the callback function that returns the mission we want to play.
  }
  MDM_Core.missionManager:AddMissionProvider(M1_RunAroundTheBlock)
end
