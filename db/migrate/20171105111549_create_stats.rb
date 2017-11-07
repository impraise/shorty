class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.datetime :start_date
      t.integer :redirect_count, default: 0
      t.datetime :last_seen_date
      t.references :short_link, foreign_key: true

      t.timestamps
    end
  end
end
