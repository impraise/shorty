require 'sequel'

module ShortyUrl
  class LinksStorage
    def initialize
      @params = settings[ENV['environment']]
      validate_params

      Sequel.default_timezone = :utc

      create_links_table
      @links_table = connection[:links]
    end

    def add(shortcode, url)
      @links_table.insert(shortcode: shortcode, url: url, start_date: Time.now)
    end

    def update(shortcode, params)
      @links_table.where(shortcode: shortcode).update(params)
    end

    def find(shortcode)
      @links_table.first(shortcode: shortcode)
    end

    def delete(shortcode)
      @links_table.where(shortcode: shortcode).delete
    end

    def clear!
      @links_table.delete
    end

    private

    def settings
      @settings ||= YAML.load_file(File.join(File.dirname(__FILE__), 'settings.yml'))
    end

    def connection
      @connection ||= Sequel.postgres(
        @params['db_name'],
        user: @params['user'],
        password: @params['password'],
        host: 'localhost'
      )
    end

    def validate_params
      %w(db_name user password).each do |property|
        error = 'You need to set such ENV variables: db_name, user, password'
        raise DbParamsAreNotValid, error if @params[property].nil?
      end
    end

    def create_links_table
      connection.create_table? :links do
        primary_key :id
        String :url
        String :shortcode, size: 6

        DateTime :start_date, default: Time.now
        DateTime :last_seen_date
        Integer :redirect_count, default: 0
      end
    end
  end
end
