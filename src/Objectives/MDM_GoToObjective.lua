MDM_GoToObjective = {}
MDM_GoToObjective = MDM_Objective:class()


local args = {
  position = nil,
  radius = nil,
  outroText = nil,
  introText = nil
}
function MDM_GoToObjective:new(args)
  if not args.position then
    error("vector not set",2)
  end

  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  objective.vector = args.position
  objective.radius = args.radius or 20
  objective.area = MDM_Area.ForSphere({
    position = objective.vector,
    radius = objective.radius
  })

  if args.onUpdate  then
    if type(args.onUpdae) ~= "function" then
      error("onUpdate is not of type function",2)
    end
    objective:OnUpdate(args.onUpdate)
  end

  objective.detector = MDM_EntityInCircleDetector:new({
    entity = MDM_PlayerUtils.GetPlayer(),
    position = objective.vector,
    radius = objective.radius
  })

  return objective
end


function MDM_GoToObjective:PlayerDistanceToObjective(vector)
  local Distance = 0
  if game then
    Distance = getp():GetPos():DistanceToPoint(vector)
  end
  return Distance
end

function MDM_GoToObjective.Start(self)
  MDM_Objective.Start(self)

  if not self.blip then
    self.blip = MDM_Blip.ForVector({vector = self.vector})
  end

  self.blip:Show()
  self.area:Show()
end

function MDM_GoToObjective.Stop(self)
  self.area:Hide()
  self.blip:Hide()
  MDM_Objective.Stop(self)
end

function MDM_GoToObjective.Update(self)
  MDM_Objective.Update(self)
  if not self.running then
    return
  end

  if self.area:IsInside(MDM_PlayerUtils.GetPlayer():GetPos()) then
    self:Succeed()
  end
end

function MDM_GoToObjective.UnitTest()
  local vec = MDM_Utils.GetVector(-907.94,-160.41,2)

  local m = MDM_Mission:new({title = "Test"})
  local objective = MDM_GoToObjective:new({mission = m, position = vec})
  objective.title = "Objective 2"
  objective.task = "Go to the marked location"
  objective.description = "Blablabla"

  if not objective then
    error ("objective is nil" ,2)
  end

  if not objective.vector then
    error("objective vector is nil",2)
  end

  objective:Start()
end
