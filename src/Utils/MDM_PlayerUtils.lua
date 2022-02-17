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
  local sCreate = "MDM_NPC:new({npcId = \"000000000000\", position = MDM_Utils.GetVector" ..pPos ..", direction = MDM_Utils.GetVector" ..pDir .."})"
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

function MDM_PlayerUtils.RestorePlayer()
  if game then
    local player = getp()
    player:SetMaxHealth()

    player:InventoryLoadWeapons()
    player:InventoryAddAmmoByCategory(71, 2) -- Refresh Molotov
    player:InventoryAddGrenades(2)
  end
end
