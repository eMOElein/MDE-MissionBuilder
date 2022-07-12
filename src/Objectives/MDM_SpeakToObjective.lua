MDM_SpeakToObjective = {}
MDM_SpeakToObjective = MDM_Objective:class()

function MDM_SpeakToObjective:new(args)
  if not args.npc then
    error("npc not set",2)
  end

  local objective = MDM_Objective:new(args)
  setmetatable(objective, self)
  self.__index = self

  objective.npc = args.npc
  objective.radius = args.radius or 2

  return objective
end


function MDM_SpeakToObjective:PlayerDistanceToObjective(vector)
  local Distance = 0
  if game then
    Distance = getp():GetPos():DistanceToPoint(vector)
  end
  return Distance
end

function MDM_SpeakToObjective.Start(self)
  MDM_Objective.Start(self)

  if not self.blip then
    self.blip = MDM_Blip.ForNPC({npc = self.npc})
  end

  self.blip:Show()
end

function MDM_SpeakToObjective.Stop(self)
  if self.blip then
    self.blip:Hide()
  end

  MDM_Objective.Stop(self)
end

function MDM_SpeakToObjective.Update(self)
  MDM_Objective.Update(self)
  if not self.running then
    return
  end

  local posPlayer = MDM_Utils.Player.GetPos()
  local posNPC = self.npc:GetPos()

  if MDM_Vector.DistanceToPoint(posNPC,posPlayer) <= self.radius then
    self:Succeed()
  end
end

function MDM_SpeakToObjective.UnitTest()
  local m = MDM_Mission:new({title = "Test"})
  local objective = MDM_SpeakToObjective:new({
    mission = m,
    npc = MDM_NPC:new({npcId = "17047363682458951493", position = MDM_Vector:new(-928.22968,-248.62529,2.7746923), direction = MDM_Vector:new(-0.34469545,0.9387145,0)}),

  })

  if not objective then
    error ("objective is nil" ,2)
  end

  if not objective.npc then
    error("npc vector is nil",2)
  end

  objective:Start()
end
