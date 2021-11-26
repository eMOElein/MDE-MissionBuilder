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

MDM_SpawnManager = {}

local despawns = {}

function MDM_SpawnManager.MarkForRadiusDespawn(spawnable, radius)
  if not spawnable then
    error("spawnable not set",2)
  end

  if not radius then
    error("radius not set",2)
  end

  table.insert(despawns,{spawnable = spawnable, evaluator = function() return MDM_Utils.DistanceToPlayer(spawnable) > radius end})
end

function MDM_SpawnManager.MarkForFunctionDespawn(spawnable, evaluator)
  table.insert(despawns,{spawnable = spawnable, evaluator = evaluator})
end

function MDM_SpawnManager.MarkForTimeDespawn(spawnable, time)
--TODO: Despawn after X milliseconds
end

function MDM_SpawnManager.Update()
  for index,despawn in ipairs(despawns) do
    local eval = despawn.evaluator()
    local spawnable = despawn.spawnable
    if eval and spawnable:IsSpawned() then
      spawnable:Despawn()
    end
  end
end
