class CreateLinkService
  def call(url:, shortcode: nil)
    raise ApiErrors::UrlNotPresent if url.blank?

    Link.create!(url: url, code: shortcode)
  rescue ActiveRecord::RecordInvalid => e
    errors = e.record.errors.details

    errors[:code] && errors[:code].each do |payload|
      raise(ApiErrors::CodeTaken) if payload[:error] == :taken
      raise(ApiErrors::InvalidCode) if payload[:error] == :invalid
    end

    raise(ApiErrors::Error, 'Data not formatted properly')
  end
end
