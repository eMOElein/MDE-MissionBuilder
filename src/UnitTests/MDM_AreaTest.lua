MDM_AreaTest = {}

function MDM_AreaTest.UnitTest()

  local area = MDM_Area.ForSphere({
    position = MDM_Vector:new(0,0,0),
    radius = 10
  })

  local pos = MDM_Vector:new(5,0,0)

  if not area:IsInside(pos) then
    error("IsInside should have been true")
  end

  area:Show()

  pos = MDM_Vector:new(30,0,0)
  if area:IsInside(pos) then
    error("IsInside should have been false")
  end

  area:Hide()

  pos = MDM_Vector:new(5,0,0)
  if not area:IsInside(pos) then
    error("IsInside should have been true")
  end


end
