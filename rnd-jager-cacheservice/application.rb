require 'sinatra'
require './libs/cache'

class Application < Sinatra::Base
  before do
    @cache = Libs::Cache.new
  end

  get '/' do
    result = @cache.get(params['key'])

    if result
      status 200
      body result
    else
      status 404
      body nil
    end
  end

  post '/' do
    @cache.add(params['key'], request.body.read)

    'ok!'
  end

  get '/invalidate' do
    @cache.delete(params['key'])

    'ok!'
  end
end
