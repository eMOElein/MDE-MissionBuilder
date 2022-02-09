MDM_DefaultCallbackMonitor = {
  districtTextIdPrevious = "",
  districtTextIdCurrent = ""
}

function MDM_DefaultCallbackMonitor._Update()
  MDM_DefaultCallbackMonitor._Collect()

  MDM_DefaultCallbackMonitor._CheckOnPlayerVehicleEntered()
  MDM_DefaultCallbackMonitor._CheckOnPlayerVehicleLeft()

  MDM_DefaultCallbackMonitor._CheckOnPlayerDistrictChanged()
end

function MDM_DefaultCallbackMonitor._CheckOnPlayerVehicleEntered()
  if not MDM_DefaultCallbackMonitor.vehiclePrevious and MDM_DefaultCallbackMonitor.vehicleCurrent then
    MDM_Core.callbackSystem.NotifyCallbacks("on_player_vehicle_entered",{
      gameEntity = MDM_DefaultCallbackMonitor.vehicleCurrent
    })
  end
end

function MDM_DefaultCallbackMonitor._CheckOnPlayerVehicleLeft()
  if MDM_DefaultCallbackMonitor.vehiclePrevious and not MDM_DefaultCallbackMonitor.vehicleCurrent then
    MDM_Core.callbackSystem.NotifyCallbacks("on_player_vehicle_left",{
      gameEntity = MDM_DefaultCallbackMonitor.vehiclePrevious
    })
  end
end

function MDM_DefaultCallbackMonitor._CheckOnPlayerDistrictChanged()
  if MDM_DefaultCallbackMonitor.districtTextIdPrevious ~= MDM_DefaultCallbackMonitor.districtTextIdCurrent then
    MDM_Core.callbackSystem.NotifyCallbacks("on_player_district_changed",{
      districtOld = MDM_Districts.DistrictForTextId(MDM_DefaultCallbackMonitor.districtTextIdPrevious),
      districtNew = MDM_Districts.DistrictForTextId(MDM_DefaultCallbackMonitor.districtTextIdCurrent)
    })
  end
end


function MDM_DefaultCallbackMonitor._Collect()
  ----- District
  local districtNameId = game.director:GetDistrict(getp():GetPos()):GetName()
  MDM_DefaultCallbackMonitor.districtNameIdPrevious = MDM_DefaultCallbackMonitor.districtNameIdCurrent
  MDM_DefaultCallbackMonitor.districtNameIdCurrent = districtNameId
  local districtTextId  = game.director:GetDistrict(getp():GetPos()):GetTextId()
  MDM_DefaultCallbackMonitor.districtTextIdPrevious = MDM_DefaultCallbackMonitor.districtTextIdCurrent
  MDM_DefaultCallbackMonitor.districtTextIdCurrent = districtTextId

  ----- Vehicle
  local vehicle = MDM_VehicleUtils.GetPlayerCurrentVehicle()
  MDM_DefaultCallbackMonitor.vehiclePrevious = MDM_DefaultCallbackMonitor.vehicleCurrent
  MDM_DefaultCallbackMonitor.vehicleCurrent = vehicle
end
