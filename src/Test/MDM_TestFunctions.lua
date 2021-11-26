MDM_TestFunctions = {}
local _deugMapCircle

local banner

function MDM_TestFunctions.Test()
  game.hud:MissionHUDShow(true)
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
