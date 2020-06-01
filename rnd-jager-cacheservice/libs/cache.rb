require 'redis'
require './settings/app'


module Libs
  class Cache
    def initialize
      conf = Settings::App.redis_connection

      @connection = Redis.new host: conf[:host], port: conf[:port], db: conf[:db]
    end

    def add(key, value)
      @connection.set(key, value)
    end

    def get(key)
      @connection.get(key)
    end

    def delete(key)
      @connection.del(key)
    end
  end
end
