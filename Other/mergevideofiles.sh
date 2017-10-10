# This script goes over all subdirectories in a certain directory and encodes + concatenates the video files it finds in these subdirectories (1 concatenation per subdirectory).
# The concatenated video file has the same name as the subdirectory

#!/bin/bash

# For loop over all subdirectories
for d in ./*/; do
	cd "$d"

	# For loop to encode all video files found to proper mp4 files
	count=1
		for i in *.mp4; do
		  name=`echo $i | cut -d'.' -f1`
		  echo $name
		  ffmpeg -i "$i" "video${count}.mp4"
		  count=$((count + 1))
		done

	# Delete all video files that aren't the actual encoded files through reverse matching with grep
	ls | grep -v 'video*' | xargs rm

	# Create a list of filenames
	find *.mp4 | sed 's:\ :\\\ :g'| sed 's/^/file /' > list.txt

	# Use this list in the ffmpeg concat demuxer to concatenate all video files, give it the same name as the current working directory
	ffmpeg -f concat -safe 0 -i list.txt -c copy ${PWD##*/}.mp4

	# Delete everything except concatenated file
	ls | grep -v ${PWD##*/}.mp4 | xargs rm

	cd ..
done
