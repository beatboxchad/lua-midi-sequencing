-- see lookup_note in sequencer.lua, this is a matrix mapping note names like
-- Cs4 (C# in the fourth octave) and Bb-3 (Bb in the negative-third octave) to
-- their corresponding MIDI note numbers. For we musicians who find it much
-- easier to think in those terms.

notes = {"C", "Cs", "Db", "Ds", "D", "Eb", "E", "F", "Fs", "Gb", "G", "Gs", "Ab", "A", "As", "Bb", "B",}

notes.C = {0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120}
notes.Cs = {1, 13, 25, 37, 49, 61, 73, 85, 97, 109, 121}
notes.Db = {1, 13, 25, 37, 49, 61, 73, 85, 97, 109, 121}
notes.Ds = {3, 15, 27, 39, 51, 63, 75, 87, 99, 111, 123}
notes.D = {2, 14, 26, 38, 50, 62, 74, 86, 98, 110, 122}
notes.Eb = {3, 15, 27, 39, 51, 63, 75, 87, 99, 111, 123}
notes.E = {4, 16, 28, 40, 52, 64, 76, 88, 100, 112, 124}
notes.F = {5, 17, 29, 41, 53, 65, 77, 89, 101, 113, 125}
notes.Fs = {6, 18, 30, 42, 54, 66, 78, 90, 102, 114, 126}
notes.Gb = {6, 18, 30, 42, 54, 66, 78, 90, 102, 114, 126}
notes.G = {7, 19, 31, 43, 55, 67, 79, 91, 103, 115, 127}
notes.Gs = {8, 20, 32, 44, 56, 68, 80, 92, 104, 116}
notes.Ab = {8, 20, 32, 44, 56, 68, 80, 92, 104, 116}
notes.A = {9, 21, 33, 45, 57, 69, 81, 93, 105, 117}
notes.As = {10, 22, 34, 46, 58, 70, 82, 94, 106, 118}
notes.Bb = {10, 22, 34, 46, 58, 70, 82, 94, 106, 118}
notes.B = {11, 23, 35, 47, 59, 71, 83, 95, 107, 119}



songs = {}

--generic song template, spits out a blank one. These could also be shorter phrases - the way I'm gonna work, they will always be.

function new_song(bars)
	local song = {}	
	for bar = 1, bars do
		for note = 1, 32 do
		song[bar][note] = nil
		end
	end
	return song
end

mynotes = {"A4", "C4", "G4", "G4", "G4", "G4", "E4", "F4", "G4"}

songs.chad_

local subdivisions = {60, 120, 180, 240, 300, 360, 420, 480, 540, 600, 660, 720, 780, 840, 900, 960, 1020, 1080, 1140, 1200, 1260, 1320, 1380, 1440, 1500, 1560, 1620, 1680, 1740, 1800, 1860, 1920,}
