# service-metrics-release

A BOSH release for [service-metrics](https://github.com/pivotal-cf-experimental/service-metrics).

## Running the spec tests

The simplest way to run the spec tests is to use the `fly execute` command with the `ci/release-test.yml` task file, as follows (replace `<PASSWORD>`):

```
CF_API=https://api.cfintegration-eu.cf-app.com \
CF_PASSWORD=<PASSWORD> \
CF_USERNAME=admin \
DOPPLER_ADDR=wss://doppler.cfintegration-eu.cf-app.com:443 \
fly -t london-concourse execute --config ci/release-test.yml --input "develop=." --privileged
```
