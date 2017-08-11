#!/bin/bash -eu

# Copyright (C) 2015-Present Pivotal Software, Inc. All rights reserved.
# This program and the accompanying materials are made available under the terms of the under the Apache License, Version 2.0 (the "License”); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

set -o pipefail

pushd $(dirname $0)/../.. > /dev/null
  export GOPATH=$PWD
  export PATH=$GOPATH/bin:$PATH

  pushd src/github.com/pivotal-cf/service-metrics > /dev/null
    go get github.com/tools/godep
    godep restore ./...

    go install github.com/onsi/ginkgo/ginkgo

    ./scripts/run-tests.sh
  popd > /dev/null
popd > /dev/null

bats ./src/utils/test/*
