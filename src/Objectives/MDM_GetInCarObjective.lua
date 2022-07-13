MDM_GetInCarObjective = {}

function MDM_GetInCarObjective:new (args)
  local objective = MDM_Objective:new(args)

  objective.cars = MDM_List:new()

  if args.car then
    objective.cars:Add(args.car)
  end

  if args.cars then
    objective.cars:AddAll(args.cars)
  end

  if #objective.cars == 0 then
    error("no car set",2)
  end

  objective:OnObjectiveStart(MDM_GetInCarObjective._OnObjectiveStart)
  objective:OnObjectiveEnd(MDM_GetInCarObjective._OnObjectiveEnd)
  objective:OnUpdate(MDM_GetInCarObjective._OnUpdate)

  return objective
end

function MDM_GetInCarObjective.AddCar(self,car)
  if self.cars:Contains(car) then
    return
  end

  self.cars:Add(car)

  if self.carBlips then
    local blip = MDM_Blip.ForCar(car)
    blip:Show()
    self.carBlips:Add(blip)
  end

end

function MDM_GetInCarObjective._OnObjectiveStart(self)
  for _,c in ipairs(self.cars) do
    if not c:IsSpawned() then
      c:Spawn()
    end
  end
end

function MDM_GetInCarObjective._OnObjectiveEnd(self)
  if self.carBlips then
    for _,b in ipairs(self.carBlips) do
      b:Hide()
    end
  end
end

function MDM_GetInCarObjective._OnUpdate(self)
  if not self.carBlips  then
    self.carBlips = MDM_List:new()
    for _,c in ipairs(self.cars) do
      local blip = MDM_Blip.ForCar({car = c})
      blip:Show()
      self.carBlips:Add(blip)
    end
  end

  for _,c in ipairs(self.cars) do
    if c:IsPlayerInCar() then
      MDM_Objective.Succeed(self)
    end
  end
end

function MDM_GetInCarObjective.UnitTest()
  local car = MDM_Car:new({carId = " ", position = MDM_Vector:new(1,1,1), direction = MDM_Vector:new(0,0,0)})
  local mission = MDM_Mission:new({})
  local objective = MDM_GetInCarObjective:new({
    mission = mission,
    car = car
  })

  mission:AddObjective(objective)
  mission:Start()
  mission:Update()
  mission:Update()

  for _,blip in ipairs(objective.carBlips) do
    if not blip:IsShowing() then
      error("all blips should be showing",2)
    end
  end

  objective:Succeed()
  mission:Update()
  mission:Stop()

  for _,blip in ipairs(objective.carBlips) do
    if blip:IsShowing() then
      error("no blip should be showing anymore",2)
    end
  end
end
