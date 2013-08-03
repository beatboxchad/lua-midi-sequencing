#!/usr/bin/env lua

--[[
This will contain all the stuff I plan to reuse with each script.

* Functions to count what beat we're on, what measure we're on, and what chunk
  we're on.

*	Functions to grab tempo from JACK transport, which will probably require some
	C development. Or, I can use midi clock, if I find some piece of software
	which has done the heavy lifting for me.
	
*	functions to actually play notes, maybe skeletons of different phrasings or
	time signatures - I haven't figured that out yet, I'll come up with the best
	way to do it by actually playing music.

]]
