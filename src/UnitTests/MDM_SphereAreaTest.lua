MDM_SphereAreaTest = {}

function MDM_SphereAreaTest.UnitTest()
  local area = MDM_Area.ForSphere({
    position = MDM_Vector:new(0,0,0),
    radius = 5
  })

  local other = MDM_Vector:new(4,0,0)

  if not area:IsInside(other) then
    error("other should be insiede area")
  end

  other = MDM_Vector:new(6,0,0)

  if area:IsInside(other) then
    error("other should be outside area")
  end
end
