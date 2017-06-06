Sequel.migration do
  change do
    create_table(:shortened_urls) do
      primary_key :id
      String :url, text: true, null: false
      String :shortcode, null: false
      Integer :redirect_count, default: 0
      DateTime :start_date
      DateTime :last_seen_date

      index :shortcode, unique: true
    end
  end
end