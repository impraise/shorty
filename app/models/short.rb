class Short < ActiveRecord::Base

  before_validation :check_shortcode

  validates :url, presence: { message: "url is not present" }

  validates :shortcode,
            uniqueness: {
              message: "The the desired shortcode is already in use. Shortcodes are case-sensitive."
            }

  validates_format_of :shortcode,
                      with: /\A[0-9a-zA-Z_]{6}\z/,
                      message: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{6}$"

  def increment_count!
    self.increment!(:redirect_count)
  end

  private

  # generate a shortcode if one is not provided
  def check_shortcode
    self.shortcode ||= new_shortcode
  end

  # generates a random shortcode of exactly 6 alpahnumeric characters
  # and passes the following regexp: ^[0-9a-zA-Z_]{6}$
  def new_shortcode
    begin
      random_shortcode = SecureRandom.urlsafe_base64(4)
      match = !( /\A[0-9a-zA-Z_]{6}\z/ =~ random_shortcode ).nil?
      available = !Short.exists?(shortcode: random_shortcode)
    end until match && available
    random_shortcode
  end

end
