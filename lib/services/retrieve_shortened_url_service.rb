class RetrieveShortenedUrlService
  attr_reader :shortcode, :model

  def initialize(shortcode)
    @shortcode = shortcode
    @model = get_shortened_url
  end

  def perform
    raise Shorty::Errors::NotFoundShortcodeError.new unless model
    update_url_stats
    model
  end

  private

  def get_shortened_url
    ShortenedUrl[shortcode: shortcode]
  end

  def update_url_stats
    model.update(
      redirect_count: model.redirect_count + 1,
      last_seen_date: Time.now.utc
    )
  end
end