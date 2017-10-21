# frozen_string_literal: true

module URLs
  ##
  # Finds ShortUrls
  ##
  class Finder
    # NOTE: Its unclear in the requirements what kind of encoding is
    # used, and hence this workaround is implemented based on the assumtion
    # that it is a Base64 url safe encoding.
    # This method is bound when the requirement is cleared
    #
    # @param short_code [String]
    # @return [ShortUrl]
    # @raise [ActiveRecord::RecordNotFound]
    def self.find!(short_code:)
      decoded_short_code = decode_short_code(short_code: short_code)

      short_url = ShortUrl.where(
        short_code: [short_code, decoded_short_code]
      ).first

      raise ActiveRecord::RecordNotFound,
        "The #{short_code} cannot be found in the system" if short_url.blank?

      short_url
    end

    # @param short_code [String] Base64 endoded string
    # @return [String]
    def self.decode_short_code(short_code:)
      Base64.try(:urlsafe_decode64, short_code)
    rescue ArgumentError
      return
    end
  end
end
