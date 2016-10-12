#!/bin/bash -eu
set -o pipefail

if [ -z "$GOPATH" ]; then
  echo "GOPATH must be set" >&2
  exit 1
fi

gopath_project=$GOPATH/src/github.com/pivotal-cf-experimental/service-metrics

pushd $gopath_project > /dev/null
./scripts/run-tests.sh
popd > /dev/null
