class EncodedLink < ActiveRecord::Base
  validates_presence_of :shortcode, :url
end
