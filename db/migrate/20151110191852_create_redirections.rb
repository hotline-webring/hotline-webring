class CreateRedirections < ActiveRecord::Migration
  def change
    create_table :redirections do |t|
      t.timestamps null: false
      t.references :next
      t.string :slug, index: true
      t.text :url
    end
  end
end
