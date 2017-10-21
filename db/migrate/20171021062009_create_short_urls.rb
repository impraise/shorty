class CreateShortUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :short_urls do |t|
      t.string :url, null: false
      t.string :short_code, null: false
      t.integer :redirect_count, null: false, default: 0
      t.timestamp :start_date, null: false
      t.timestamp :last_seen_date
    end
  end
end
