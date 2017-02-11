class LinkAccess < ActiveRecord::Base
  belongs_to :encoded_link
  validates_presence_of :encoded_link
end
