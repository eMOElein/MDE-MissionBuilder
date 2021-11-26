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

MDM_PoliceUtils = {}

function MDM_PoliceUtils.SetWantedLevel(Level)
  if game then
    game.police:ZoneDeleteAll()
    if(Level > 0) then
      game.police:ZoneCreate(getp():GetPos(), enums.PoliceZoneType.HUNT, Level)
    end
  end
end

function MDM_PoliceUtils.LockWantedLevel()
  game.police:PreventZonesDecay(true)
end

function MDM_PoliceUtils.UnlockWantedLevel()
  if game then
    game.police:PreventZonesDecay(false)
  end
end


function MDM_PoliceUtils.IsPlayerHunted()
  local zoneInfo = game.police:GetZoneInfo(0)
  if(zoneInfo.x == 0 and zoneInfo.x == 0)then
    return false
  else
    return true
  end
end

function MDM_PoliceUtils.DisablePolice()
  if game then
    game.police:Disable()
  end
end

function MDM_PoliceUtils.EnablePolice()
  if game then
    game.police:Enable()
  end
end

function MDM_PoliceUtils.PrintZones()
  if game.police:GetActiveZones( ) then
    print("Active Zones:  " ..tostring(game.police:GetActiveZones()))
  end

  local zoneInfo = game.police:GetZoneInfo(0)
  print("GetZoneInfor:  " ..tostring(zoneInfo))
  print("ZoneInfioX: " ..tostring(zoneInfo.x))
  print("PlayerHunted: " ..tostring(MDM_PoliceUtils.IsPlayerHunted()))

  game.police:PersistentPoliceStartSpawningFromPos(Utils_GetVector(-907.94,-180.41,2))
end
