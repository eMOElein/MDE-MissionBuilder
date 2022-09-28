MDM_Vector = {}


function MDM_Vector:new(x,y,z)

  local vector

  if game then
    vector = Math:newVector(x,y,z)
  else
    vector =  {
      x = x,
      y = y,
      z = z
    }
  end
  
  vector.DistanceToPoint = MDM_Vector.DistanceToPoint

  return vector
end

function MDM_Vector.DistanceToPoint(self,otherVector)
  if self == nil then
    error("vector not set",2)
  end

  if otherVector == nil  then
    error("otherVector not set",2)
  end

  local distance = ((self.x - otherVector.x)^2 + (self.y - otherVector.y)^2 + (self.z - otherVector.z)^2)^0.5
  return distance
end
