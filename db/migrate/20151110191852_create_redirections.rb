class CreateRedirections < ActiveRecord::Migration[5.2]
  def change
    create_table :redirections do |t|
      t.timestamps null: false
      t.integer :next_id, null: false
      t.string :slug, null: false
      t.text :url, null: false
    end
    add_foreign_key :redirections, :redirections, column: :next_id
    add_index :redirections, :next_id, unique: true
    add_index :redirections, :slug, unique: true
    add_index :redirections, :url, unique: true
  end
end
