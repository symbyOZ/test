module Settings
  class App
    def self.redis_connection
      {
        host: ENV['REDIS_HOST'],
        port: ENV['REDIS_PORT'],
        db: ENV['REDIS_DB']
      }
    end
  end
end
