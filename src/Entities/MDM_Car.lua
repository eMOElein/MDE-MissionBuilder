MDM_Car = {}
MDM_Car = MDM_Entity:class()

function MDM_Car.ForConfigs(configs)
  if not configs then
    error("confifgs not set",2)
  end

  if #configs == 0 then
    error("configs has no elements",2)
  end

  local list = MDM_List:new(configs):Map(function(config) return MDM_Car:new(config) end)

  if not list then
    error("internal error list should not be nil",2)
  end

  return list
end

function MDM_Car:new(args, dummyPos, dummyDir)
  -- convert old constructor parameters into argument table
  if type(args) == "string" then
    local tempId = args
    args = {
      carId = tempId,
      position = dummyPos,
      direction = dummyDir
    }
  end

  local car = MDM_Entity:new(args.position,args.direction)
  setmetatable(car, self)
  self.__index = self

  if not args.carId then
    error("carId not set",2)
  end

  if type(args.carId) ~= "string" then
    error("carId not of type string",2)
  end

  if args.position == nil then
    error("no position",2)
  end

  if args.direction == nil then
    error("no direction",2)
  end

  car.args = args
  car.carId = args.carId
  car.game_id = nil
  car.spawning = false
  car.spawned = false
  car.position = args.position
  car.direction = args.direction
  car.indestructable = args.indestructable
  car.lightsOn = args.lightsOn

  return car
end

function MDM_Car.CanDrive(self)
  return self:GetCarDamage() < 100 and self:GetMotorDamage() < 100
end

function MDM_Car.GetCarDamage(self)
  local veh = MDM_Entity.GetGameEntity(self)
  if veh then
    return veh:GetDamage()
  end
  return 0
end

function MDM_Car.GetMotorDamage(self)
  local veh = self:GetGameEntity()
  if veh then
    return veh:GetMotorDamage()
  end
  return 0
end

local function _SpawnCar(self,args)
  local so, id = game.traffic:ObtainSpecificCar(args.carId)
  StartThread(function ()
    Wait(so)

    local so = game.traffic:SpawnCar(id, args.position, args.direction)
    Wait(so)

    local carEntity = game.traffic:GetSpawnedEntity(id)

    if args.callback then
      args.callback(self,{guid = id, so = so, game_entity = carEntity})
    end
    return
  end)
end

function MDM_Car.OnGameEntitySpawned(self,args)
  self.game_id = args.guid
  self.spawning = false
  self.spawned = true
  self:SetGameEntity(args.game_entity)
  self.sceneObject = args.so

  if self.args.primaryColorRGB then
    self:SetPrimaryColorRGB(self.args.primaryColorRGB[1], self.args.primaryColorRGB[2], self.args.primaryColorRGB[3])
  end

  if args.game_entity then
    if self.primaryColor then
      self:SetPrimaryColorRGB(self.primaryColor.r, self.primaryColor.g, self.primaryColor.b)
    end
    self:SetIndestructable(self.indestructable)
    self:SetLightsOn(self.lightsOn)
  end
end

function MDM_Car.IsEngineOn(self)
  local gameEntity = self:GetGameEntity()

  if not gameEntity then
    return false
  end

  return gameEntity:IsEngineOn()
end

function MDM_Car.SetLightsOn(self, bool)
  self.lightsOn = bool

  local gameEntity = self:GetGameEntity()
  if gameEntity then
    gameEntity:SetLightState(true, self.lightsOn)
  end
end

function MDM_Car.Spawn(self)
  if self.spawning then
    return
  end

  self.spawning = true


  --  local callback = function (self, id, so, veh)
  --    self.game_id = id
  --    self.spawning = false
  --    self.spawned = true
  --    self:SetGameEntity(veh)
  --
  --    if veh and self.self.primaryColor then
  --      self:SetPrimaryColorRGB(self.primaryColor.r, self.primaryColor.g, self.primaryColor.b)
  --    end
  --  end

  if game then
    StartThread(function()



        -- MDM_VehicleUtils.AdvancedCarSpawner( self, self.OnGameEntitySpawned, self.carId, self.spawnPos, self.spawnDir)
        _SpawnCar(self,{
          carId = self.carId,
          position = self.position,
          direction = self.direction,
          callback = self.OnGameEntitySpawned
        })
    end)
  else
    self.spawning = false
    self.spawned = true
  end
end

function MDM_Car.Despawn(self)
  local entity = self:GetGameEntity()
  if entity  then
    if entity.SetPreventCleaning ~= nil then
      entity:SetPreventCleaning(false)
    end
    if entity.Deactivate ~= nil then
      entity:Deactivate()
    end
  end
end

function MDM_Car.GetDirection(self)
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
  if not bool then bool = false end

  self.indestructable = bool

  local gameEntity = self:GetGameEntity()
  if gameEntity then
    gameEntity:DisableExplosion(bool)
  end
end

function MDM_Car.SetPrimaryColorRGB(self,r,g,b)
  self.args.primaryColorRGB = {r,g,b}

  local veh = self:GetGameEntity()
  if game and veh then
    veh:OverrideMaterialParam("C060", (r/255), (g/255), (b/255), 1)
  end
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
