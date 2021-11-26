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

require("MDM_LuaLoader")

MDM_LuaLoader.ImportLuas(MDM_LuaLoader._luas)

UnitTest = {}
function all()
  UnitTest.TestVector()
  UnitTest.TestVectorDistance()
  MDM_Updateable.UnitTest()
  --  MDM_MainMenu.UnitTest()
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
  ----------------
  --- Directors --
  ----------------
  MDM_Director.UnitTest()
  MDM_PlayerInCarBannerDirector.UnitTest()
  MDM_PoliceFreeZoneDirector.UnitTest()
  MDM_BannerNotificationDirector.UnitTest()
  MDM_HostileZoneDirector.UnitTest()
  ----------------
  -- Objectives --
  ----------------
  MDM_Objective.UnitTest()
  MDM_GoToObjective.UnitTest()
  MDM_DestroyCarInAreaObjective.UnitTest()
  MDM_KillTargetsObjective.UnitTest()
  MDM_HurtNPCObjective.UnitTest()
  MDM_WaveObjective.UnitTest()
  ----------------
  --Initialize Plugins
  ----------------
  MDM_Core._Initialize()
  ----------------
  --- Missions ---
  ----------------
  MDM_Mission.UnitTest()
  MDM_TestMissions.MDM_LucasBertone()
  MDM_TestMissions.MDM_SalieriMissions()
  MDM_TestMissions.TestMissions()
  MDM_GangWarMission.UnitTest()
  MDM_ActivatorUtils.UnitTest()
  print("OK!")
end

function UnitTest.TestVector()
  print("---------------Unit Test Vector")
  local vec = MDM_Utils.GetVector(1,2,3)
  if vec.x ~= 1 or vec.y ~= 2 or vec.z ~= 3 then
    error("vector test failed",2)
  end
end

function UnitTest.TestVectorDistance()
  print("---------------Unit Test VectorDistance")
  local vec = MDM_Utils.GetVector(2,0,0)
  local vec2 = MDM_Utils.GetVector(5,0,0)
  local distance = MDM_Utils.VectorDistance(vec,vec2)

  if distance ~= 3 then
    error("expected distance is 3 but was: " ..distance)
  end
end



all()
