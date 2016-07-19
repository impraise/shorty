class Link < ApplicationRecord
  validates :url, presence: true
  validates :code, presence: true
  validates :code, uniqueness: true

  before_validation :generate_code, on: :create, unless: :code

  private

  def generate_code

    begin
      self.code = GenerateShortCode.new.call
    end while self.class.exists?(code: code)
  end
end
