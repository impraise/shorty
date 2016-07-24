class Link < ApplicationRecord
  has_one :stats, class_name: 'LinkStat'

  validates :url, presence: true, format: URI.regexp
  validates :code, presence: true, format: /\A[0-9a-zA-Z_]{4,}\z/
  validates :code, uniqueness: true

  before_validation :generate_code, on: :create, unless: :code

  after_initialize :build_stats_record

  private

  def generate_code
    loop do
      self.code = GenerateShortCode.new.call
      break unless self.class.exists?(code: code)
    end
  end

  def build_stats_record
    build_stats unless stats
  end
end
