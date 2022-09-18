MDM_EntityDistanceFeature = {}

function MDM_EntityDistanceFeature:new (args)
  if args.entity == nil then
    error("entity not set",2)
  end

  if not args.entity.GetPosition == nil then
    error("entity has no GetPos function",2)
  end

  if type(args.entity.GetPosition) ~= "function" then
    error("entity.GetPos is not of type function",2)
  end

  if args.distance == nil then
    error("distance not set",2)
  end

  if type(args.distance) ~= "number" then
    error("distance is not of type number",2)
  end

  if args.warningDistance and type(args.warningDistance) ~= "number" then
    error("warningDistance is not of type number",2)
  end

  if args.callback and type(args.callback) ~= "function" then
    error("callback is not of type function",2)
  end

  local feature = MDM_Feature:new(args)
  feature.entity = args.entity
  feature.distance = args.distance
  feature.callback = args.callback
  feature.warningDistance = args.warningDistance
  feature.warningText = args.warningText
  feature.warningCallback = args.warningCallback

  feature.distanceArea = MDM_Area.ForSphere({
    position = feature.entity:GetPosition(),
    radius = feature.distance
  })


  if feature.warningDistance then
    feature.warningArea = MDM_Area.ForSphere({
      position = feature.entity:GetPosition(),
      radius = feature.warningDistance
    })
  end

  feature:OnEnabled(MDM_EntityDistanceFeature._OnEnabled)
  feature:OnDisabled(MDM_EntityDistanceFeature._OnDisabled)
  feature:OnUpdate(MDM_EntityDistanceFeature._OnUpdate)

  return feature
end

function MDM_EntityDistanceFeature._OnEnabled(self)
  self.warningPrevious = false
end


function MDM_EntityDistanceFeature._OnDisabled(self)
  if self.warningPrevious and game then
    game.hud:SendMessageMovie("HUD", "OnHideFreerideNotification")
  end
end

function MDM_EntityDistanceFeature._OnUpdate(self)
  self.distanceArea.position = self.entity:GetPosition()

  if self.warningArea then
    self.warningArea.position = self.entity:GetPosition()
  end

  local warning = self.warningArea and not MDM_Utils.Player.IsInArea(self.warningArea)

  if warning and not self.warningPrevious then
    if game and self.warningText then
      game.hud:SendMessageMovie("HUD", "OnShowFreerideNotification", self.warningText, "", 1)
    end

    if  self.warningCallback  then
      self.warningCallback()
    end
  end

  if not warning and self.warningPrevious then
    if game then
      game.hud:SendMessageMovie("HUD", "OnHideFreerideNotification")
    end
  end

  self.warningPrevious  = warning


  if not MDM_Utils.Player.IsInArea(self.distanceArea) then
    if self.callback then
      self.callback()
    end
  end
end

function MDM_EntityDistanceFeature.UnitTest()
  local count = 0
  local countWarning = 0
  local npc = MDM_NPC:new({npcId = "1234", position = MDM_Utils.GetVector(0,0,0)})

  local feature = MDM_EntityDistanceFeature:new({
    entity = npc,
    distance = 30,
    warningDistance = 20,
    callback = function() count = count + 1 end,
    warningCallback = function() countWarning = countWarning +1 end
  })

  feature:Enable()
  feature:Update()
  npc:SetPosition(MDM_Utils.GetVector(22,0,0))
  feature:Update()
  npc:SetPosition(MDM_Utils.GetVector(31,0,0))
  feature:Update()
  feature:Update()
  npc:SetPosition(MDM_Utils.GetVector(0,0,0))
  feature:Update()
  npc:SetPosition(MDM_Utils.GetVector(22,0,0))
  feature:Update()
  feature:Disable()

  if countWarning ~= 2 then
    error("countWarning should be 2 but was " ..countWarning)
  end

  if count ~= 2 then
    error("count should be 2 but was " ..count)
  end

end
