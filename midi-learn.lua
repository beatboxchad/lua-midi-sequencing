#!/usr/bin/env lua5.1

local socket = require("socket")
local sequencer = require("sequencer")
local ALSA = require 'midialsa'
ALSA.client( 'Lua client', 1, 1, true)
ALSA.connectto(1, 129, 0)
ALSA.connectfrom( 1, 14, 0 )

local notes = {}
notes.one = 42
notes.two = 45
notes.three = 40
notes.four = 40
notes.five = 40

function makenote(i)
  local j
  if i % 7 == 1 then
    j = notes.one
  elseif i % 7 == 3 then
    j = notes.two
  elseif i % 7 == 5 then
    j = notes.three
  elseif i % 7 == 6 then
    j = notes.four
  elseif i % 7 == 0 then
    j = notes.five
  else
    j = nil
  end
  return j
end

--[[
this needs to be reimplemented, but it got the job done. Sort of.


]]
function iterate()
  local s = 0
    return function() if s < 6 then s = s + 1 else s = 0 mm = m() end print(s) return s end
end

function iterate_to_four()
  local s = 0 
  return function() if s < 7 then s = s + 1 else s = 0 end return s end
end


m = iterate_to_four()
s = iterate()

while true do

    socket.sleep(.2) -- my clumsy way of implementing tempo
    ALSA.start()
    --local alsaevent = ALSA.input()
    local beat = s()
    print(mm)
    local j = makenote(beat)
    if mm == 4 or mm == 5 then if j ~= nil then j = j + 3 end end
    local note = ALSA.noteevent(4,j,52,0,.075)
 
  if j ~= nil then ALSA.output(note) end
    --ALSA.syncoutput()
  
end
