-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

MDM_DetectorDirector = {}
MDM_DetectorDirector = MDM_Director:class()

local arguments = {
  detector = nil,
  callback = nil
}

function MDM_DetectorDirector:new (args)
  if not args.mission then
    error("mission not set",2)
  end

  if not args.detector then
    error("detector not set",2)
  end

  if not args.callback then
    error("callback not set",2)
  end

  if type(args.callback) ~= "function" then
    error("provided callback is no function",2)
  end

  local director = MDM_Director:new(args)
  setmetatable(director, self)
  self.__index = self

  director.detector = args.detector
  director.callback = args.callback
  return director
end

function MDM_DetectorDirector.Update(self)
  MDM_Director.Update(self)

  if not self:IsEnabled() then
    return
  end

  if(self.detector:Test()) then
    self.callback()
  end
end
