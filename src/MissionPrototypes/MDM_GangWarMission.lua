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

MDM_GangWarMission = {}

function MDM_GangWarMission.GangWarConfiguration()
  local configuration = {}
  configuration.title = "Gang War"
  configuration.carAssets = {}
  configuration.allyNpcs = {} -- optional use MDM_NPC:newFriend for creation otherwise they might atack you
  configuration.waves = {} -- OBLIGATORY
  configuration.initialPosition = nil -- OBLIGATORY

  return configuration
end

function MDM_GangWarMission:new(GangWarConfiguration)
  local config = GangWarConfiguration

  if  type(config.waves) ~= "table" then
    error("waves is not of type table",2)
  end

  if not config.initialPosition then
    error("initial position not set",2)
  end

  local mission = MDM_Mission:new(config)
  mission:SetStartPos(config.initialPosition)

  for _,car in ipairs(config.carAssets) do
    car:SetIndestructable(true)
  end

  for _,npc in ipairs(config.allyNpcs) do
    npc:Godmode(true)
  end

  for i,wave in ipairs(config.waves) do
    wave.mission = mission

    if wave.restorePlayer then
      mission:AddObjective(MDM_RestorePlayerObjective:new())
    end

    mission:AddObjective(MDM_WaveObjective:new(wave))
  end

  mission:OnMissionStart(function()
    MDM_PoliceUtils.DisablePolice()

    for i,car in ipairs(config.carAssets) do
      car:SetIndestructable(true)
      car:Spawn()
    end

    for i,ally in ipairs(config.allyNpcs) do
      ally:OnSpawned(
        function()
          ally:MakeAlly(true)
          MDM_NPCUtils.EquipTommygun(ally) end)
      ally:Godmode(true)
      ally:Spawn()
    end
  end)

  mission:OnMissionEnd(function ()
    MDM_PoliceUtils.EnablePolice()
    for i,ally in ipairs(config.allyNpcs) do
      ally:MakeAlly(false)
      ally:Godmode(false)
    end
  end)

  mission:AddAssets(config.carAssets)
  mission:AddAssets(config.allyNpcs)
  return mission
end

function MDM_GangWarMission.UnitTest()
  local mission = TestMissions.GangWarTest()
  mission:Start()
end
