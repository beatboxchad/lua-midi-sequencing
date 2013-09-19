#!/usr/bin/env lua

local JACK = require 'liblua_jack'
--local ALSA = require 'midialsa'

JACK.open_client("lua_client")
JACK.register_midi_out("lua_port")
JACK.activate()
--ALSA.client( 'Lua client', 1, 1, true)
--ALSA.connectto(1, 129, 0)
--ALSA.connectfrom( 1, 14, 0 )

while true do
local continue = io.read()
if string.match("yes", continue) then
	local frame, state, bar, beat, tick, num, den, tpb, bpm, frametime, nexttime, usecs  = JACK.showtime()
	--print("bar: " .. bar .. "\t" .. "beat: " .. beat .. "\t" .. "tick: " .. tick .. "\t" .. "time signature: " .. num .. "/" .. den .. " " .. frametime .. " " .. tonumber(nexttime))
	print("frame:\t" .. frame)
	print("state:\t" .. state)
	print("bar:\t" .. bar)
	print("beat:\t" .. beat)
	print("tick:\t" .. frame)
	print("tpb:\t" .. tpb)
	print("bpm:\t" .. bpm)
	print("frametime:\t" .. frametime)
	print("nexttime:\t" .. tonumber(nexttime))
	print("os.time():\t" .. os.time())
	print("usecs:\t" .. usecs)

else
	break
end
end
