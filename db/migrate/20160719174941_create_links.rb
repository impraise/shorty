class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :url, null: false
      t.string :code, null: false
      t.index :code, unique: true

      t.timestamps
    end
  end
end
