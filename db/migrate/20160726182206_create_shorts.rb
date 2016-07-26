class CreateShorts < ActiveRecord::Migration
  def change
    create_table :shorts do |t|
      t.text    :url,            null: false
      t.string  :shortcode,      null: false
      t.integer :redirect_count, default: 0

      t.timestamps null: false
    end

    add_index :shorts, :shortcode, unique: true
  end
end
