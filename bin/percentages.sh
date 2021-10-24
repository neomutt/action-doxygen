#!/bin/bash

set -o errexit	# set -e
set -o nounset	# set -u

BASE_DIR="${0%/*}"

SRC="$BASE_DIR/percentages.txt"
DST="gfx"

if ! [ -r "$SRC" ]; then
	echo "Can't read: '$SRC'"
	exit 1
fi

if ! [ -r "$DST" ]; then
	echo "Destination doesn't exist: '$DST'"
	exit 1
fi

sort -nr -k2 "$SRC" | while read -r NAME NUM; do
	if [ "$NUM" -gt 49 ]; then
		COLOUR=green
	elif [ "$NUM" -gt 24 ]; then
		COLOUR=yellow
	else
		COLOUR=red
	fi
	wget --quiet -O "gfx/$NAME.svg" "https://img.shields.io/badge/${NAME}-${NUM}%-${COLOUR}.svg"
	echo ' * <img style="float: left; padding-right: 0.5em;" src="'"$NAME"'.svg">'
done

