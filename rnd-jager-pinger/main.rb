require 'sinatra'

require 'yaml'
require 'json'

require 'faraday'
require 'faraday/tracer'

require 'opentracing'
require 'jaeger/client'
require 'rack/tracer'

config = YAML.load(File.read(File.join(__dir__, 'config', 'config.yaml')))

OpenTracing.global_tracer = Jaeger::Client.build(host: config['jaeger-host'],
                                                 port: config['jaeger-port'],
                                                 service_name: config['service-name'])

use Rack::Tracer

set :port, 7000

get '/' do
  {
    dataservice: healthcheck(config['dataservice-host'], config['dataservice-port']),
    frontend: healthcheck(config['frontend-host'], config['frontend-port']),
    loadbalancer: healthcheck(config['loadbalancer-host'], config['loadbalancer-port']),
    wrong: healthcheck(config['wrong-host'], config['wrong-port'])
  }.to_json
end

def healthcheck(host, port)
  conn = Faraday.new(url: "#{host}:#{port}") do |faraday|
    faraday.use Faraday::Tracer, span: request.env['rack.span']

    faraday.request :url_encoded
    faraday.adapter Faraday.default_adapter
  end

  conn.get('/healthcheck').status
rescue Faraday::ConnectionFailed => e
  404
end
