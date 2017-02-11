class AddCreatedAtToEncodedLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :encoded_links, :created_at, :datetime
  end
end
