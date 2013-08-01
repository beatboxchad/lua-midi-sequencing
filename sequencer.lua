#!/usr/bin/env lua

--[[
now that I have figured out the structure of note events, note-on and note-off, I'm excited. The next step, I'm not clear on, but here are some future steps:

the next step is to synthesize my own event
create functions that 
]]

local ALSA = require 'midialsa'
ALSA.client( 'Lua client', 1, 1, false )

ALSA.connectto(1, 129, 0)
ALSA.connectfrom( 1, 14, 0 )

while true do
	local alsaevent = ALSA.input()
	print(unpack(alsaevent))
	print(unpack(alsaevent[8]))
	print(unpack(alsaevent[7]))
	print(unpack(alsaevent[6]))
	ALSA.output(alsaevent)
end

