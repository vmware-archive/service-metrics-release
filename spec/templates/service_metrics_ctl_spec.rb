# Copyright (C) 2015-Present Pivotal Software, Inc. All rights reserved.
# This program and the accompanying materials are made available under the terms of the under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

require 'spec_helper'
require 'bosh/template/test'
require 'yaml'

describe 'Service Metrics Ctl script' do
  before(:all) do
    release_path = File.join(File.dirname(__FILE__), '../..')
    release = Bosh::Template::Test::ReleaseDir.new(release_path)
    job = release.job('service-metrics')
    @template = job.template('bin/service_metrics_ctl')
  end

  it 'templates the origin' do
    properties = job_properties(origin: 'some-origin')
    control_script = @template.render(properties)
    expect(control_script).to include('--origin some-origin')
  end

  context 'when optional properties are not configured' do
    before(:all) do
      properties = job_properties(origin: 'some-origin')
      @control_script = @template.render(properties)
    end

    it 'templates the default dropsonde_incoming_port' do
      expect(@control_script).to include('--metron-addr localhost:3457')
    end

    it 'templates the default metrics_command' do
      expect(@control_script).to include(
        '--metrics-cmd /var/vcap/jobs/service-metrics-adapter/bin/collect-service-metrics')
    end

    it 'does not template any metrics_command_args' do
      expect(@control_script).not_to include('--metrics-cmd-arg')
    end

    it 'templates the default execution_interval_seconds' do
      expect(@control_script).to include('--metrics-interval 60')
    end

    it 'does not template the debug flag' do
      expect(@control_script).not_to include('--debug')
    end
  end

  context 'when optional properties are configured in the manifest' do
    before(:all) do
      properties = job_properties(
        origin: 'some-origin',
        execution_interval_seconds: 5,
        metrics_command: '/bin/echo',
        metrics_command_args: ['-n', '[{"key":"service-dummy","value":99,"unit":"metric"}]'],
        dropsonde_incoming_port: 1234,
        debug: true
      )
      @control_script = @template.render(properties)
    end

    it 'templates the configured execution_interval_seconds' do
      expect(@control_script).to include('--metrics-interval 5')
    end

    it 'templates the configured metrics_command' do
      expect(@control_script).to include('--metrics-cmd /bin/echo')
    end

    it 'templates all the configured metrics_command_args' do
      expect(@control_script).to include(
        %Q{--metrics-cmd-arg '-n' --metrics-cmd-arg '[{"key":"service-dummy","value":99,"unit":"metric"}]'})
    end

    it 'templates the configured dropsonde_incoming_port' do
      expect(@control_script).to include('--metron-addr localhost:1234')
    end

    it 'templates the configured debug flag' do
      expect(@control_script).to include('--debug')
    end
  end
end

def job_properties(origin:, execution_interval_seconds: nil, metrics_command: nil,
  metrics_command_args: nil, dropsonde_incoming_port: nil, debug: nil)
  {
    'service_metrics' => {
      'origin' => origin,
      'execution_interval_seconds' => execution_interval_seconds,
      'metrics_command' => metrics_command,
      'metrics_command_args' => metrics_command_args,
      'debug' => debug
    },
    'metron_agent' => {
      'dropsonde_incoming_port' => dropsonde_incoming_port
    }
  }
end
