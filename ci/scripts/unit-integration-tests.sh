#!/bin/bash -eu
set -o pipefail

if [ -z "$GOPATH" ]; then
  echo "GOPATH must be set" >&2
  exit 1
fi

gopath_org=$GOPATH/src/github.com/pivotal-cf-experimental
gopath_project=$gopath_org/service-metrics

mkdir -p $gopath_org
mv service-metrics-release/src/service-metrics $gopath_org/

pushd $gopath_project > /dev/null
./scripts/run-tests.sh
popd > /dev/null
