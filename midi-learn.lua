#!/usr/bin/env lua5.1

local socket = require("socket")
local sequencer = require("sequencer")
local ALSA = require 'midialsa'
ALSA.client( 'Lua client', 1, 1, true)
ALSA.connectto(1, 129, 0)
ALSA.connectfrom( 1, 14, 0 )

local notes = {}
local timeSignature = #songs[song]
local song = "nathans_song"
local songs = {}

songs.nathans_song = {}
songs.nathans_song[1] = notes.one
songs.nathans_song[2] = rest
songs.nathans_song[3] = notes.two
songs.nathans_song[4] = rest
songs.nathans_song[5] = notes.three
songs.nathans_song[6] = notes.four
songs.nathans_song[7] = notes.five

notes.one = 42
notes.two = 45
notes.three = 40
notes.four = 40
notes.five = 40

--[[
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
--]]

--[[
this needs to be reimplemented, but it got the job done. Sort of.



function iterate()
  local s = 0
    return function() if s < 6 then s = s + 1 else s = 0 mm = m() end print(s) return s end
end

function iterate_to_four()
  local s = 0 
  return function() if s < 7 then s = s + 1 else s = 0 end return s end
end

]]

function beat_iterator()
  local s = 0
  return function()
    s = s % timeSignature
    if s == 0 then
      measure = iterate_measure()
    end
    return s + 1
  end
end

function measure_iterator()
  local s = 0
  return function()
    s = s % 7
    return s + 1
  end
end

--[[
m = iterate_to_four()
s = iterate()
--]]
iterate_beat = beat_iterator()
iterate_measure = measure_iterator()

while true do
  socket.sleep(.2) -- my clumsy way of implementing tempo
  ALSA.start()
  --local alsaevent = ALSA.input()
  beat = iterate_beat()
  print(measure)
  print(beat)
  local pitch = songs[song][beat]
  if measure == 5 or measure == 6 then
    if pitch ~= nil then
      pitch = pitch + 3
    end
  end
  if pitch ~= nil then
    local note = ALSA.noteevent(4,pitch,52,0,.075)
    ALSA.output(note)
  end
  --ALSA.syncoutput()
end
