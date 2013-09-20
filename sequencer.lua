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
				--- this is in progress (chad)

	-	reimplement the main while true loop as a set of coroutines. This will
		allow me to tune the timing in one function, while dealing with handling
		the notes in another. It should also make the program much more efficient,
		if I am correct
	
	- As I've done with the note names mapping to MIDI note numbers, import the
		actual song data from an external file, turning this sequencer process into
		more of a daemon. In the separate lua file I will define my actual music,
		represented by tables (ala classic tracker almost) or functions. We'll
		re-load the file with each beat or bar, making live-coding possible without
		adding mass overhead. We can change the song we're playing and what that
		song looks like with a simple :w while the main sequencer process is running.


]]


local ALSA = require 'midialsa'
local JACK = require 'liblua_jack'
require 'notes'

JACK.open_client("lua_client")
ALSA.client( 'Lua client', 1, 1, true)
ALSA.connectto(1, 130, 0)
ALSA.connectfrom( 1, 14, 0 )

--[[

notes should be tied to the time at which we'd like them to occur. Functions to
generate these key value pairs will be handy as fuck, and actually the intended
interface with the sequencer. They would return a table injested by the
coroutine responsible for actually sending MIDI events down the tube. Neato.
Won't it be nice when I actually get to that part.

]]

local last_beat
ALSA.start()

function calculate_sleep_interval(tpb, bpm)
	local pre_dec_remove = (tpb * bpm / 60 / 32) 	
											-- ticks per second divided by 32 so I can get 32nd notes

											-- figured out a problem. sleeping is not synced to the beat. 
	local dec_remove = tostring(pre_dec_remove)
	dec_remove = string.gsub(dec_remove, "%p", "")
	local sleep_interval = tonumber(dec_remove)
	return sleep_interval
end


function land_on_subdivision(tbp,bpm)

	-- this function is an attempt to subdivide the beats into 1/32 slices. This
	-- is where we get our quarter, 8th, 16, and 32nd notes.  It is not yet properly implemented.
	-- it needs to know which subdivision we're on and return that. It also needs to be tuned.

	-- It needs to automatically recalibrate itself to the beat once in awhile. 

  ::start::

	local sleep_interval = calculate_sleep_interval(tpb, bpm)
	os.execute("sleep ." .. sleep_interval)

	repeat 
		frame, state, bar, beat, tick, num, den, tpb, bpm, frametime, nexttime, usecs  = JACK.showtime()
	until tick % 60 < 10
	coroutine.yield(bar, beat, tick)
	goto ::start::
end


function lookup_note(note)
	if note == nil then 
	return nil
	end
	local octave = string.match(note, '-?%d')
	octave = tonumber(octave)
	local notename = string.match(note, '^%D+')
	--TODO add error handling here
	local pitch = notes[notename][octave]
	return pitch
end

--[[

Okay, so I'm going to take the timing logic and pull it out of the main loop
and into some coroutines. I'm gonna ditch the while true do, and create two
coroutines. One of them will sleep us until we're close to the desired tick,
wake us up, and continuously query JACK till we're close enough to one of the
1/32 ticks. The other will wake up and spit out the MIDI events applicable to
that tick.

UPDATE and/or TODO I think I need to implement this in C. Implement my own kind
of timer/callback type thing. I'm not getting the speed I need to accurately
catch the ticks without blowing up the CPU. Obviously I need to change
something about my approach. I'll decide on this after some sleep. Maybe I'm
just missing something dumb.

]]

local frame, state, bar, beat, tick, num, den, tpb, bpm, frametime, nexttime, usecs  = JACK.showtime()
sleep = coroutine.create(function land_on_subdivision(tbp,bpm)

function queue_notes(beat, tick)
	if beat ~= nil then
		if beat ~=last_beat then 
			local sub_div = tick / 60
			print(sub_div)
			print(tick)

			print(mynotes[beat])
			local pitch = lookup_note(mynotes[beat])
			if --[[beat == 5 or]]  bar % 4== 0 then
				if pitch ~= nil then 
				pitch = pitch + 3
				end
			end
			print(beat)
			print(pitch)
			local note = ALSA.noteevent(1,pitch,52,0,.075)
			ALSA.output(note)
			last_beat = beat
			end
		end
end
