--- Available callbacks:
-- on_player_vehicle_entered
-- on_player_vehicle_left
-- on_player_district_changed
-- on_before_mission_start
-- on_update
MDM_DefaultCallbackSystem = {
  _callbackGroups = {},
}

--- Notifies the callbacks that are registerd to the given event name and passes the given argument table to the callback function.
-- @param eventName The event name of the callbacks that sould be notified. Must be of type string.
-- @param args The argument table that should be passed to the callback's function. Must be of type table.
function MDM_DefaultCallbackSystem.NotifyCallbacks(eventName, args)
  if type(eventName) ~= "string" then
    error("eventName is not of type string",2)
  end

  if type(args) ~= "table" then
    error("args not of type table",2)
  end

  local callbacks = MDM_DefaultCallbackSystem._FetchGroup(eventName)
  local counter = 0

  if #callbacks > 0 then
    for _,c in ipairs(callbacks) do
      c(args)
      counter = counter + 1
    end
  end

  return{
    counter = counter
  }
end


--- Registers a callback function for the given event name
-- @param eventname The name of the callback event. Must be of type string
-- @param callback The function that should be executed when the given event occurs. Must be of type function
function MDM_DefaultCallbackSystem.RegisterCallback(eventName, callback)
  if type(eventName) ~= "string" then
    error("eventNameis not of type string",2)
  end

  if type(callback) ~= "function" then
    error("callback is not of type function",2)
  end

  local callbacks = MDM_DefaultCallbackSystem._FetchGroup(eventName)
  table.insert(MDM_DefaultCallbackSystem._callbackGroups[eventName],callback)
end

--- Removes the given callback from the list for the given event name.
-- @param eventname The name of the callback event. Must be of type string
-- @param callback The function that should be removed from the active callbacks. Must be of type function. If the callback function was added multiple times to the same event then all occurences inside the event will be removed.
function MDM_DefaultCallbackSystem.UnregisterCallback(eventName, callback)
  if type(eventName) ~= "string" then
    error("eventName is not of type string",2)
  end

  if callback == nil then
    error("callback is nil",2)
  end

  if type(callback) ~= "function" then
    error("callback is not of type function but " ..type(callback),2)
  end

  local callbacks = MDM_DefaultCallbackSystem._FetchGroup(eventName)
  local toRemove = {}

  if #callbacks < 1 then
    return 0
  end

  -- we look for all occurences just in case the callback has been added multiple times
  for i,c in ipairs(callbacks) do
    if c == callback then
      table.insert(toRemove,i)
    end
  end

  for _,i in ipairs(toRemove) do
    table.remove(callbacks,i)
  end

  return #toRemove
end

function MDM_DefaultCallbackSystem._FetchGroup(name)
  local callbacks = MDM_DefaultCallbackSystem._callbackGroups[name]
  if callbacks == nil then
    callbacks = {}
    MDM_DefaultCallbackSystem._callbackGroups[name] = callbacks
  end

  return callbacks
end

function MDM_DefaultCallbackSystem.UnitTest()
  print("---------------MDM_DefaultCallbackSystem UnitTest")
  local cnt1 = 0
  local cnt1_1 = 0
  local name_1 = "c_1"
  local c_1 = function() cnt1 = cnt1 + 1 end
  local c_1_1 = function() cnt1_1 = cnt1_1 + 1 end

  local cnt2 = 0
  local name_2 = "c_2"
  local c_2 = function() cnt2 = cnt2 + 1 end

  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1,{})
  MDM_DefaultCallbackSystem.RegisterCallback(name_1,c_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1,{})
  MDM_DefaultCallbackSystem.RegisterCallback(name_2,c_2)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1,{})
  MDM_DefaultCallbackSystem.UnregisterCallback(name_1,c_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_2,{})
  MDM_DefaultCallbackSystem.UnregisterCallback(name_2,c_2)
  MDM_DefaultCallbackSystem.RegisterCallback(name_1,c_1_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_2,{})
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1,{})
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1,{})
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1,{})
  MDM_DefaultCallbackSystem.UnregisterCallback(name_1,c_1_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1,{})

  if cnt1 ~= 2 then
    error("cnt1 should be 2 but was " ..cnt1)
  end

  if cnt1_1 ~= 3 then
    error("cnt1_1 should be 3 but was " ..cnt1)
  end

  if cnt2 ~= 1 then
    error("cnt2 should be 1 but was " ..cnt2)
  end

  print("OK")
end
