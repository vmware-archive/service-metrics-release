require 'spec_helper'
require 'bosh/template/renderer'
require 'yaml'

describe 'Service Metrics Ctl script' do
  let(:manifest){ YAML.load_file('manifests/service-metrics-lite.yml')}

  describe "metrics-interval" do
    context "when no value provided in deployment manifest" do

      before do
        manifest['properties']['service_metrics']['debug'] = false
        manifest['properties']['service_metrics']['interval'] = nil
      end

      #TODO combine the manifest / spec to pass all properties to the template
      xit "defaults to 60 seconds" do
        renderer = Bosh::Template::Renderer.new({context: manifest.to_json})

        rendered_template = renderer.render('jobs/service-metrics/templates/service_metrics_ctl.erb')

        expect(rendered_template).to include("--metrics-interval 60")
      end
    end

    context "when a value is provided in the deployment manifest" do

      before do
        manifest['properties']['service_metrics']['debug'] = false
        manifest['properties']['service_metrics']['interval'] = 5
        manifest['properties']['metron_agent']['dropsonde_incoming_port'] = 12345
      end

      it "uses the value in the argument to the binary" do
        renderer = Bosh::Template::Renderer.new({context: manifest.to_json})

        rendered_template = renderer.render('jobs/service-metrics/templates/service_metrics_ctl.erb')

        expect(rendered_template).to include("--metrics-interval 5")
      end

    end
  end
end
