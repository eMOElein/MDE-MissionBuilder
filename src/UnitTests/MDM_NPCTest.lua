MDM_NPCTest = {}

function MDM_NPCTest.UnitTest ()
  local npc1 = MDM_NPC:new({npcId = "123",position = MDM_Utils.GetVector(0,0,0),direction = MDM_Utils.GetVector(0,0,0)})

  if not npc1:GetHealth() == 100 then
    error("health 100 expected")
  end

  npc1:SetHealth(0)
  if not npc1:GetHealth() == 0 then
    error("health 0 expected")
  end

  if not npc1:IsDead() then
    error("wrong dead state")
  end
end
