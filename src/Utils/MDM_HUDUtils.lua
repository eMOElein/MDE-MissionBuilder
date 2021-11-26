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

MDM_HUDUtils = {}

function MDM_HUDUtils.StartTimer(timerValue)
  if game then
    game.hud:TimerSet(timerValue)
    game.hud:TimerShow(true)
    game.hud:TimerStart(true)
  end
end

function MDM_HUDUtils.HideTimer()
  if game then
    game.hud:TimerShow(false)
  end
end

function MDM_HUDUtils.StopTimer()
  if game then
    game.hud:TimerSet(0)
    game.hud:TimerShow(false)
    game.hud:TimerStop(true)
  end
end

function MDM_HUDUtils.GetTimerValue()
  if game then
    local time = game.hud:TimerGetTime()
    if time then
      return time
    else
    end
  end

  return 0
end
