MDM_HurtNPCDirector = MDM_Director:class()

local currentHealth = nil

function MDM_HurtNPCDirector:new(mission,npc,threshold, callbackThreshold, callbackDead)
  local director =  MDM_Director:new({mission = mission})
  --  setmetatable(director, self)
  --  self.__index = self

  if not npc then
    error("npc not set",2)
  end

  if not threshold then
    error("threshold not set",2)
  end

  director.npc = npc
  director.callbackThreshold = callbackThreshold
  director.callbackDead = callbackDead
  director.threshold = threshold
  director.failmission = nil

  return director
end

local function OnNpcDead(self)
  if self.callbackDead then
    self.callbackDead()
    self:Disable()
  end

  if(self.failmission) then
    self.failmission:Fail()
  end
end

function MDM_HurtNPCDirector.SetFailMission(self,mission)
  self.failmission = mission
end

function MDM_HurtNPCDirector.Update(self)
  if not self:IsEnabled() then
    return
  end


  local cHealth = self.npc:GetHealth()

  if self.previousHealth then
    if self.npc:IsDead() then
      OnNpcDead(self)
    end

    --   print(self.previousHealth .. " vs " .. cHealth)
    if  self.previousHealth > self.threshold and cHealth < self.threshold and self.callbackThreshold then
      self.callbackThreshold()
    end
  end
  self.previousHealth = cHealth
  MDM_Director.Update()
end

function MDM_HurtNPCDirector.UnitTest()
  print("_________________MDM_HurtNPCDirector:Unittest__________________")
  local npc1 = MDM_NPC:new("id",Utils_GetVector(-907.94,-210.41,2))
  local hurtDirector = MDM_HurtNPCDirector:new(MDM_Mission:new(),npc1,50)
end
