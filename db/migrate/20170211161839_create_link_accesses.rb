class CreateLinkAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :link_accesses do |t|
      t.integer :encoded_link_id, null: false
      t.datetime :created_at, null: false
    end
  end
end
