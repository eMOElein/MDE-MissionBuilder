MDM_PlayerUtils = {}

function MDM_PlayerUtils.PrintPosition()
  local pos = getp():GetPos()
  local dir = getp():GetDir()

  local sOut = "Pos: (" ..pos.x .."," ..pos.y .."," ..pos.z ..") Dir: (" ..dir.x .."," ..dir.y .."," ..dir.z ..")"
  print(sOut)
  MDM_Utils.WriteDebug(sOut)

  sOut = game.outfits:GetCurrentOutfit()
  MDM_Utils.WriteDebug("Outfit: " .. tostring(sOut))

  local pPos = "(" ..pos.x .."," ..pos.y .."," ..pos.z ..")"
  local pDir = "(" ..dir.x .."," ..dir.y .."," ..dir.z ..")"
  local sCreate = "{npcId = \"000000000000\", position = MDM_Vector:new" ..pPos ..", direction = MDM_Vector:new" ..pDir .."}"
  print(sCreate)
  MDM_Utils.WriteDebug(sCreate)
end

function MDM_PlayerUtils.GetPlayer()
  if game then
    return getp()
  else
    local p = {
      pos = MDM_Utils.GetVector(0,0,0),
      dir = MDM_Utils.GetVector(0,0,0)
    }
    p.SetPos = function (pos) p.pos = pos end
    p.GetPos = function () return p.pos end
    p.GetDir = function () return p.dir end

    return p
  end
end

function MDM_PlayerUtils.GetPos()
  if game then
    return MDM_PlayerUtils.GetPlayer():GetPos()
  else
    return MDM_Vector:new(0,0,0)
  end
end

function MDM_PlayerUtils.IsInArea(area)
  return area:IsInside(MDM_PlayerUtils.GetPlayer():GetPos())
end

function MDM_PlayerUtils.IsInCar(car)
  local currentVehicle =  MDM_VehicleUtils.GetPlayerCurrentVehicle()

  if not car and currentVehicle ~= nil then
    return true
  end

  if car and car:GetGameEntity() == currentVehicle then
    return true
  end

  return false
end

function MDM_PlayerUtils.RestorePlayer()
  if game then
    local player = getp()
    player:SetMaxHealth()

    player:InventoryLoadWeapons()
    player:InventoryAddAmmoByCategory(71, 2) -- Refresh Molotov
    player:InventoryAddGrenades(2)
  end
end
