#!/bin/bash -eu
set -o pipefail

# This doesn't feel very robust. We could get noaa as a git resource, or fix the
# version using a noaa submodule pointer.
go get github.com/cloudfoundry/noaa/samples/firehose

pushd $(dirname $0)/../..
  bundle install
  bundle exec rake spec
popd
