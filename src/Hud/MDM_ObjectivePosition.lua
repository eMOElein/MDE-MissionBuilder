MDM_ObjectivePosition = {}

function MDM_ObjectivePosition:new (title, pos,radius,color)
  local objPos = {}
  setmetatable(objPos, self)
  self.__index = self

  if not pos then
    error("pos not set",2)
  end

  if not title then
    error("title not set",2)
  end

  objPos.radius = radius or 20
  objPos.color = color or 4
  objPos.title = title
  objPos.pos = pos
  objPos.mapCircle = MDM_MapCircle:new(objPos.pos ,objPos.radius,objPos.color)

  return objPos
end

function MDM_ObjectivePosition:AddToMap()
  MDM_ObjectivePosition.show(self)
end

function MDM_ObjectivePosition:GetPos()
  return self.pos
end

function MDM_ObjectivePosition.Show(self)
  MDM_ObjectivePosition.show(self)
end

function MDM_ObjectivePosition.show(self)
  if self.onMap then
    return
  end

  if game then
    self.objectiveMDM_ObjectivePosition = game.navigation:RegisterObjectivePos(self.pos, "BLIPSTRING1", "BLIPSTRING2", true)
    self.mapCircle:Show()
  end

  self.onMap = true
end

function  MDM_ObjectivePosition.SetPos(self, pos)
  print("Set Pos: " ..pos.x)
  self.objectiveMDM_ObjectivePosition:SetPos(pos)
end

function MDM_ObjectivePosition.Hide(self)
  if self.mapCircle then
    self.mapCircle:Hide()
  end
  if not self.onMap then
    return
  end

  if self.objectiveMDM_ObjectivePosition  then
    HUD_UnregisterIcon(self.objectiveMDM_ObjectivePosition)
    self.objectiveMDM_ObjectivePosition = nil
  end

  if self.objectiveArea then
    self.objectiveArea = nil
  end

  self.onMap = false
end

function MDM_ObjectivePosition:RemoveFromMap()
  MDM_ObjectivePosition.Hide(self)
end
