MDM_HostileZoneFeature = {}

function MDM_HostileZoneFeature:new (args)
  if not args then
    error("args not set",2)
  end

  if not args.position then
    error("position not set",2)
  end

  if not args.enemies then
    error("enemies not set",2)
  end

  if #args.enemies == 0 then
    print("WARN: enemies list is empty",2)
  end

  local director = MDM_Feature:new(args)

  director.args = args
  director.index = 1
  director.radius = args.radius or 50
  director.area = MDM_Area.ForSphere({
    position = args.position,
    radius = director.radius
  })

  director:OnEnabled(MDM_HostileZoneFeature._OnEnabled)
  director:OnDisabled(MDM_HostileZoneFeature._OnDisabled)
  director:OnUpdate(MDM_HostileZoneFeature._OnUpdate)

  return director
end

function MDM_HostileZoneFeature._OnUpdate(self)
  if not MDM_Utils.Player.IsInArea(self.area) then
    return
  end

  local enemy = self.args.enemies[self.index]
  if enemy then
    local gameEntity = enemy:GetGameEntity(self)
    if gameEntity then
      if MDM_Utils.VectorDistance(gameEntity:GetPos(),MDM_PlayerUtils.GetPlayer():GetPos()) < self.args.detectionRadius then
        if gameEntity:GetSeePlayer() then
          enemy:AttackPlayer()
        end
      end
    end
  end

  self.index = self.index + 1
  if self.index > #self.args.enemies then
    self.index = 1
  end
end

function MDM_HostileZoneFeature._OnEnabled(self)
  if self.showArea and self.area then
    self.area:Show()
  end
end

function MDM_HostileZoneFeature._OnDisabled(self)
  MDM_Feature.Disable(self)

  if self.area then
    self.area:Hide()
  end
end


function MDM_HostileZoneFeature.UnitTest()
  local director = MDM_HostileZoneFeature:new({
    position = MDM_Utils.GetVector(0,0,0),
    radius = 50,
    detectionRadius = 20,
    enemies = {
      MDM_NPC:new({npcId="",position=MDM_Utils.GetVector(0,0,0),direction=MDM_Utils.GetVector(0,0,0)}),
      MDM_NPC:new({npcId="",position=MDM_Utils.GetVector(0,0,0),direction=MDM_Utils.GetVector(0,0,0)}),
      MDM_NPC:new({npcId="",position=MDM_Utils.GetVector(0,0,0),direction=MDM_Utils.GetVector(0,0,0)})
    },
    showArea = true
  })

  director:Enable()
  director:Update()
  director:Update()
  director:Update()
  director:Update()
  director:Update()
  director:Update()
end
