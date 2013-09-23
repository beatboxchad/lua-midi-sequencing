#!/usr/bin/env lua

local JACK = require 'liblua_jack'
--local ALSA = require 'midialsa'

JACK.open_client("lua_client")
JACK.register_midi_out("lua_port")
JACK.activate()
--ALSA.client( 'Lua client', 1, 1, true)
--ALSA.connectto(1, 129, 0)
--ALSA.connectfrom( 1, 14, 0 )

function calculate_sleep_interval(tpb, bpm)
	local pre_dec_remove = (tpb * bpm / 60 / 32) 	
											-- ticks per second divided by 32 so I can get 32nd notes

											-- figured out a problem. sleeping is not synced to the beat. 
	local dec_remove = tostring(pre_dec_remove)
	dec_remove = string.gsub(dec_remove, "%p", "")
	local sleep_interval = tonumber(dec_remove)
	return (sleep_interval * .2)
end

while true do
	--local continue = io.read()
	--if string.match("yes", continue) then
	frame, state, bar, beat, tick, num, den, tpb, bpm, frametime, nexttime, usecs  = JACK.showtime()
	local sleep_interval = calculate_sleep_interval(tpb, bpm)
	os.execute("sleep ." .. sleep_interval)
	repeat
	frame, state, bar, beat, tick, num, den, tpb, bpm, frametime, nexttime, usecs  = JACK.showtime()
	until tick  % (tpb / 32) <= 20
print(tick)
--[[
	--print("bar: " .. bar .. "\t" .. "beat: " .. beat .. "\t" .. "tick: " .. tick .. "\t" .. "time signature: " .. num .. "/" .. den .. " " .. frametime .. " " .. tonumber(nexttime))
	print("frame:\t" .. frame)
	print("state:\t" .. state)
	print("bar:\t" .. bar)
	print("beat:\t" .. beat)
	print("tick:\t" .. tick)
	print("tpb:\t" .. tpb)
	print("bpm:\t" .. bpm)
	print("frametime:\t" .. frametime)
	print("nexttime:\t" .. tonumber(nexttime))
	print("os.time():\t" .. os.time())
	print("usecs:\t" .. usecs)
	print("time signature: " .. num .. "/" .. den)
	]]

--else
--	break
--end
end
