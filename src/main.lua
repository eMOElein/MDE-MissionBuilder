main = {}

include("MDM_LuaLoader.lua")

local script = ScriptHook.CurrentScript()
script.Entities = {}

function script:OnLoad()
  MDM_UnitTest = {}
  MDM_UnitTest.RegisterTest = function() end
  MDM_LuaLoader.ImportLuas(MDM_LuaLoader._luas)
  MDM_Core._Initialize()

  ScriptHook.RegisterKeyHandler("toggle", function()
    MDM_Core.missionManager:ToggleMissionMenu()
  end)
end

function script:OnUpdate()
  MDM_Core._Update()
end

function script:OnRender()
end

--function main.IncludeLuas()
--  MDM_UnitTest = {}
--  MDM_UnitTest.RegisterTest = function() end
--
--  for _,value in ipairs(MDM_Utils.luas) do
--    local lua = value ..".lua"
--    include(lua)
--  end
--end
