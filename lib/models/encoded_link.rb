class EncodedLink < ActiveRecord::Base
  validates_presence_of :shortcode, :url
  validates_uniqueness_of :shortcode
end
