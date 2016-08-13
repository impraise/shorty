class LinkSerializer < ActiveModel::Serializer
  attribute :created_at, key: 'startDate'
  attribute :updated_at, key: 'lastSeenDate', if: -> { object.redirects.to_i > 0 }
  attribute :redirects,  key: 'redirectCount'

  def redirects
    object.redirects.to_i
  end
end
