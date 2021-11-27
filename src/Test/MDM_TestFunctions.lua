MDM_TestFunctions = {}
local _deugMapCircle

local banner
local npc
local smithCar

function MDM_TestFunctions.Test()
  if not MDM_TestFunctions.index_V1 or MDM_TestFunctions.index_V1 >= 4 then
    MDM_TestFunctions.index_V1  = 0
  else
    MDM_TestFunctions.index_V1 = MDM_TestFunctions.index_V1 +1
  end



  if MDM_TestFunctions.index_V1 == 0 then
    print("Spawn")
    smithCar = MDM_Car:new("smith_v12",MDM_Utils.GetVector(-898.71429,-181.9543,4),MDM_Utils.GetVector(-0,000001,-0.000004,0.000150))
    npc = MDM_NPC:new("13604348442857333985",MDM_Utils.GetVector(-907.94,-180.41,2),MDM_Utils.GetVector(0,0,0))
    smithCar:Spawn()
    npc:Spawn()
  end


  if MDM_TestFunctions.index_V1 == 1 then
    print("Get NPC In Car")
    -- @param1: car gameEntity
    -- @param2: number of the seat 1 = driver , 2 = passenger etc.
    -- @param3: unknown boolean
    -- @param4: true = walk in car / false = teleport in car
    --
    -- move commands can be set to the car in the same update cycle when teleporting.
    npc:GetGameEntity():GetInOutCar(smithCar:GetGameEntity(),1,false,false)


    --
  end

  if MDM_TestFunctions.index_V1 == 2 then
    print("Drive Car")
    -- Setting the Navmode only works if an npc is sitting in the driver seat
    --     smithCar:GetGameEntity():SetRubberBandingOn("true")


    --    smithCar:GetGameEntity():SetMaxAISpeed(false,   enums.CarAIProfile.NORMAL )
    --    smithCar:GetGameEntity():InitializeAIParams(enums.CarAIProfile.NORMAL ,1 )
    smithCar:GetGameEntity():InitializeAIParams(enums.CarAIProfile.AGGRESSIVE   ,enums.CarAIProfile.AGGRESSIVE   )
    smithCar:GetGameEntity():SetMaxAISpeed(true,70)


    --   smithCar:GetGameEntity():SetNavModeHunt(getp(),5,  enums.CarHuntRole.POKE   )--
    smithCar:GetGameEntity():SetNavModeWanderArea(false,nil)
    --    smithCar:GetGameEntity():SetNavModeMoveTo(MDM_LocationPositions.BERTONES_AUTOSERVICE_FRONTDOOR,   enums.CarPathEnd.PARK )
    --     smithCar:GetGameEntity():SetSirenOn(true)

  end

  if MDM_TestFunctions.index_V1 == 3 then
    print("Attack")
    npc:AttackPlayer()
  end

  if MDM_TestFunctions.index_V1 == 4 then
    print("Despawn")
    smithCar:Despawn()
    npc:Despawn()
    npc = nil
    smithCar = nil
  end

end

function MDM_TestFunctions.TestBanner()
  --  game.game:TurnOffTheLights(false)
  if not banner then
    banner = MDM_Banner:new("Testbanner"):SetColor(10)
    banner:Show()
  else
    banner:Hide()
    banner = nil
  end
end

-- Removes all regular traffic from game
-- good for gang wars. police will still paatrol???
function MDM_TestFunctions.RemoveNormalTraffif()
  print("Testfunction")
  game.traffic:SetEnableAmbientTrafficSpawning(false)
end

-- shows the mission restart screen thath usually comes up on death.
-- but seems to expect stringids isntead of text and seems not to work correctly
function MDM_TestFunctions.MissionRestartScreen()
  print("Testfunction")
  game.hud:ShowMissionRestart("true","yes")
end

-- displays a widget but needs ids instead of textstrings and therefore seems not to work correctly
function MDM_TestFunctions.MissionOptins()
  game.hud:ShowMissionOptIn("true","yes")
end

-- the player cars speedometer in the lower right
function MDM_TestFunctions.ShowHideSpeedometer()
  print("Testfunction")
  game.hud:SpeedometerShow(false)
end

--shows the visibility meter eye widget on the hud
function MDM_TestFunctions.ShowVisibilityMeter()
  game.hud:TailingGaugeShow(true)
  game.hud:SetTailingGaugeValue(75)
end

-- Shows the overheating temperature Gauge on the hud.
function MDM_TestFunctions.ShowTemperatureGauge()
  game.hud:TemperatureGaugeShow(true)
  game.hud:SetTemperatureGaugeValue(75)
end

function MDM_TestFunctions.DrawCircleAroundPlayer(radius)
  if game then
    if _deugMapCircle then
      _deugMapCircle:Hide()
      _deugMapCircle = nil
    else
      _deugMapCircle = MDM_MapCircle:new (getp():GetPos(),30,10)
      _deugMapCircle:Show()
    end
  end
end
