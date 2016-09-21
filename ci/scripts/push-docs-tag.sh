#!/bin/bash -eu
set -o pipefail

RELEASE_DIR=$(pwd)/metrics-final-tag
DOCS_DIR=$RELEASE_DIR/docs
TAG_DIR=$(pwd)/docs-with-tag

RELEASE_TAG="$(git -C "$RELEASE_DIR" tag --list 'v*' --contains HEAD)"
git -C "$DOCS_DIR" tag "$RELEASE_TAG"
git clone "$DOCS_DIR" "$TAG_DIR"
