require 'system_spec_helper'
require 'tempfile'

describe 'service metrics' do

  before(:all) do
    @outFile = Tempfile.new('smetrics')
    @pid = spawn(
      {
        "DOPPLER_ADDR" => doppler_address,
        "CF_ACCESS_TOKEN" => cf_auth_token
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
      if (@outFile.read.include? 'name:"service-dummy"')
        @found = true
        break
      end
      sleep 1
    end
    expect(@found).to be true
  end
end
