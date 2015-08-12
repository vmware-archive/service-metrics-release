require 'spec_helper'
require 'bosh/template/renderer'
require 'yaml'

describe 'Service Metrics Ctl script' do
  let(:manifest){ YAML.load_file('manifests/service-metrics-lite.yml')}

  before do
    manifest['properties']['service_metrics']['debug'] = false
    manifest['properties']['metron_agent']['dropsonde_incoming_port'] = 12345
  end

  it "templates the value of the interval" do
    renderer = Bosh::Template::Renderer.new({context: manifest.to_json})
    rendered_template = renderer.render('jobs/service-metrics/templates/service_metrics_ctl.erb')

    expect(rendered_template).to include("--metrics-interval 5")
  end

  it "templates the value of the origin" do
    renderer = Bosh::Template::Renderer.new({context: manifest.to_json})
    rendered_template = renderer.render('jobs/service-metrics/templates/service_metrics_ctl.erb')

    expect(rendered_template).to include("--origin example-origin")
  end
end
