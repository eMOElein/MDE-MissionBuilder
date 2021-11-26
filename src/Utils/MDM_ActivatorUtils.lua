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

-- An Activator is everything that has an Enable(self) and Disable(self) method.
MDM_ActivatorUtils = {}

-- Registers a callback to the given objective that enables the activator when the objective is started
function MDM_ActivatorUtils.EnableOnObjectiveStart(activator, objective)
  if not activator then
    error("director not set",2)
  end

  if not objective then
    error("objective not set",2)
  end
  objective:OnObjectiveStart(function() activator:Enable() end)
end

-- Registers a callback to the given objective that disables the activator when the objective is stoped
function MDM_ActivatorUtils.DisableOnObjectiveStop(activator, objective)
  objective:OnObjectiveStop(function() activator:Disable() end)
end

-- Registers callbacks to the given objective that starts the activator when the objective is started
-- and disables the activator when the objective is stopped
function MDM_ActivatorUtils.RunWhileObjective(activator,objective)
  MDM_ActivatorUtils.EnableOnObjectiveStart(activator,objective)
  MDM_ActivatorUtils.DisableOnObjectiveStop(activator,objective)
end

function MDM_ActivatorUtils.RunBetweenObjectives(activator,objectiveFrom,objectiveTo)
  MDM_ActivatorUtils.EnableOnObjectiveStart(activator,objectiveFrom)
  MDM_ActivatorUtils.DisableOnObjectiveStop(activator,objectiveTo)
end

-- Registers a callback to the given mission that enables the activator when the mission ios started
function MDM_ActivatorUtils.EnableOnMissionStart(activator, mission)
  mission:OnMissionStart(function() activator:Enable() end)
end

-- Registers a callback to the given mission that disables the activator when the mission ends
function MDM_ActivatorUtils.DisableOnMissionEnd(activator, mission)
  mission:OnMissionEnd(function() activator:Disable() end)
end

-- Registers a callback to a parent activator that enabls and deactivates the activator together with the parent activator
function MDM_ActivatorUtils.TieToActivator(activator, parentActivator)
  parentActivator:OnEnabled(function() activator:Enable() end)
  parentActivator:OnDisabled(function() activator:Disable() end)
end

function MDM_ActivatorUtils.UnitTest()
  local mission = MDM_Mission:new({title = ""})
  local objective = MDM_Objective:new({mission = mission})

  local start = false
  local finish = false

  objective:OnObjectiveStart(function() start = true end)
  objective:OnObjectiveStop(function() finish = true end)


  MDM_ActivatorUtils.RunBetweenObjectives({Enable= function() start = true end, Disable=function () finish = true end},objective,objective)

  objective:Start()

  if  not start then
    error("start should be set")
  end

  if  finish then
    error("finish should not be set")
  end

  objective:Stop()

  if  not finish then
    error("finish should be set")
  end

end
