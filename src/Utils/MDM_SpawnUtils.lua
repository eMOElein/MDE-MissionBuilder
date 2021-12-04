MDM_SpawnUtils = {}

function MDM_SpawnUtils.AreAllSpawned(spawnables)
  for _,s in ipairs(spawnables) do
    if not s:IsSpawned() then
      return false
    end
  end
  return true
end
























































































