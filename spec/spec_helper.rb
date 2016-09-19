require 'yaml'

require 'bosh/template/renderer'
require 'bosh/template/property_helper'

ROOT = File.expand_path('..', __dir__)

module Helpers
  module Environment
    def cf_api
      ENV['CF_API'] || 'https://api.10.244.0.34.xip.io'
    end

    def cf_username
      ENV['CF_USERNAME'] || "admin"
    end

    def cf_password
      ENV['CF_PASSWORD'] || "admin"
    end

    def doppler_address
      ENV['DOPPLER_ADDR'] || "wss://doppler.10.244.0.34.xip.io:443"
    end

    def deployment_name
      ENV.fetch('DEPLOYMENT_NAME')
    end

    def target_cf
      `cf api --skip-ssl-validation #{cf_api}`
    end

    def cf_login
      `cf auth #{cf_username} #{cf_password}`
    end

    def cf_auth_token
      target_cf
      cf_login
      `cf oauth-token | tail -n 1`.strip!
    end
  end
end

class BoshEmulator
  extend ::Bosh::Template::PropertyHelper

  def self.director_merge(manifest, job_name)
    manifest_properties = manifest['properties']

    job_spec = YAML.load_file("jobs/#{job_name}/spec")
    spec_properties = job_spec['properties']

    effective_properties = {}
    spec_properties.each_pair do |name, definition|
      copy_property(effective_properties, manifest_properties, name, definition['default'])
    end

    manifest.merge({'properties' => effective_properties})
  end
end

RSpec.configure do |config|
  config.include Helpers::Environment
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  config.full_backtrace = true
  config.color = true
end
