# Copyright (C) 2015-Present Pivotal Software, Inc. All rights reserved.
# This program and the accompanying materials are made available under the terms of the under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

require 'tempfile'

describe 'service metrics' do

  before(:all) do
    @outFile = Tempfile.new('smetrics')
    @pid = spawn(
      {
        "DOPPLER_ADDR" => doppler_address,
        "CF_ACCESS_TOKEN" => cf_auth_token
      },
      'firehose',
      [:out, :err] => [@outFile.path, 'w']
    )

    @metric_entry = find_metric_entry(@outFile)
    expect(@metric_entry).to_not be_nil
  end

  after(:all) do
    Process.kill("INT", @pid)
    @outFile.unlink
  end

  it "it emits metrics" do
    expect(@metric_entry).to match(/name:"service-dummy"/)
  end

  it "it emits the origin" do
    expect(@metric_entry).to match(/origin:"#{deployment_name}"/)
  end

  it "it emits ip" do
    expect(@metric_entry).to match(/ip:"/)
  end

  it "it emits job" do
    expect(@metric_entry).to match(/job:"service-metrics"/)
  end

  it "it emits index" do
    expect(@metric_entry).to match(/index:".*"/)
  end

  it "it emits deployment" do
    expect(@metric_entry).to match(/deployment:"#{deployment_name}"/)
  end

  def find_metric_entry(firehose_out_file)
    metric_entry = nil

    60.times do
      firehose_out_file.read.lines.each do | line |
        line.force_encoding("utf-8")
        if line =~ /origin:"#{deployment_name}".*name:"service-dummy"/
          metric_entry = line
          break
        end
      end
      metric_entry ? break : sleep(1)
    end

    return metric_entry
  end
end
