MDM_GangWarMission = {}

function MDM_GangWarMission:new(args)
  if args.waves == nil then
    error("waves not set",2)
  end

  if  type(args.waves) ~= "table" then
    error("waves is not of type table",2)
  end

  if not args.startPosition then
    error("startPosition not set",2)
  end

  local mission = MDM_Mission:new(args)
  local carAssets = {}
  local allyNpcs = {}

  if args.carAssets ~= nil then
    for _,c in ipairs(args.carAssets) do
      local car = MDM_Car:new(c)
      car:SetIndestructable(true)
      table.insert(carAssets,car)
      mission:AddAsset(car)
    end
  end

  if args.allyNpcs ~= nil then
    for _,n in ipairs(args.allyNpcs) do
      local npc = MDM_NPC:newFriend(n)
      npc:Godmode(true)
      table.insert(allyNpcs,npc)
      mission:AddAsset(npc)
    end
  end

  for _,wave in ipairs(args.waves) do
    local waveEnemies = {}

    for _,e in ipairs(wave.enemies) do
      local enemy = MDM_NPC:new(e)
      enemy:AttackPlayer()
      table.insert(waveEnemies,enemy)
      mission:AddAsset(enemy)
    end

    if wave.restorePlayer then
      mission:AddObjective(MDM_RestorePlayerObjective:new())
    end

    if wave.preparationTime ~= nil and wave.preparationTime > 0 then
      mission:AddObjective(MDM_WaitObjective:new({
        seconds = wave.preparationTime,
        bannerText = "Next wave in"
      }))
    end

    mission:AddObjective(MDM_KillTargetsObjective:new({
      targets = waveEnemies
    }))
  end



  mission:OnMissionStart(function()
    MDM_PoliceUtils.DisablePolice()

    for i,car in ipairs(carAssets) do
      car:SetIndestructable(true)
      car:Spawn()
    end

    for i,ally in ipairs(allyNpcs) do
      ally:OnSpawned(
        function()
          ally:MakeAlly(true)
          MDM_NPCUtils.EquipTommygun(ally) end)
      ally:Godmode(true)
      ally:Spawn()
    end
  end)

  mission:OnMissionEnd(function ()
    MDM_PoliceUtils.EnablePolice()
    for i,ally in ipairs(allyNpcs) do
      ally:MakeAlly(false)
      ally:Godmode(false)
    end
  end)

  return mission
end

function MDM_GangWarMission.UnitTest()

end
