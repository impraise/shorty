class CreateEncodedLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :encoded_links do |t|
      t.string :url, null: false
      t.string :shortcode, null: false
      t.datetime :last_seen_date
      t.integer :redirect_count, default: 0
    end
  end
end
