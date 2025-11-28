#!/bin/bash

set -o errexit	# set -e
set -o nounset	# set -u

if [ $# -ne 2 ]; then
	echo "Usage: ${0##*/} SRC DST"
	exit 1
fi

SRC="$1"
DST="$2"

if ! [ -d "$SRC" ]; then
	echo "Source doesn't exist: $SRC"
	exit 1
fi

if ! [ -d "$DST" ]; then
	echo "Destination doesn't exist: $DST"
	exit 1
fi

echo "Copying HTML from $SRC to $DST";

pushd "$SRC" > /dev/null
VERSION=$(git describe --abbrev=6 --match "20*" HEAD)
echo "Version: $VERSION"
popd > /dev/null

pushd "$DST" > /dev/null

# Remove the old docs
echo -n "Removing old files... "
find . -name '*.css' -o -name '*.html' -o -name '*.js' -o -name '*.map' -o -name '*.md5' -o -name '*.png' -o -name '*.search' -o -name '*.svg' | xargs git rm --quiet
echo "done"

# Add the newly generated docs
echo -n "Copying files... "
rsync -a "../$SRC/" .
echo "done"

echo -n "Adding files to git... "
git add .
echo "done"

# Check for changes
if ! git diff-index --quiet HEAD; then
	git commit --quiet -m "[AUTO] NeoMutt $VERSION"
	git log --oneline -n 1
else
	echo "No changes"
fi

popd > /dev/null

