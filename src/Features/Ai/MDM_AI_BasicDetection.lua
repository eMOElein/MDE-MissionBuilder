MDM_AI_BasicDetection = {}
MDM_AI_BasicDetection = MDM_Feature:class()

MDM_AI_BasicDetection.FAIL_DISTANCE_AREA = "fail distance"
MDM_AI_BasicDetection.FAR_DISTANCE_AREA = "far distance"
MDM_AI_BasicDetection.NORMAL_DISTANCE_AREA = "normal distance"
MDM_AI_BasicDetection.WARN_DISTANCE_AREA = "warn distance"

function MDM_AI_BasicDetection:new(args)
  local detectionAi = MDM_Feature:new(args)
  setmetatable(detectionAi, self)
  self.__index = self

  if not args.positionSupplier then
    error("positionSupplier not set",2)
  end


  if not args.positionSupplier() then
    error("position supplier returns nil",2)
  end


  detectionAi._playerPosSupplier = MDM_Utils.Player.GetPos
  detectionAi:OnUpdate(MDM_AI_BasicDetection._OnUpdate)
  detectionAi:OnEnabled(MDM_AI_BasicDetection._OnEnabled)

  detectionAi.detected = false
  detectionAi.onDetectedCallbacks = MDM_List:new()
  detectionAi.onDistanceAreaChangedCallbacks = MDM_List:new()

  detectionAi.positionSupplier = args.positionSupplier
  detectionAi.failArea = MDM_Area.ForSphere({position = detectionAi.positionSupplier(), radius = args.failDistance or 5})
  detectionAi.warnArea = MDM_Area.ForSphere({position = detectionAi.positionSupplier(), radius = args.warnDistance or 20})
  detectionAi.normalArea = MDM_Area.ForSphere({position = detectionAi.positionSupplier(), radius = args.normalDistance or 50})

  if args.onDistanceAreaChanged then
    detectionAi:OnDistanceAreaChanged(args.onDistanceAreaChanged)
  end

  if args.onDetected then
    detectionAi:OnDetected(args.onDetected)
  end

  return detectionAi
end

function MDM_AI_BasicDetection._OnDetected(self)
  self.detected = true
  self.onDetectedCallbacks:ForEach(function(callback) callback() end)
end

function MDM_AI_BasicDetection._GetcurrentDistanceArea(self)
  local aiPositionVector = self.positionSupplier()
  local playerPos = self._playerPosSupplier()

  if self.failArea:IsInside(playerPos) then
    return MDM_AI_BasicDetection.FAIL_DISTANCE_AREA
  end

  if self.warnArea:IsInside(playerPos) then
    return MDM_AI_BasicDetection.WARN_DISTANCE_AREA
  end

  if self.normalArea:IsInside(playerPos) then
    return MDM_AI_BasicDetection.NORMAL_DISTANCE_AREA
  end

  return MDM_AI_BasicDetection.FAR_DISTANCE_AREA
end

function MDM_AI_BasicDetection._OnUpdate(self)
  if self.detected then
    return
  end

  local position = self.positionSupplier()
  --  print("Use Position " ..position.x .."," ..position.y .."," ..position.z)

  self.failArea:SetPosition(position)
  self.warnArea:SetPosition(position)
  self.normalArea:SetPosition(position)

  local currentDistanceArea = self:_GetcurrentDistanceArea()
  local previousDistanceArea = self.previousDistanceArea

  if currentDistanceArea ~= previousDistanceArea then
    self.onDistanceAreaChangedCallbacks:ForEach(function(callback) callback(self,currentDistanceArea,previousDistanceArea) end)

    if currentDistanceArea == MDM_AI_BasicDetection.FAIL_DISTANCE_AREA then
      self:_OnDetected()
    end
  end

  self.previousDistanceArea = currentDistanceArea
end

function MDM_AI_BasicDetection._OnEnabled(self)
  self.previousDistanceArea = nil
end

function MDM_AI_BasicDetection.OnDistanceAreaChanged(self, callback)
  self.onDistanceAreaChangedCallbacks:Add(callback)
end

function MDM_AI_BasicDetection._OnDistanceAreaChanged(self, currentDistanceArea, previousDistanceArea)
end

function MDM_AI_BasicDetection.OnDetected(self, callback)
  self.onDetectedCallbacks:Add(callback)
end

function MDM_AI_BasicDetection.UnitTest()
  local npc = MDM_NPC:new({npcId = "", position = MDM_Vector:new(0,0,0)})
  local distanceChanges = 0
  local playerPos = MDM_Vector:new(0,0,0)
  local detected = false

  local ai = MDM_AI_BasicDetection:new({
    positionSupplier = function() return npc:GetPosition() end,
    onDistanceAreaChanged = function(self, newDistance, oldDistance) distanceChanges = distanceChanges + 1 end,
    onDetected = function() detected = true end
  })

  ai.positionSupplier = function() return playerPos end

  ai:Enable()
  playerPos.x =  51
  ai:Update()
  playerPos.x =  50
  ai:Update()
  playerPos.x =  20
  ai:Update()
  playerPos.x =  1
  ai:Update()
  playerPos.x =  50 -- should not trigger a callback as we are already detected here
  ai:Update()
  ai:Disable()

  if distanceChanges ~= 4 then
    error("distanceChanges expected 4 but was " ..distanceChanges)
  end

  if not detected then
    error("detected should be true but was " ..tostring(detected))
  end
end
