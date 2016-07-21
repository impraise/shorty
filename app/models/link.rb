class Link < ApplicationRecord
  validates :url, presence: true, format: URI.regexp
  validates :code, presence: true, format: /\A[0-9a-zA-Z_]{4,}\z/
  validates :code, uniqueness: true

  before_validation :generate_code, on: :create, unless: :code

  private

  def generate_code
    loop do
      self.code = GenerateShortCode.new.call
      break unless self.class.exists?(code: code)
    end
  end
end
