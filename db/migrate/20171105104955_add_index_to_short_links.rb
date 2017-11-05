class AddIndexToShortLinks < ActiveRecord::Migration[5.0]
  def change
    add_index :short_links, :shortcode, unique: true
  end
end
