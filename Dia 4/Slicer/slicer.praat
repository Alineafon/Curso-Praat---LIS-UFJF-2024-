# +--------------+
# | slicer.praat |
# +--------------+
#
# author: Pablo Arantes <pablorantes@gmail.com>
# created: 2008-05-05
#
# = Changelog =
# * 2018-10-07: 
#     - updated syntax to colon style
#     - leading and trailing white spaces and newline characters in 
#         non-empty intervals are removed
#     - modified TextGrid is saved
#     - check for repeated labels in non-empty intervals and throw error
#         message when repetition is found
#
# Purpose:
# The scripts takes a sound file that may contain, e.g., a whole
# recorded session with various sentences, slices the original file down,
# writing the sound slices in individual WAV files.
#
# Input:
# A WAV sound file and a previously segmented TextGrid file with matching
# name. The accompanying TextGrid should contain one interval tier. The
# portion of the waveform bounded by each interval will be sliced. Only
# non-empty intervals (i.e., those filled by the user with one or more
# characters) will be sliced. The character string filling a given boundary
# will be used to name the sliced sound enclosed by that boundary.
# 
# Output:
# WAV sound files written in a user-specified directory sliced down
# from a source wav file.
#
# Comments:
# Script file and user files don't need to be in the same file directory.
#
# Copyright (C) 2008-2018  Pablo Arantes
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

form slicer.praat
	comment  Specify audio file path, name and extension
	comment A matching TextGrid file should exist in the same location
	comment If no name is given, the user will be prompted to choose a file from a folder
	sentence Audio /home/paran/Downloads/teste/ACLT.wav
	comment Tier containing slices boundaries
	positive Tier 1
	comment Folder where sliced sound files should go
	sentence Output /home/paran/Downloads/teste/
endform

# Output folder handling
if output$ = ""
	exitScript: "User must specify an output folder."
else
	createDirectory: output$
endif

# User is prompted to choose an audio file if no file name is specified
if audio$ = ""
	audio$ = chooseReadFile$ ("Select a sound file")
endif
audio = Read from file: audio$
total_dur = Get total duration

name$ = selected$("Sound")
path = rindex(audio$, name$)
path$ = left$(audio$, path - 1)

# Make sure matching TextGrid file is available
grid$ = path$ + name$ + ".TextGrid"
readable = fileReadable(grid$)
if readable <> 1
	exitScript: "Cannot find ", grid$, ".", newline$, "There must be a matching TextGrid to the audio file."
endif

# List non-empty intervals in a Table object
grid = Read from file: grid$
sel_tier = Extract one tier: tier
slices = Down to Table: "no", 6, "no", "no"
n = Get number of rows

# Remove leading or trailing spaces and newline chars inserted
# by mistake in the labels by the user
global_change = 0
for i to n
	start = object[slices, i, 1]
	end = object[slices, i, 3]
	slice$ = object$[slices, i, 2]
	len = length(slice$)

	newline_test = index_regex(slice$, "\n+")
	leading_test = index_regex(slice$, "^\s+")
	trailing_test = rindex_regex(slice$, "\s+$")
	has_changed = 0

	if newline_test > 0
		slice$ = replace_regex$(slice$, "\n+", "", 0)
		has_changed += 1
	endif
	if leading_test > 0
		slice$ = replace_regex$(slice$, "^\s+", "", 0)
		has_changed += 1
	endif
	if trailing_test = len
		slice$ = replace_regex$(slice$, "\s+$", "", 0)
		has_changed += 1
	endif

	if has_changed > 0
		global_change += has_changed
		selectObject: grid
		slice_index = Get interval at time: tier, start + (end - start)
		Set interval text: tier, slice_index, slice$
	endif
endfor

# Write modified TextGrid to the source folder if there are changes to labels
# Table is extracted again in case there is a change in the number of
# non-empty boundaries due to removed invisible characters
if global_change > 0
	removeObject: sel_tier, slices
	selectObject: grid
	Save as text file: path$ + name$ + "_slicer.TextGrid"
	sel_tier = Extract one tier: tier
	slices = Down to Table: "no", 6, "no", "no"
	n = Get number of rows
endif

# Report header
writeInfo: ""
appendInfoLine: "slicer.praat"
appendInfoLine: "------------", newline$
appendInfoLine: "Input file: ", grid$
appendInfoLine: "Total duration: ", fixed$(total_dur, 1), " s"
appendInfoLine: "Number of slices: ", n, newline$

for i to n
	slice$ = object$[slices, i, 2]
	start = object[slices, i, 1]
	end = object[slices, i, 3]
	selectObject: sel_tier
	# Check for repeated labels
	repeated = Tabulate occurrences: {tier}, "is equal to", slice$, "no"
	nrep = object[repeated].nrow
	if nrep > 1
		writeInfoLine: "List of repeated labels:"
		for j to nrep
			#Find repeated labels and their location
			rep_time = object[repeated, j, 1]
			rep_lab$ = object$[repeated, j, 3]
			selectObject: grid
			rep_index = Get interval at time: tier, rep_time
			appendInfoLine: "- interval ", rep_index, ", label ", rep_lab$
		endfor
		exitScript: "There are repeated names in tier ", tier, ". Please check the Info window for more information."
	endif
	removeObject: repeated
	# --- end of check
	selectObject: audio
	slice = Extract part: start, end, "rectangular", 1, "no"
	Save as WAV file: output$ + slice$ + ".wav"
	removeObject: slice
	appendInfoLine: "- ", slice$, "(", i, "/", n, ") ",  fixed$(end - start, 3), " s"
endfor

# Clean up
removeObject: audio, grid, sel_tier, slices

# Report
appendInfoLine: newline$, "Run on ", date$()
