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
  objective.args = args
  objective.npcsDeadDetector = MDM_NPCDeadDetector:new({npcs = args.enemies})
  if args.restorePlayer == nil or args.restorePlayer then objective:OnObjectiveStart(function() MDM_PlayerUtils.RestorePlayer() end) end
  return objective
end

function MDM_WaveObjective.Update(self)
  if not self:IsRunning() then
    return
  end

  if not self.enemysSpawned then
    for _, enemy in ipairs(self.args.enemies) do
      enemy:Spawn()
      enemy:AttackPlayer()
    end
    self.enemysSpawned = true
  end

  if self.npcsDeadDetector:Test() == true then
    self:Succeed(self)
  end

end

function MDM_WaveObjective.UnitTest()
  print("---------------MDM_WaveObjective Unit Test")
  local enemyNpc = MDM_NPC:new({npcId = "1234",position = MDM_Utils.GetVector(1,1,1),direction = MDM_Utils.GetVector(1,1,1)})

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
