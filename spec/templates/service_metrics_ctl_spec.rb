require 'spec_helper'
require 'bosh/template/renderer'
require 'yaml'

describe 'Service Metrics Ctl script' do
  let(:renderer) do
    Bosh::Template::Renderer.new(
      context: BoshEmulator.director_merge(
        YAML.load_file(manifest_file.path), 'service-metrics'
      ).to_json
    )
  end
  let(:rendered_template) { renderer.render('jobs/service-metrics/templates/service_metrics_ctl.erb') }

  after(:each) { manifest_file.close }


  context 'with a valid manifest' do
    let(:manifest_file) { File.open('spec/templates/fixtures/valid_manifest.yml') }

    it 'templates the value of the origin' do
      expect(rendered_template).to include('--origin service-metrics')
    end

    context 'when properties with defaults are not configured' do
      it 'templates the default dropsonde_incoming_port' do
        expect(rendered_template).to include('--metron-addr localhost:3457')
      end

      it 'templates the default metrics_command' do
        expect(rendered_template).to include('--metrics-cmd /var/vcap/jobs/service-metrics-adapter/bin/collect-service-metrics')
      end

      it 'does not template any metrics_command_args' do
        expect(rendered_template).not_to include('--metrics-cmd-arg')
      end

      it 'templates the default execution_interval_seconds' do
        expect(rendered_template).to include('--metrics-interval 60')
      end

      it 'does not template the debug flag' do
        expect(rendered_template).not_to include('--debug')
      end
    end
  end

  context 'with optional fields configured in the manifest' do
    let(:manifest_file) { File.open('spec/templates/fixtures/valid_manifest_with_optional_fields.yml') }

    it 'templates the configured execution_interval_seconds' do
      expect(rendered_template).to include('--metrics-interval 5')
    end

    it 'templates the configured metrics_command' do
      expect(rendered_template).to include('--metrics-cmd /bin/echo')
    end

    it 'templates all the configured metrics_command_args' do
      expect(rendered_template).to include(%Q{--metrics-cmd-arg '-n' --metrics-cmd-arg '[{"key":"service-dummy","value":99,"unit":"metric"}]'})
    end

    it 'templates the configured dropsonde_incoming_port' do
      expect(rendered_template).to include('--metron-addr localhost:1234')
    end

    it 'templates the configured debug flag' do
      expect(rendered_template).to include('--debug')
    end
  end
end
