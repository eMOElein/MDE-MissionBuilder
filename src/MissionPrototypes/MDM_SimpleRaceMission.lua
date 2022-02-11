MDM_SimpleRaceMission = {}
MDM_SimpleRaceMission = MDM_Mission:class()

function MDM_SimpleRaceMission:new(args)
  local mission = MDM_Mission:new(args)
  setmetatable(mission, self)
  self.__index = self

  local mission = MDM_Mission:new(args)

  if args.playerCar == nil then
    error("playerCar not set",2)
  end

  if args.rivalCars == nil then
    error("rivalCars not set",2)
  end

  if #args.rivalCars == 0 then
    error("rivalCars is empty",2)
  end

  if args.waypoints == nil then
    error("waypoints not set",2)
  end

  if #args.waypoints == 0 then
    error("waypoints is empty",2)
  end

  mission.playerCar = MDM_Car:new(args.playerCar)
  mission.rivals= {}
  mission.waypoints = {}

  for _,c in pairs(args.rivalCars) do
    local rival = {
      car = MDM_Car:new(c),
      npc = MDM_NPC:new({npcId = "13604348442857333985", position = MDM_Utils.GetVector(c.position.x,c.position.y,c.position.z+3)})
    }
    table.insert(mission.rivals,rival)
  end

  for _,w in ipairs(args.waypoints) do
    table.insert(mission.waypoints,w)
  end

  mission.goal = MDM_Utils.GetFirstElement(mission.waypoints)


  local spawnables = {}
  for _,r in ipairs(mission.rivals) do
    table.insert(spawnables,r.car)
    table.insert(spawnables,r.npc)
  end
  table.insert(spawnables,mission.playerCar)

  mission:AddAssets(spawnables)

  -----------------------
  ------ Objectives -----
  -----------------------
  local objective_000_restore = MDM_RestorePlayerObjective:new({mission = mission})
  mission:AddObjective(objective_000_restore)

  local objective_000_SpawnerObjective = MDM_SpawnerObjective:new({
    mission = mission,
    spawnables = spawnables
  })
  mission:AddObjective(objective_000_SpawnerObjective)

  local objective_100_PrepareOjective1 = MDM_CallbackObjective:new({
    mission = mission,
    callback = function()
      MDM_SimpleRaceMission._InstallDrivers(mission)
      --      game.traffic:SetEnableAmbientTrafficSpawning(true)
      return true
    end
  })
  mission:AddObjective(objective_100_PrepareOjective1)

  local objective_000_GoToLocation = MDM_GoToObjective:new({
    mission = mission,
    title = "Race to your goal!",
    position = mission.goal,
    radius = 20
  })
  mission:AddObjective(objective_000_GoToLocation)

  return mission
end

function MDM_SimpleRaceMission._InstallDrivers(self)
  if game then
    for _,r in ipairs(self.rivals)do
      local carEntity = r.car:GetGameEntity()
      local npcEntity = r.npc:GetGameEntity()

      npcEntity:GetInOutCar(carEntity,1,false,false)
      carEntity:InitializeAIParams(enums.CarAIProfile.PIRATE ,enums.CarAIProfile.PIRATE )
      carEntity:SetMaxAISpeed(true,150)
      carEntity:SetNavModeMoveTo(self.goal,1)
      carEntity:SetRubberBandingOn()
    end

    getp():GetInOutCar(self.playerCar:GetGameEntity(),1,false,false)
    --    getp():GetOnVehicle(self.playerCar:GetGameEntity(), 1, false, "WALK")
  end

  return true
end

function MDM_SimpleRaceMission.Update(self)
  MDM_Mission.Update(self)
end

function MDM_SimpleRaceMission.UnitTest()
  print("---------------MDM_SimpleRaceMission")
  local mission = MDM_SimpleRaceMission:new({
    playerCar = {carId = "smith_v12", position = MDM_Utils.GetVector(-898.62866,-206.49626,2.9617207), direction = MDM_Utils.GetVector(-0.0094909342,0.99995327,-0.0018382519)},
    rivalCars = {
      {carId = "smith_v12", position = MDM_Utils.GetVector(-901.00354,-189.40616,2.9292006), direction = MDM_Utils.GetVector(0.019263864,0.99977261,-0.0091460701)},
      {carId = "smith_v12", position = MDM_Utils.GetVector(-896.29266,-189.47711,2.9430671), direction = MDM_Utils.GetVector(-0.013393856,0.9998768,-0.0081892973)},
      {carId = "smith_v12", position = MDM_Utils.GetVector(-896.17072,-198.3961,2.9592886), direction = MDM_Utils.GetVector(-0.00056744472,0.9999972,-0.0022861471)},
      {carId = "smith_v12", position = MDM_Utils.GetVector(-900.65759,-198.55563,2.9572015), direction = MDM_Utils.GetVector(-0.019604612,0.99980384,-0.0028221593)}
    },
    waypoints = {
      MDM_Utils.GetVector(-898.71429,-181.9543,4)
    }
  })
  mission:Start()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
  mission:Update()
end
