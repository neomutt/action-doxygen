#!/bin/bash

# exit early if any command fails
set -e

VERSION=$(git describe --abbrev=6 --match "20*" HEAD)

pushd code

# Remove the old docs
git rm -r --quiet ./*

# Add the newly generated docs
rsync -a ../html/ .

git add .
git commit -m "[AUTO] NeoMutt $VERSION"

popd

