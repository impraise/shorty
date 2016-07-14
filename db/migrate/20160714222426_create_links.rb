class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :url
      t.string :shortcode, index: true
      t.integer :redirects

      t.timestamps
    end
  end
end
