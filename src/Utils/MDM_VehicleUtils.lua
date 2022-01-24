MDM_VehicleUtils = {}

local VehExplosionEnabled = false
local VehiclePrimaryColor = "1"
local VehicleSecondaryColor = "1"
local TirePrimaryColor = "1"
local TireSecondaryColor = "1"
local WindowTintColor = "1"
local VehicleLightState = false
local VehicleSirenState = false
local HandlingMult = "0"
local EngineStateValue = false
local DirtLevel = "0"
local RustLevel = "0"
local VehicleSPZText = "000000"
local DespawnImmunityValue = false
local DamageImmunityValue = "0"
local CarTuneValue = false
local FrontWheels = "wheel_civ04"
local RearWheels = "wheel_civ04"
local SteeringPlayAmmount = "0"
local SteeringOffsetValue = "0"
local WindowFrontLeft = false
local WindowFrontRight = false
local WindowBackLeft = false
local WindowBackRight = false
local TeleportEnabled = true
local RadioState = false
local BulletProofTiresValue = true
local trailer = {}
local HoodOpen = false
local TrunkOpen = false
local PrimaryColors = {0,0,0,0}
local SecondaryColors = {0,0,0,0}
local WindowTint = {0,0,0,20}
local ChromeValue = 0
local GlossValue = 100

function MDM_VehicleUtils.EasySpawn(Vehicle, Pos, Dir)
  local so, id = game.traffic:ObtainSpecificCar(Vehicle)
  Wait(so)
  local so = game.traffic:SpawnCar(id, Pos, Dir)
  Wait(so)
  return id
end

function MDM_VehicleUtils.AdvancedCarSpawner(caller, callback, Vehicle, Pos, Dir)
  local so, id = game.traffic:ObtainSpecificCar(Vehicle)
  local veh
  StartThread(function ()
    Wait(so)

    local    SpawnPos = Pos
    local    SpawnDir = Dir or MDM_Utils.GetVector(-0,000001,-0.000004,0.000150)
    SpawnPos.x = SpawnPos.x --+ (SpawnDir.x * 3)
    SpawnPos.y = SpawnPos.y -- + (SpawnDir.y * 3)

    local so = game.traffic:SpawnCar(id, SpawnPos, SpawnDir)
    Wait(so)

    veh = game.traffic:GetSpawnedEntity(id)
    --   GetPlayer():MakeCarOwnership(veh)
    --   veh:SetWheelColor(tonumber(TirePrimaryColor), tonumber(TireSecondaryColor))
    veh:SetWindowTint(tonumber(WindowTintColor))
    --    veh:SetLightState(true, VehicleLightState)
    veh:SetSirenOn(VehicleSirenState)
    veh:SetSlowMotionAssist(tonumber(HandlingMult))
    veh:DisableExplosion(VehExplosionEnabled)
    veh:SetEngineOn(EngineStateValue, EngineStateValue)
    veh:SetDirty(tonumber(DirtLevel))
    veh:SetRust(tonumber(RustLevel))
    veh:SetActualFuel(100)
    --    veh:SetSPZText(VehicleSPZText, true)
    veh:SetDespawnImmunity(DespawnImmunityValue)
    veh:SetResistance(tonumber(DamageImmunityValue))
    veh:SetMotorBadTune(CarTuneValue)
    --    veh:SetWheel(1, FrontWheels)
    --    veh:SetWheel(2, RearWheels)
    veh:SetSteeringPlay(tonumber(SteeringPlayAmmount))
    veh:SetAddSteer(tonumber(SteeringOffsetValue))
    veh:SetWheelsProtected(BulletProofTiresValue)
    --    game.radio:SetOn(veh, RadioState)
    local  WindowCount = veh:GetSeatCount()
    if WindowCount == 2 then
      veh:OpenSeatWindow(1, WindowFrontLeft, false)
      veh:OpenSeatWindow(2, WindowFrontRight, false)
    elseif WindowCount == 4 then
      veh:OpenSeatWindow(1, WindowFrontLeft, false)
      veh:OpenSeatWindow(2, WindowFrontRight, false)
      veh:OpenSeatWindow(3, WindowBackLeft, false)
      veh:OpenSeatWindow(4, WindowBackRight, false)
    end

    if HoodOpen == true then
      veh:OpenHood()
    end
    if TrunkOpen == true then
      veh:OpenTrunk()
    end
    --   veh:OverrideMaterialParam("C060", (PrimaryColors[1]/255), (PrimaryColors[2]/255), (PrimaryColors[3]/255), 1)
    --  veh:OverrideMaterialParam("C061", (SecondaryColors[1]/255), (SecondaryColors[2]/255), (SecondaryColors[3]/255), 1)
    veh:OverrideMaterialParam("C005", (WindowTint[1]/255), (WindowTint[2]/255), (WindowTint[3]/255), (WindowTint[4]/255))
    veh:OverrideMaterialParam("D112", 1, (ChromeValue/100))
    veh:OverrideMaterialParam("D370", 0, (GlossValue/100))

    if callback then
      callback(caller, id, so,veh)
    end
    return
  end)
end

function MDM_VehicleUtils.GetPlayerCurrentVehicle()
  local Player = game.game:GetActivePlayer()

  if not Player then
    return nil
  end

  local Vehicle = Player:GetOwner()

  if not Vehicle then
    Vehicle = Player:GetOwnerSceneObject()
  end

  if not Vehicle then
    return nil
  end

  return Vehicle
end

function MDM_VehicleUtils.Info()
  print("PrintInfos" .. tostring(MDM_VehicleUtils.GetPlayerCurrentVehicle()))
  local veh = MDM_VehicleUtils.GetPlayerCurrentVehicle()

  local pos = veh:GetPos()
  local dir = veh:GetDir()
  local name = veh:GetName()
  local color = tostring(veh:GetColor(1)) .."/" ..tostring(veh:GetColor(2))
  local painting = tostring(veh:GetPainting())

  if veh then
    print("-----------Vehicle--------------")
    print("Name: " ..tostring(veh:GetName()))
    print("Pos: " ..tostring(pos))
    print("Dir: " ..tostring(dir))
    --    print("Car Damage: " ..tostring(veh:GetDamage()))
    --    print("Motor Damage: " ..tostring(veh:GetMotorDamage()))
    --    print("Speed: " ..tostring(veh:GetSpeed()))
    print("Color: " ..color)
    print("Painting: " ..painting)
    --   veh:SetColor(38,21)




    MDM_Utils.WriteDebug("Name: " .. name)
    MDM_Utils.WriteDebug("Pos: (" ..pos.x .."," .. pos.y .. "," .. pos.z .. ")")
    MDM_Utils.WriteDebug("Dir: (" ..dir.x .."," .. dir.y .. "," .. dir.z .. ")")

    local cPos = "(" ..pos.x .."," .. pos.y .. "," .. pos.z .. ")"
    local cDir = "(" ..dir.x .."," .. dir.y .. "," .. dir.z .. ")"
    local sCreate = "MDM_Car:new(\"" ..name ..", MDM_Utils.GetVector" ..cPos ..", MDM_Utils.GetVector" ..cDir ..")"
    print(sCreate)
    MDM_Utils.WriteDebug(sCreate)
  end

end
