class CreateLinkStats < ActiveRecord::Migration[5.0]
  def change
    create_table :link_stats do |t|
      t.integer :link_id, null: false
      t.index :link_id, unique: true
      t.datetime :last_seen_at
      t.integer :showed_count, default: 0

      t.timestamps
    end
  end
end
