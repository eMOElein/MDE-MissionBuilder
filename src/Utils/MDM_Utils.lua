MDM_Utils = {}
MDM_Utils.Player = MDM_PlayerUtils
MDM_Utils.Vehicle = MDM_VehicleUtils

function MDM_Utils.ForEach(table, consumer)
  if type(table) == "table" then
    for index,object in pairs(table) do
      consumer(object)
    end
  else
    consumer(table)
  end
end

function MDM_Utils.GetDistance(pos1, pos2)
  return MDM_Utils.VectorDistance(pos1,pos2)
end

function MDM_Utils.GetFirstElement(table)
  for _,element in ipairs(table) do
    return element
  end
end

function MDM_Utils.VectorDistance(vector1,vector2)
  return MDM_Vector.DistanceToPoint(vector1,vector2)
end

function MDM_Utils.GetVector(x,y,z)
  local vector = nil

  if game then
    vector = Math:newVector(x,y,z)
  else
    vector = MDM_Vector:new(x,y,z)
  end

  return vector
end

function MDM_Utils.Callbacks(callbacks)
  if not callbacks then
    error("callbacks not set",2)
  end

  for index,callback in ipairs(callbacks) do
    callback()
  end
end

function MDM_Utils.SpawnAll(spawnables)
  for _,spawnable in ipairs(spawnables) do
    if not spawnable:IsSpawned() and not spawnable:IsSpawning() then
      spawnable:Spawn()
    end
  end
end

function MDM_Utils.DespawnAll(spawnables, radius)
  for index,spawnable in ipairs(spawnables) do
    local despawn = true

    if radius then
      despawn = (MDM_Utils.DistanceToPlayer(spawnable) > radius)
    end

    if despawn and spawnable:IsSpawned() then
      spawnable:Despawn()
    end
  end
end

function MDM_Utils.DistanceToPlayer(entity)
  local distance = 0
  if game then
    distance = getp():GetPos():DistanceToPoint(entity:GetPosition())
  end

  return distance
end

function Utils_tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end

function MDM_Utils.WriteDebug(text)
  print("Debug: " .. text)
  local file = io.open("debug.log", "a")
  file.write(file,text)
  file.write(file,"\n")
  file.close(file)
end
