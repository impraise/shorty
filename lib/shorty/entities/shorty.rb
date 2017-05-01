require 'mongoid'

module Shorty
  class Shorty
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: 'shorties'

    validates_uniqueness_of :shortcode

    field :url, type: String
    field :shortcode, type: String
    field :access_count, type: Integer, default: 0

    index({ shortcode: 1 }, unique: true, name: 'shortcode_index')

    create_indexes
  end
end
