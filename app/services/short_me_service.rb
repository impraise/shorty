require './app/data/validator/validator'
require './app/data/repositories/repository'

class ShortMeService

  def create(url, shortcode)
    shortcode = generate_shortcode if shortcode.nil?

    Repository.for(:shortme).create(url, shortcode)
  end

  def get(shortcode)
    Repository.for(:shortme).get(shortcode)
  end

  def update(shortcode)
    update_counter shortcode
    update_last_seen_date shortcode
  end

  def get_stats(shortcode)
    short_me_model = get shortcode

    return nil if short_me_model.nil?

    response = Hash.new
    response[:startDate] = short_me_model.start_date
    response[:lastSeenDate] = short_me_model.last_seen_date unless short_me_model.redirect_count == 0
    response[:redirectCount] = short_me_model.redirect_count

    response
  end

  private

  def generate_shortcode
    shortcode = SecureRandom.urlsafe_base64(4)

    if shortcode.include?("-") || Validator.exists?(shortcode)
      return generate_shortcode
    end

    shortcode
  end

  def update_counter(short_me_model)
    Repository.for(:shortme).set(short_me_model, :redirect_count, short_me_model.redirect_count + 1)
  end

  def update_last_seen_date(short_me_model)
    Repository.for(:shortme).set(short_me_model, :last_seen_date, Time.now.utc.iso8601)
  end
end
