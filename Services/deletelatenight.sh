#!/bin/bash
# This script deletes episodes from late night talkshows (Full Frontal with Samantha Bee, Late Show with Stephen Colbert, Daily Show, Opposition with Jordan Klepper, The Jim Jefferies Show, Last Week Tonight with John Oliver, The President Show)

#############
# Variables #
#############
DELETE_LOG="/home/fileserver/Applications/deletelatenight/deletelatenight.log"
LATENIGHT_FOLDERS=("Full Frontal with Samantha Bee" "The President Show" "The Late Show with Stephen Colbert" "The Daily Show" "The Opposition with Jordan Klepper" "The Jim Jefferies Show" "Last Week Tonight with John Oliver")

#############
# Functions #
#############

function find_last_season() {
	# -maxdepth 1 				-> only search in current folder
	# -type d 					-> list only directories
	# -wholename "*Season*"		-> only list directories with "Season" in their name
	# sort -V 					-> do a version sort (will keep in mind the natural order of numbers, does not just sort alphabetically)
	# tail -n 1					-> Only show last directory in this list (aka, the last season)

   find . -maxdepth 1 -type d -wholename "*Season*" | sort -V | tail -n 1
}

function list_episodes() {
	# -maxdepth 1 		-> only search in current folder
	# -type f 			-> list only files
	# -printf '%C@ %P\n'
		# %T@ 			-> show file's last modification time in seconds since 1970.
		# %P 			-> show the file name
	# | sort -V 		-> do a version sort (will keep in mind the natural order of numbers, does not just sort alphabetically)
	# | cut -d' ' -f2-	-> drop the seconds form output, leave only the filename
	# | head -n -2 		-> show all but the last two lines (so everything except the 2 most recent episodes)
	# xargs rm -rf 		-> delete the episodes found using this sort

	find . -maxdepth 1 -type f -printf '%T@ %P\n' | sort -V | cut -d' ' -f2- | head -n -2
}

#################
# Delete script #
#################

# Start logging
printf "Starting deletion of Late Night Episodes. Time & Date right now is $(date)\n" >> $DELETE_LOG 2>&1

# Go over all the latenight folders as defined in the variable
for i in "${LATENIGHT_FOLDERS[@]}"; do

		printf "Starting deletion of $i\n" >> $DELETE_LOG 2>&1

		# Go into directory of late night show
		cd "/home/fileserver/Media/TVShows/$i"

		# Find the last season and cd into the last season directory
		last_season=$(find_last_season)
		cd "$last_season"

		# Delete all but most recent 2 episodes
		episodes=$(list_episodes)

		printf "Will now delete the following episodes of $last_season: $episodes\n" >> $DELETE_LOG 2>&1
		rm -rf $episodes
	
	done

#################
# Update Sonarr #
#################

printf "Deletion of all episodes is done. Will now send a request to sonarr to scan disk\n" >> $DELETE_LOG 2>&1

# Sends a curl post request to sonarr api to rescan series on disk
echo '{"name":"RescanSeries"}' | curl -d @- http://localhost:8081/sonarr/api/command?apikey=9bb6f10e192944bb974e4e7ce2e6fafe --header "X-Api-Key:9bb6f10e192944bb974e4e7ce2e6fafe" >> $DELETE_LOG 2>&1

printf "Deletion done \n\n" >> $DELETE_LOG 2>&1