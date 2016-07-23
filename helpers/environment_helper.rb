module ShortyService
  module Helpers
    def self.init_environment(env)
      self.set_env(env)

      unless ENV["REDIS_URL"]
        puts "*** Data store error ***"
        puts "You need to set your REDIS_URL in your #{ENV["RACK_ENV"]}.env.sh file"
        puts "See INSTALL.md for reference"
        exit 1
      end

      Redis.connect(ENV.fetch("REDIS_URL"))
    end

    def self.set_env(env)
      filename = env.to_s + ".env.sh"

      if File.exists? filename
        env_vars = File.read(filename)
        env_vars.each_line do |var|
          name, value = var.split("=")
          if name && value
            ENV[name.strip] = value.gsub("\"", "").strip
          end
        end
      end
    end

    def redis
      Redis.client
    end
  end
end
