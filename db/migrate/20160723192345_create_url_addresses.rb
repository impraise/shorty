class CreateUrlAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :url_addresses do |t|
      t.text    :url,            null: false
      t.string  :shortcode,      null: false, limit: 6
      t.integer :redirect_count, default: 0

      t.timestamps
    end

    add_index :url_addresses, :shortcode, unique: true
  end
end
