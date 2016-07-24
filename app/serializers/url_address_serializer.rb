class UrlAddressSerializer < ActiveModel::Serializer
  attribute :created_at,     key: 'startDate'
  attribute :updated_at,     key: 'lastSeenDate', if: -> { object.redirect_count > 0 }
  attribute :redirect_count, key: 'redirectCount'
end
