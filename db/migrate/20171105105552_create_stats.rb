class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.datetime :start_date
      t.integer :redirect_count
      t.datetime :last_seen_date
      t.references :shortlink, foreign_key: true

      t.timestamps
    end
  end
end
