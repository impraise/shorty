class CreateShortenedUrlService
  attr_reader :url, :shortcode

  def initialize(shorten_params)
    @url = shorten_params[:url]
    @shortcode = shorten_params[:shortcode]
  end

  def perform
    if shortcode
      raise Shorty::Errors::ExistingShortcodeError.new if shortcode_exists?
      raise Shorty::Errors::InvalidShortcodeError.new unless valid_shortcode?
    else
      generate_shortcode
    end
    
    insert_shortened_url
  end

  private

  def insert_shortened_url
    ShortenedUrl.create(
      url: url,
      shortcode: shortcode,
      start_date: Time.now.utc
    )
  end

  def generate_shortcode
    loop do
      @shortcode = random_shortcode
      break unless shortcode_exists?
    end
  end

  def shortcode_exists?
    !ShortenedUrl[shortcode: shortcode].nil?
  end

  def valid_shortcode?
    !!(shortcode =~ /^[0-9a-zA-Z_]{4,}$/)
  end
  
  def random_shortcode
    allowed = [(0..9), ('a'..'z'), ('A'..'Z'), ['_']].map(&:to_a).flatten
    (1..6).map{ allowed[rand(allowed.size)] }.join
  end
end