Sequel.migration do
  change do
    create_table(:clicks) do
      uuid         :id, default: Sequel.function(:uuid_generate_v4), primary_key: true
      timestamptz  :created_at, default: Sequel.function(:now), null: false
      timestamptz  :updated_at, default: Sequel.function(:now), null: false
      foreign_key  :link_id, :links, type: 'uuid', null: false
    end
  end
end
