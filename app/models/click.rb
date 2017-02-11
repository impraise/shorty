class Click < Sequel::Model
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  many_to_one :link

  def validate
    super
    validates_presence :link_id
  end
end
