MDM_NPCUtils = {}

function MDM_NPCUtils.RemoveMelee(npc)
  local ent = npc:GetGameEntity()

  local func = function()
    local ent = npc:GetGameEntity()

    if ent then
      print("Removing Weapons:")
      ent:InventoryRemoveWeapon("wep_baseball_bat_a_v1")
      ent:InventoryRemoveWeapon("wep_knife_a_v1")
      ent:InventoryRemoveWeapon("Crowbar")
      ent:InventoryRemoveWeapon("wep_metal_bar_a_v1")
      ent:InventoryRemoveWeapon("wep_knuckle_a_v1")
      ent:InventoryRemoveWeapon("wep_wooden_plank_a_v1")
    end
    print("Removing Done")
  end

  if ent then
    print"Remove Immediate"
    func()
  else
    print"Remove On Spawn"
    npc:OnSpawned(func)
  end

end

function MDM_NPCUtils.MakeHostileIfInRadius(npcPlayer, npcEnemy, radius)
  if not MDM_Entity.IsSpawned(npcPlayer) or not MDM_Entity.IsSpawned(npdPlayer)then
    return
  end

  local distance = MDM_Utils.GetDistance(npcPlayer:GetPos(), npcEnemy:GetPos())
  if distance <= radius then
    npcEnemy:AttackPlayer()
  end
end

function MDM_NPCUtils.EquipTommygun(npc)
  local weapon = "smg_trench_a_v1"
  local ent = npc:GetGameEntity()

  local func = function()
    local ent = npc:GetGameEntity()

    if ent then

      local curWeapon  = ent:InventoryGetSelected()
      if curWeapon ~= "empty" then
        ent:InventoryRemoveWeapon(curWeapon)
      end
      ent:InventoryAddWeapon(weapon, 150)
      ent:InventorySelect(weapon, true)
    end
  end

  if ent then
    func()
  else
    npc:OnSpawned(func)
  end
end
