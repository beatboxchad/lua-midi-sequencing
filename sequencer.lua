#!/usr/bin/env lua

--[[

Copyright (C) 2013 Chad Cassady <chad@beatboxchad.com>
Copyright (C) 2013 Nathan Lander <lander89@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

--]]




--[[

This will contain all the stuff I plan to reuse with each script.

TODO:

	-	replace midialsa by adding MIDI capability to the JACK module, creating a
		more platform-independent implementation (JACK runs on MacOS, iOS, Linux,
		and did I read something about Windows?)

	- Document the new JACK module

	- figure out what's up with that too many C levels error I get when I run
		this. It apparently has something to do with the depth of tables of tables,
		but that's crap, we only have like two.


]]


local ALSA = require 'midialsa'
local JACK = require 'liblua_jack'
require 'notes'

JACK.open_client("lua_client")
ALSA.client( 'Lua client', 1, 1, true)
ALSA.connectto(1, 130, 0)
ALSA.connectfrom( 1, 14, 0 )

local mynotes = { A4, C4, G4, G4, G4, G4, E4, F4, G4}
--[[
local songs = {}

songs.nathans_song = {}
songs.nathans_song[1] = notes.one
songs.nathans_song[2] = rest
songs.nathans_song[3] = notes.two
songs.nathans_song[4] = nil
songs.nathans_song[5] = notes.three
songs.nathans_song[6] = notes.four
songs.nathans_song[7] = notes.five
]]


	--[[
	CHAD:

		JACK also has a lot of sophisticated 

		JACK MIDI events are flushed to a buffer with the nframes time at which the
		event is valid. It can also handle realtime events, but for sequencing, we
		can do a thing where we run all our calculations and just put stuff in the
		buffer with an appropriate time.



					I want to not waste resources constantly polling the current beat, so a way
					to handle that needs to be figured out. Perhaps we'll calculate how long to
					sleep based on beats per minute before taking our next action. However, I
					don't want to create a situation where I'm trying to generate notes on the
					tick (rather than on the beat) and end up sleeping through that intended
					event. So perhaps a reverse-polling situation ought to be created for the
					beats. Or I can just watch the ticks. Er... we'll see what I do.  
					
					The other thing is I need to not constantly flush new MIDI messages down the
					pipe every iteration of the while true part. So I'm either sleeping, or I'm
					constantly checking shit? How do I write my function to wait? Am I waiting on
					the beat, the bar, or what? Balls.
					

					For now I have a checker function.

				Here's what I'll do:

				I should look into next_usecs and current_usecs, both returned by
				jack_get_cycle_times()

				I'll watch for a change in the current tick by saving the first query into
				a variable, then saving all subsequent queries into a second one. As soon
				as the two are not the same, I'll save the current usecs value into a
				variable, and copy the changed tick into the first tick variable. I will
				watch for another tick change. When that happens, I'll save the current
				usecs value into a second variable, and subtract the first one from that.
				The resulting number is how long I will wait to query JACK from now on, and
				it's also how long I'll wait to send MIDI events. We'll operate on the tick
				level. The ticks per beat value shouldn't change, but if I find that it
				does, then we'll watch for changes in the BPM value, and re-perform this
				calibration in that event. 
	
	--]]

function calculate_sleep_interval(tpb, bpm)
	local pre_dec_remove = (tpb * bpm / 60 / 32) 	
											-- ticks per second divided by 32 so I can get 32nd notes
	local dec_remove = tostring(pre_dec_remove)
	dec_remove = string.gsub(dec_remove, "%p", "")
	dec_remove = tonumber(dec_remove)

	return dec_remove
end

function wait_for_beat_change(beat)
	local frame, state, bar, old_beat, tick, num, den = JACK.showtime() 
	if beat == old_beat then
		return 1
	else
		return 0
	end
end

local last_beat


local function jack_info()
	local frame, state, bar, beat, tick, num, den, tpb, bpm, frametime, nexttime, usecs  = JACK.showtime()
	return frame, state, bar, beat, tick, num, den, tpb, bpm, frametime, nexttime, usecs  
end 

local frame, state, bar, beat, tick, num, den, tpb, bpm, frametime, nexttime, usecs  = JACK.showtime()
ALSA.start()
while true do
	if beat ~=last_beat then 
		local song = "nathans_song"
		local pitch = mynotes[beat]
		if --[[beat == 5 or]]  bar % 4== 0 then
			if pitch ~= nil then 
			pitch = pitch + 3
			end
		end
		print("I'm about to make a sound?")
		print(beat)
		print(pitch)
		local note = ALSA.noteevent(1,pitch,52,0,.075)
		ALSA.output(note)
		print("I made a noise, apparently")
		last_beat = beat
  end
	local sleep_interval = calculate_sleep_interval(tpb, bpm)
	os.execute("sleep ." .. sleep_interval)
end
