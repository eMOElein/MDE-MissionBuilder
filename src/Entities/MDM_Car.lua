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

MDM_Car = {}
MDM_Car = MDM_Entity:class()

local arguments = {
  carId = nil,
  direction = nil,
  position = nil,
  primaryColors = nil,
  secondaryColors = nil
}

function MDM_Car:new(carId,pos,dir)
  return MDM_Car:newArgs({
    carId = carId,
    position = pos,
    direction = dir
  })
end

function MDM_Car:newArgs(args)
  local car = MDM_Entity:new(args.position,args.direction)
  setmetatable(car, self)
  self.__index = self

  if args.carId ~= nil and type(args.carId) ~= "string" then
    error("no carId",2)
  end

  car.args = args
  car.carId = args.carId
  car.game_id = nil
  car.spawning = false
  car.spawned = false
  car.spawnPos = args.position
  car.spawnDir = args.direction
  car.indestructableFlag = false

  --math.randomseed(os.clock())
  --  car.primaryColor = {r=math.random(), g=math.random(), b=math.random()}

  return car
end

function MDM_Car.GetCarDamage(self)
  local veh = MDM_Entity.GetGameEntity(self)
  if veh then
    return veh:GetDamage()
  end
  return
end

function MDM_Car.GetMotorDamage(self)
  local veh = self:GetGameEntity()
  if veh then
    return veh:GetMotorDamage()
  end
  return
end

function MDM_Car.OnGameEntitySpawned(self, id, so, game_entity)
  self.game_id = id
  self.spawning = false
  self.spawned = true
  self:SetGameEntity(game_entity)

  if self.args.primaryColor then
    self:SetPrimaryColor(self.args.primaryColor[1], self.args.primaryColor[2], self.args.primaryColor[3])
  end

  if game_entity then
    if self.primaryColor then
      self:SetPrimaryColor(self.primaryColor.r, self.primaryColor.g, self.primaryColor.b)
    end
    self:SetIndestructable(self.indestructableFlag)
  end
end

function MDM_Car.Spawn(self)
  if self.spawning then
    return
  end

  self.spawning = true


  local callback = function (self, id, so, veh)
    self.game_id = id
    self.spawning = false
    self.spawned = true
    self:SetGameEntity(veh)

    if veh and self.self.primaryColor then
      self:SetPrimaryColor(self.primaryColor.r, self.primaryColor.g, self.primaryColor.b)
    end
  end

  if game then
    StartThread(function()
      MDM_VehicleUtils.AdvancedCarSpawner( self, self.OnGameEntitySpawned, self.carId, self.spawnPos, self.spawnDir)
    end)
  else
    self.spawning = false
    self.spawned = true
  end
end

function MDM_Car.Despawn(self)
  local entity = self:GetGameEntity()
  if entity then
    entity:SetPreventCleaning(false)
    entity:Deactivate()
  end
end

function MDM_Car.GetDir(self)
  local veh = self:GetGameEntity()
  if veh then
    return veh:GetDir()
  end
end

function MDM_Car.IsSpawned(self)
  return self.spawned
end

function MDM_Car.IsSpawning(self)
  return self.spawning
end

function MDM_Car.SetSpawnPos(self,pos)
  self.spawnPos = pos
end

function MDM_Car.SetpawnDir(self,dir)
  self.spawnDir = dir
end

function MDM_Car.Explode(self)
  local veh = self:GetGameEntity()
  if game and veh then
    veh:Explode()
  end
end

function MDM_Car.IsSpawned(self)
  return MDM_Entity.IsSpawned(self)
end

function MDM_Car.SetIndestructable(self,bool)
  self.indestructableFlag = bool

  local gameEntity = self:GetGameEntity()
  if gameEntity then
    gameEntity:DisableExplosion(bool)
  end
end

function MDM_Car.SetPrimaryColor(self,r,g,b)
  self.args.primaryColor = {r,g,b}

  local veh = self:GetGameEntity()
  if game and veh then
    veh:OverrideMaterialParam("C060", (r/255), (g/255), (b/255), 1)
  end
end

function MDM_Car.UnitTest()
  print("---------------MDM_Car:UnitTest")
  local car = MDM_Car:new("falconer_classic",MDM_Utils.GetVector(-907.94,-210.41,2),MDM_Utils.GetVector(-907.94,-210.41,2))
  car:Spawn()
  car:Despawn()

end

function MDM_Car.IsPlayerInCar(self)
  if not self.spawned or self.spawning then
    return false
  end

  local veh = self.game_id
  if not veh then
    return false
  end

  local pVeh = MDM_VehicleUtils.GetPlayerCurrentVehicle()

  if not veh or not pVeh then
    return false
  end

  veh = game.traffic:GetSpawnedEntity(veh)
  if pVeh and veh then
    if veh:GetGUID() == pVeh:GetGUID() then
      return true
    end
  end
  return false
end
