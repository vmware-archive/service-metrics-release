#!/bin/bash -eu
set -o pipefail

RELEASE_DIR=$(pwd)/metrics-final-tag
METRICS_DIR=$RELEASE_DIR/src/github.com/pivotal-cf-experimental/service-metrics
TAG_DIR=$(pwd)/metrics-with-tag

RELEASE_TAG="$(git -C "$RELEASE_DIR" tag --list 'v*' --contains HEAD)"
git -C "$METRICS_DIR" tag "$RELEASE_TAG"
git clone "$METRICS_DIR" "$TAG_DIR"
