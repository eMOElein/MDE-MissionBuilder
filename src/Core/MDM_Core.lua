MDM_Core = {
  _plugins = {},
  missionManager = nil,
  callbackSystem = nil
}

function MDM_Core._Update()
  local LoadedMap = game.director:CityGetActiveName()
  if LoadedMap == "Lost Heaven" and not game.hud:IsLoadingScreenUp() then
    MDM_DefaultCallbackMonitor._Update()
    MDM_Core.callbackSystem.NotifyCallbacks("on_update",{})
    MDM_Core.missionManager:Update()
  end
end

function MDM_Core.AddPlugin(plugin)
  table.insert(MDM_Core._plugins,plugin)
end

function MDM_Core._Initialize()
  MDM_Core.missionManager = MDM_MissionManager:new()
  MDM_Core.callbackSystem = MDM_DefaultCallbackSystem
  MDM_Core._InitializePlugins()

  MDM_Core.callbackSystem.RegisterCallback("on_player_vehicle_entered",function() print(" vehicle entered") end)
  MDM_Core.callbackSystem.RegisterCallback("on_player_vehicle_left",function() print("vehicle left") end)
  MDM_Core.callbackSystem.RegisterCallback("on_player_district_changed",function(args) print("district changed from " ..args.districtOld.name .." to " .. args.districtNew.name) end)
end

function MDM_Core._InitializePlugins()
  for _, lua in ipairs(MDM_Plugins.luas) do

    print("importing plugin: " ..lua)
    MDM_LuaLoader.ImportLuas({lua})
  end

  for _,plugin in ipairs(MDM_Core._plugins) do
    if plugin.luas then
      MDM_LuaLoader.ImportLuas(plugin.luas)
    end
    print("initializing plugin: " ..plugin.title)
    plugin.Initialize()
  end
end
