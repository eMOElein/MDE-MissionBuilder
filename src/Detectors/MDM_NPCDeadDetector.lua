MDM_NPCDeadDetector = {}
MDM_NPCDeadDetector = MDM_Detector:new()

function MDM_NPCDeadDetector:new (args)
  local detector =  {}
  setmetatable(detector, self)
  self.__index = self

  if not args.npcs then
    error("npcs not set",2)
  end

  if type(args.npcs) ~= "table" then
    error("npcs is not of type table",2)
  end

  detector.npcs = args.npcs
  return detector
end

function MDM_NPCDeadDetector.Test(self)
  for index,npc in ipairs(self.npcs) do
    if not npc:IsDead() then
      return false
    end
  end
  return true
end
