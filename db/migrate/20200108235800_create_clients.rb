class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :api_key, unique: true
      t.string :name, unique: true
      t.integer :role, limit: 2, default: 1

      t.timestamps
    end
  end
end
