Sequel.migration do
  change do
    create_table(:links) do
      uuid         :id, default: Sequel.function(:uuid_generate_v4), primary_key: true
      timestamptz  :created_at, default: Sequel.function(:now), null: false
      timestamptz  :updated_at, default: Sequel.function(:now), null: false
      String       :url, null: false
      String       :shortcode, size: 6, null: false
      index :url, unique: true
      index :shortcode, unique: true
    end
  end
end
