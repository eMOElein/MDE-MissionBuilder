MDM_EntityInCircleDetector = {}
MDM_EntityInCircleDetector = MDM_Detector:new()

function MDM_EntityInCircleDetector:new (args)
  if args.entity == nil then
    error("entity not set",2)
  end

--  if type(args.entity) ~= "table" then
--    error("entity is not of type table",2)
--  end

  if args.position == nil then
    error("position is nil",2)
  end

  if not args.radius then
    error ("radius not set",2)
  end

  local detector =  MDM_Detector:new()
  setmetatable(detector, self)
  self.__index = self

  detector.entity = args.entity
  detector:SetPosition(args.position) --args.position
  detector.radius = args.radius
  detector.entered = false
  detector.left = false
  detector.inside = false
  detector.previous = false
  return detector
end

function MDM_EntityInCircleDetector.HasEntered(self)
  return self.entered
end

function MDM_EntityInCircleDetector.HasLeft(self)
  return self.left
end

function MDM_EntityInCircleDetector.SetPosition(self,position)
  self.position = position
end

function MDM_EntityInCircleDetector.Test(self)
  local p1 = self.entity:GetPos()
  local distance = MDM_Utils.VectorDistance(self.entity:GetPos(),self.position)

  self.inside = distance <= self.radius
  self.entered =  not self.previous and self.inside
  self.left = self.previous and not self.inside
  self.previous = self.inside
  return self.inside
end

function MDM_EntityInCircleDetector.UnitTest()
  local pos1 = MDM_Utils.GetVector(0,0,0)
  local pos2 = MDM_Utils.GetVector(500,500,500)

  local npc1 = MDM_NPC:new({npcId = "12345",position = pos1, direction = pos1})

  local detector1 = MDM_EntityInCircleDetector:new ({entity = npc1, position = pos2, radius = 50})
  if detector1:Test() then
    error("false expected but was: " ..tostring(detector1:Test()),1)
  end

  local npc2 = MDM_NPC:new({npcId = "12345",position = pos2,direction = pos1})
  local detector2 = MDM_EntityInCircleDetector:new ({entity = npc2, position = pos2, radius = 50})
  if not detector2:Test() then
    error("true expected but was: " ..tostring(detector2:Test()),1)
  end
end
