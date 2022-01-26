MDM_VehicleUtils = {}

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

  if not veh then
    return
  end

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
    local sCreate = "MDM_Car:new({carId = \"" ..name .."\", position = MDM_Utils.GetVector" ..cPos ..", direction = MDM_Utils.GetVector" ..cDir .."})"
    print(sCreate)
    MDM_Utils.WriteDebug(sCreate)
  end

end
