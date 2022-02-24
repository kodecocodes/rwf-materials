#!/bin/bash

# Copyright (c) 2021 Razeware LLC
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom
# the Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# Notwithstanding the foregoing, you may not use, copy, modify,
# merge, publish, distribute, sublicense, create a derivative work,
# and/or sell copies of the Software in any work that is designed,
# intended, or marketed for pedagogical or instructional purposes
# related to programming, coding, application development, or
# information technology. Permission for such use, copying,
# modification, merger, publication, distribution, sublicensing,
# creation of derivative works, or sale is expressly withheld.
# 
# This project and source code may use libraries or frameworks
# that are released under various Open-Source licenses. Use of
# those libraries and frameworks are governed by their own
# individual licenses.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

DEBUG=false
if [ "$DEBUG" = true ]; then
	STD_OUT=/dev/tty
else
	STD_OUT=/dev/null
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
	IS_MACOS=true
else
	IS_MACOS=false
fi

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

WANTED_SUBFOLDER_1='.idea'
WANTED_SUBFOLDER_2='.vscode'

WANTED_SUBFOLDER_3='android/app/src/google-services.json'
WANTED_SUBFOLDER_4='ios/Runner/GoogleService-Info.plist'

ARR_WANTED=( 
	"${WANTED_SUBFOLDER_1}"
	"${WANTED_SUBFOLDER_2}"
	"${WANTED_SUBFOLDER_3}"
	"${WANTED_SUBFOLDER_4}"
)

# Get root directory: /mnt/c/scripts/epidemy/
ROOT_DIR="$(dirname "$(dirname "$(dirname "$(echo $SCRIPT_DIR)")")")"

# Double check our core locations aren't empty
[ -z "$ROOT_DIR" ] && echo 'ROOT_DIR variable is unset!' && exit 1
[ -z "$SCRIPT_DIR" ] && echo 'SCRIPT_DIR variable is unset!' && exit 1

# All folders within root (e.g. 01-, 02-, 03-, 04-)
ALL_ROOT=$(find "${ROOT_DIR}" -maxdepth 3 -type d | grep -E '/[0-9]{2}[^/]*/projects/(starter|final|challenge)')

# Just the folders we care about (not template)
FOLDERS=$(printf "${ALL_ROOT}" | grep -v $(printf ${SCRIPT_DIR}))

{
	echo
	echo ===Found Folders===
	echo '(Template)' $SCRIPT_DIR
	echo "${FOLDERS}"

	echo
	echo ===Creating Items===
	printf "${FOLDERS}\n" | while read root ; do

		echo $root
		
		for wanted in "${ARR_WANTED[@]}"; do
			orig_item="${SCRIPT_DIR}/${wanted}"
			dest_item="${root}/${wanted}"
			dest_dir=$(dirname "${dest_item}")
			
			# Ensure template file exists
			if [[ ! -e "${orig_item}" ]]; then
				continue
			fi
			
			# Skip item if there isn't a path to copy destination
			if [ ! -d "${dest_dir}" ]; then
				printf "\tDestination Directory Missing - ${wanted}\n"
				continue
			fi
			
			# =============COPY============= #
			if [ "$IS_MACOS" = true ]; then
				# Doesn't support -T, uses source trailing /
				cp -r "${orig_item}" "${dest_item}"
			else
				# -T to copy entire folder, instead of contents
				cp -rT "${orig_item}" "${dest_item}"
			fi
			printf "\tCreated! - ${wanted}\n" 
			# =============COPY============= #
			
		done
		echo
	done

	echo
	echo ===Issues===

	# Print an error only if we're missing both
	ERR_IF_BOTH_1=(
		"/src/google-services.json$"
		"/Runner/GoogleService-Info.plist$"
	)
	BOTH_MISSING_1=true
	
	# Print an error only if we're missing both
	ERR_IF_BOTH_2=(
		".idea$"
		".vscode$"
	)
	BOTH_MISSING_2=true

	# Don't perform basic missing check on these items
	# Use this if other checks should be used, e.g. ERR_IF_BOTH
	# Uses regex to check, note the $ for EOL and the OR symbol
	NO_ERR="\/(src|Runner)\/(GoogleService-Info.plist|google-services.json)$"
	NO_ERR="${NO_ERR}|\.(vscode|idea)$"

	for wanted in "${ARR_WANTED[@]}"; do
		orig_item="${SCRIPT_DIR}/${wanted}"
		
		# Loop through and check if $wanted matches
		for check in "${ERR_IF_BOTH_1[@]}"; do
		
			# Check current item
			echo "${wanted}" | grep -Eq ${check}

			# Current item is in ERR_IF_BOTH_1
			if [ $? -eq 0 ]; then
			
				# Update flag if item does exist
				[ -e "${orig_item}" ] && BOTH_MISSING_1=false
				
				# End this checker if found a match
				[ "$BOTH_MISSING_1" = false ] && break
			fi
		done		
		
		# Loop through and check if $wanted matches
		for check in "${ERR_IF_BOTH_2[@]}"; do
		
			# Check current item
			echo "${wanted}" | grep -Eq ${check}

			# Current item is in ERR_IF_BOTH_2
			if [ $? -eq 0 ]; then
			
				# Update flag if item does exist
				[ -e "${orig_item}" ] && BOTH_MISSING_2=false
				
				# End this checker if found a match
				[ "$BOTH_MISSING_2" = false ] && break
			fi
		done
		
		# Don't print missing file error,
		# If item path matches NO_ERR pattern
		echo ${wanted} | grep -Eq ${NO_ERR} 
		[ $? -eq 0 ] && continue
		
		# Generic file missing error
		[ ! -e "${orig_item}" ] && echo "${orig_item} Does not exist!" 1>&2
	done

	[ "$BOTH_MISSING_1" = true ] && echo "Your Firebase configuration file(s) couldn’t be found. Please, make sure you have configured at least the dev app for Android or iOS. You won't be able to run the app otherwise." 1>&2 && exit 1
	[ "$BOTH_MISSING_2" = true ] && echo "Your IDE’s custom running configs couldn’t be found. Please, try following the instructions again, or you'll need to run the app from the command line every time by using: flutter run --dart-define=fav-qs-app-token=YOUR_KEY" 1>&2 && exit 1

} > $STD_OUT

echo Done!
exit 0
