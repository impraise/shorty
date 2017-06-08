class CreateShorties < ActiveRecord::Migration[5.1]
  def change
    create_table :shorties do |t|
      t.string :url, null: false
      t.string :shortcode, null: false
      t.integer :redirect_count, default: 0
      t.datetime :created_at
      t.datetime :last_seen_at
    end
  end
end
