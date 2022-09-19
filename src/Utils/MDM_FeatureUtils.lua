MDM_FeatureUtils = {}

-- Registers a callback to the given objective that enables the feature when the objective is started
function MDM_FeatureUtils.EnableOnObjectiveStart(feature, objective)
  if not feature then
    error("director not set",2)
  end

  if not objective then
    error("objective not set",2)
  end
  objective:OnObjectiveStart(function() feature:Enable() end)
  objective:GetMission():OnMissionEnd(function() feature:Disable() end)
end

-- Registers a callback to the given objective that disables the feature when the objective is stoped
function MDM_FeatureUtils.DisableOnObjectiveStop(feature, objective)
  objective:OnObjectiveStop(function() feature:Disable() end)
end

function MDM_FeatureUtils.EnableOnObjectiveEnd(feature, objective)
  objective:OnObjectiveStop(function() feature:Enable() end)
end

-- Registers callbacks to the given objective that starts the feature when the objective is started
-- and disables the feature when the objective is stopped
function MDM_FeatureUtils.RunWhileObjective(feature,objective)
  MDM_FeatureUtils.EnableOnObjectiveStart(feature,objective)
  MDM_FeatureUtils.DisableOnObjectiveStop(feature,objective)
end

function MDM_FeatureUtils.RunBetweenObjectives(feature,objectiveFrom,objectiveTo)
  MDM_FeatureUtils.EnableOnObjectiveStart(feature,objectiveFrom)
  MDM_FeatureUtils.DisableOnObjectiveStop(feature,objectiveTo)
end

-- Registers a callback to the given mission that enables the feature when the mission ios started
function MDM_FeatureUtils.EnableOnMissionStart(feature, mission)
  mission:OnMissionStart(function() feature:Enable() end)
end

-- Registers a callback to the given mission that disables the feature when the mission ends
function MDM_FeatureUtils.DisableOnMissionEnd(feature, mission)
  mission:OnMissionEnd(function() feature:Disable() end)
end

-- Registers a callback to a parent feature that enabls and deactivates the feature together with the parent feature
function MDM_FeatureUtils.TieToFeature(feature, parentfeature)
  parentfeature:OnEnabled(function() feature:Enable() end)
  parentfeature:OnDisabled(function() feature:Disable() end)
end

function MDM_FeatureUtils.RunWhileEntitySpawned(feature, entity)
  entity:OnEntityDespawned(function() feature:Disable() end)
  entity:OnEntitySpawned(function() feature:Enable() end)

  if entity:IsSpawned() then
    feature:Enable()
  end
end

function MDM_FeatureUtils.UnitTest()
  local mission = MDM_Mission:new({title = ""})
  local objective = MDM_Objective:new({mission = mission})

  local start = false
  local finish = false

  objective:OnObjectiveStart(function() start = true end)
  objective:OnObjectiveStop(function() finish = true end)


  MDM_FeatureUtils.RunBetweenObjectives({Enable= function() start = true end, Disable=function () finish = true end},objective,objective)

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
