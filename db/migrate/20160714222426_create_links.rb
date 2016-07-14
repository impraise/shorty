class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :url
      t.string :shortcode
      t.integer :redirects

      t.timestamps
    end
    add_index :links, :shortcode, unique: true
  end
end
