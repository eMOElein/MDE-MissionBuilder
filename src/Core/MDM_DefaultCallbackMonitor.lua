MDM_DefaultCallbackMonitor = {
  current = {
    playerDistrictTextId = "",
    playerVehicle = nil
  },
  previous = {
    playerDistrictTextId = "",
    playerVehicle = nil,
  }

}

function MDM_DefaultCallbackMonitor._Update()
  MDM_DefaultCallbackMonitor._Collect()

  MDM_DefaultCallbackMonitor._CheckOnPlayerVehicleEntered()
  MDM_DefaultCallbackMonitor._CheckOnPlayerVehicleLeft()

  MDM_DefaultCallbackMonitor._CheckOnPlayerDistrictChanged()
end

function MDM_DefaultCallbackMonitor._CheckOnPlayerVehicleEntered()
  if not MDM_DefaultCallbackMonitor.previous.playerVehicle and MDM_DefaultCallbackMonitor.current.playerVehicle then
    MDM_Core.callbackSystem.NotifyCallbacks("on_player_vehicle_entered",{
      gameEntity = MDM_DefaultCallbackMonitor.current.playerVehicle
    })
  end
end

function MDM_DefaultCallbackMonitor._CheckOnPlayerVehicleLeft()
  if MDM_DefaultCallbackMonitor.previous.playerVehicle and not MDM_DefaultCallbackMonitor.current.playerVehicle then
    MDM_Core.callbackSystem.NotifyCallbacks("on_player_vehicle_left",{
      gameEntity = MDM_DefaultCallbackMonitor.previous.playerVehicle
    })
  end
end

function MDM_DefaultCallbackMonitor._CheckOnPlayerDistrictChanged()
  if MDM_DefaultCallbackMonitor.previous.playerDistrictTextId ~= MDM_DefaultCallbackMonitor.current.playerDistrictTextId then
    MDM_Core.callbackSystem.NotifyCallbacks("on_player_district_changed",{
      districtOld = MDM_Districts.DistrictForTextId(MDM_DefaultCallbackMonitor.previous.playerDistrictTextId),
      districtNew = MDM_Districts.DistrictForTextId(MDM_DefaultCallbackMonitor.current.playerDistrictTextId)
    })
  end
end


function MDM_DefaultCallbackMonitor._Collect()
  ----- District
  local districtNameId = game.director:GetDistrict(getp():GetPos()):GetName()
  MDM_DefaultCallbackMonitor.previous.playerDistrictTextId = MDM_DefaultCallbackMonitor.current.districtNameId
  MDM_DefaultCallbackMonitor.current.districtNameId = districtNameId
  local districtTextId  = game.director:GetDistrict(getp():GetPos()):GetTextId()
  MDM_DefaultCallbackMonitor.previous.playerDistrictTextId = MDM_DefaultCallbackMonitor.current.playerDistrictTextId
  MDM_DefaultCallbackMonitor.current.playerDistrictTextId = districtTextId

  ----- Vehicle
  local vehicle = MDM_VehicleUtils.GetPlayerCurrentVehicle()
  MDM_DefaultCallbackMonitor.previous.playerVehicle = MDM_DefaultCallbackMonitor.current.playerVehicle
  MDM_DefaultCallbackMonitor.current.playerVehicle = vehicle
end
