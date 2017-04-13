# service-metrics-release

A BOSH release for [service-metrics](https://github.com/pivotal-cf/service-metrics).

## Running the system tests

1. Deploy this release (and metron_agent) using a manifest similar to the one in `manifests/example_manifest.yml`.
1. `cp .envrc.template .envrc`
1. Fill in the appropriate values for your environment
1. `go get github.com/cloudfoundry/noaa/samples/firehose`
1. `bundle install`
1. `bundle exec rake spec`
