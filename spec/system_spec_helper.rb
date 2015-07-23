ROOT = File.expand_path('..', __dir__)

module Helpers
  def cf_login
    `cf auth admin admin`
  end

  def cf_auth_token
    cf_login
    `cf oauth-token | tail -n 1`.strip!
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  config.full_backtrace = true
end

