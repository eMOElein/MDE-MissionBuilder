MDM_CarTest = {}

function MDM_CarTest.UnitTest()
  local car = MDM_Car:new("falconer_classic", MDM_Utils.GetVector(-907.94,-210.41,2),MDM_Utils.GetVector(-907.94,-210.41,2))
  car:Spawn()
  car:Despawn()
end
