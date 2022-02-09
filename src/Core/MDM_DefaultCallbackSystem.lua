MDM_DefaultCallbackSystem = {
  callbackGroups = {},
  districtTextIdPrevious = "",
  districtTextIdCurrent = ""
}

function MDM_DefaultCallbackSystem.NotifyCallbacks(name, args)
  local callbacks = MDM_DefaultCallbackSystem._FetchGroup(name)
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


function MDM_DefaultCallbackSystem.RegisterCallback(name, callback)
  if type(callback) ~= "function" then
    error("callback is not of type function",2)
  end

  local callbacks = MDM_DefaultCallbackSystem._FetchGroup(name)
  table.insert(MDM_DefaultCallbackSystem.callbackGroups[name],callback)
end

function MDM_DefaultCallbackSystem._FetchGroup(name)
  local callbacks = MDM_DefaultCallbackSystem.callbackGroups[name]
  if callbacks == nil then
    callbacks = {}
    MDM_DefaultCallbackSystem.callbackGroups[name] = callbacks
  end

  return callbacks
end

function MDM_DefaultCallbackSystem.UnregisterCallback(name, callback)
  if type(callback) ~= "function" then
    error("callback is not of type function",2)
  end

  local callbacks = MDM_DefaultCallbackSystem._FetchGroup(name)
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

  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1)
  MDM_DefaultCallbackSystem.RegisterCallback(name_1,c_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1)
  MDM_DefaultCallbackSystem.RegisterCallback(name_2,c_2)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1)
  MDM_DefaultCallbackSystem.UnregisterCallback(name_1,c_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_2)
  MDM_DefaultCallbackSystem.UnregisterCallback(name_2,c_2)
  MDM_DefaultCallbackSystem.RegisterCallback(name_1,c_1_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_2)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1)
  MDM_DefaultCallbackSystem.UnregisterCallback(name_1,c_1_1)
  MDM_DefaultCallbackSystem.NotifyCallbacks(name_1)

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
