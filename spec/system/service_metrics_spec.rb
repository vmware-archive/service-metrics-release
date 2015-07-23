require 'system_spec_helper'
require 'tempfile'

describe 'service metrics' do

  before(:all) do
    @outFile = Tempfile.new('smetrics')
    @auth_token = cf_auth_token
    @pid = spawn(
      {
        "DOPPLER_ADDR" => "wss://doppler.10.244.0.34.xip.io:443",
        "CF_ACCESS_TOKEN" => @auth_token
      },
      'firehose_sample',
      [:out, :err] => [@outFile.path, 'w']
    )
  end

  after(:all) do
    Process.kill("INT", @pid)
    @outFile.unlink
  end

  it "it emits metrics" do
    @found = false
    60.times do
      if (@outFile.read.include? "foo")
        @found = true
        break
      end
      sleep 1
    end
    expect(@found).to be true
  end
end
