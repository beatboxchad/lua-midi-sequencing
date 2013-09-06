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

	-	replace the iterator functions with calls to the new JACK module, which
		returns BBT information as well as the time signature

	- Document the new JACK module

	- Come up with a good way to not flood polls to get JACK transport info.

	- Collapse the data structures for songs, or figure out what's up with that
		too many C levels bit.


]]


local ALSA = require 'midialsa'
local JACK = require 'liblua_jack'

JACK.client_init("lua_client")
ALSA.client( 'Lua client', 1, 1, true)
ALSA.connectto(1, 130, 0)
ALSA.connectfrom( 1, 14, 0 )

local notes = {}
local songs = {}

songs.nathans_song = {}
songs.nathans_song[1] = notes.one
songs.nathans_song[2] = rest
songs.nathans_song[3] = notes.two
songs.nathans_song[4] = nil
songs.nathans_song[5] = notes.three
songs.nathans_song[6] = notes.four
songs.nathans_song[7] = notes.five

notes.one = 42
notes.two = 45
notes.three = 40
notes.four = 40
notes.five = 40

	--[[
	CHAD:
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

	
	--]]
function wait_for_beat_change(beat)
	local frame, state, bar, old_beat, tick, num, den = JACK.showtime() 
	if beat == old_beat then
		return 1
	else
		return 0
	end
end

function checkbeat()
end

while true do
  ALSA.start()
	local frame, state, bar, beat, tick, num, den = JACK.showtime() 
	local song = "nathans_song"
 	local pitch = songs.nathans_song[beat]
  if bar == 5 or measure == 6 then
		if pitch ~= nil then 
		pitch = pitch + 3
    end
	end
	local go = wait_for_beat_change(beat)
	if go == 0 then 
		print("I'm about to make a sound?")
		print(beat)
			local note = ALSA.noteevent(4,pitch,52,0,.075)
			ALSA.output(note)
			print("I made a noise, apparently")
  end
end
