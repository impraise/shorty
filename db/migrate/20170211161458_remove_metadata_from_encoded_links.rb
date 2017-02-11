class RemoveMetadataFromEncodedLinks < ActiveRecord::Migration[5.0]
  def change
    remove_column :encoded_links, :last_seen_date
    remove_column :encoded_links, :redirect_count
  end
end
