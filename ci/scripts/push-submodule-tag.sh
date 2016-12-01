#!/bin/bash -eu
set -o pipefail

RELEASE_DIR=$(pwd)/broker-final-tag
SUBMODULE_DIR=$RELEASE_DIR/$SUBMODULE_PATH
TAG_DIR=$(pwd)/$TAG_PATH

RELEASE_TAG="$(git -C "$RELEASE_DIR" tag --list 'v*' --contains HEAD --sort=version:refname | tail -n1)"
SUBMODULE_TAG="$(git -C "$SUBMODULE_DIR" tag --list 'v*' --contains HEAD --sort=version:refname | tail -n1)"
if [ "$SUBMODULE_TAG" != "$RELEASE_TAG" ]; then
  git -C "$SUBMODULE_DIR" tag "$RELEASE_TAG"
fi
git clone "$SUBMODULE_DIR" "$TAG_DIR"
