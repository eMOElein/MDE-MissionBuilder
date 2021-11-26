MDM_WaveObjective = {}
MDM_WaveObjective = MDM_Objective:class()

--- Wave arguments
-- Arguments for constructing a wave objective
-- @param title the title of the wave.
-- @param preparationTime time before the wave stats
-- @param enemies table of MDM_NPCs that should spawn for the wave as enemies MANDATORY!!!!
-- @param restorePlayer restoring the player health and ammo before the wave. default is true
local arguments = {
  title = "Wave",
  preparationTime = 10,
  enemies = nil, -- MANDATORY!
  restorePlayer = true
}

function MDM_WaveObjective:new (args)
  local objective = MDM_Objective:new({mission = args.mission})
  setmetatable(objective, self)
  self.__index = self

  if type(args.enemies) ~= "table" then
    error("enemies is nil or not of type table",2)
  end

  if #args.enemies == 0 then
    error("enemyNpcs list is empty",2)
  end

  args.title = args.title or "Wave"
  objective:SetInformation(args.title,args.title,args.title)
  objective.configuration = args
  objective.npcsDeadDetector = MDM_NPCDeadDetector:new({npcs = args.enemies})
  objective.preparationTimeOver = args.preparationTime == 0
  objective.preparationTime = args.preparationTime or 10
  objective.time = -1
  objective.timerStarted = false
  if args.restorePlayer == nil or args.restorePlayer then objective:OnObjectiveStart(function() MDM_PlayerUtils.RestorePlayer() end) end
  self.timerBanner = MDM_Banner:new("Next Wave in ...")
  return objective
end

function MDM_WaveObjective.Update(self)
  if not self:IsRunning() then
    return
  end

  if game then
    if not self.preparationTimeOver then
      if not self.timerStarted and self.preparationTime > 0 then
        MDM_HUDUtils.StartTimer(self.preparationTime)
        self.timerStarted = true
      else
        if MDM_HUDUtils.GetTimerValue()  == 0 then
          MDM_HUDUtils.StopTimer()
          self.timerBanner:Hide()
          self.preparationTimeOver = true
        end
      end
    end
  else
    self.preparationTimeOver = true -- for unit testing we need to skip preparation if we are not ingame
  end

  if not self.preparationTimeOver then
    self.time = MDM_Math.Round(MDM_HUDUtils.GetTimerValue(),1)
    if self.time ~= self.lastTime then
      MDM_HUDUtils.HideTimer()
      self.lastTime = time
      self.timerBanner.title = "Next wave in " ..tostring(self.time)
      self.timerBanner:Show()
    end
  end

  if self.preparationTimeOver then
    if not self.enemysSpawned then
      for i, enemy in ipairs(self.configuration.enemies) do
        enemy:Spawn()
        enemy:AttackPlayer()
      end
      self.enemysSpawned = true
    end

    if self.npcsDeadDetector:Test() == true then
      self:Succeed(self)
    end
  end

end

function MDM_WaveObjective.UnitTest()
  print("---------------MDM_WaveObjective Unit Test")
  local enemyNpc = MDM_NPC:new("1234",MDM_Utils.GetVector(1,1,1),MDM_Utils.GetVector(1,1,1))

  local mission = MDM_Mission:new({title = "Test"})
  local config = {enemies = {enemyNpc}}


  local wave = MDM_WaveObjective:new(config)
  mission:AddObjective(wave)

  mission:Start()
  mission:Update()
  if wave:GetOutcome() ~= 0 then
    error("wave outcome should be 0 but was " ..wave:GetOutcome())
  end

  enemyNpc:SetHealth(0)
  mission:Update()
  if(wave:GetOutcome() ~= 1) then
    error("wave outcome should be 1 but was " ..wave:GetOutcome())
  end
  print("OK")
end
