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
MDM_HostileZoneDirector = {}
MDM_HostileZoneDirector = MDM_Director:class()

local arguments = {
  position = nil,
  radius = 50,
  detectionRadius = 10,
  enemies = {},
  showArea = false
}

function MDM_HostileZoneDirector:new (args)
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

  local director = MDM_Director:new(args)
  setmetatable(director, self)
  self.__index = self

  director.args = args
  director.mapCircle = MDM_MapCircle:new(args.posistion,args.radius,4)
  director.index = 1
  director.inAreaDetector = MDM_EntityInCircleDetector:new(  {
    entity = MDM_PlayerUtils.GetPlayer(),
    position = args.position,
    radius = args.radius
  })
  return director
end

function MDM_HostileZoneDirector.Update(self)
  if not self:IsEnabled() then
    return
  end

  if not self.inAreaDetector:Test() then
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

  MDM_Director.Update(self)
end

function MDM_HostileZoneDirector.Enable(self)
  MDM_Director.Enable(self)
  if self.showArea then
    self.mapCircle:Show()
  end
end

function MDM_HostileZoneDirector.Disable(self)
  MDM_Director.Disable(self)
  self.mapCircle:Hide()
end


function MDM_HostileZoneDirector.UnitTest()
  local director = MDM_HostileZoneDirector:new({
    position = MDM_Utils.GetVector(0,0,0),
    radius = 50,
    detectionRadius = 20,
    enemies = {},
    showArea = true
  })

  director:Enable()
  director:Update()
  print(director.index)
  director:Update()
  print(director.index)
  director:Update()
  print(director.index)
  director:Update()
  print(director.index)
  director:Update()
  print(director.index)
  director:Update()
  print(director.index)
end
