require './app/data/repositories/repository'
require './app/models/short_me'
require 'time'

class ShortMeRepository < Repository

  private def model_class
    ShortMe
  end

  def create(url, shortcode)
    model_class.create(url: url, shortcode: shortcode, start_date: Time.now.utc.iso8601, last_seen_date: nil, redirect_count: 0)
  end

  def get(shortcode)
    model_class.find_by(shortcode: shortcode)
  end

  def set(model, column, value)
    model.update(column => value)
  end

end
