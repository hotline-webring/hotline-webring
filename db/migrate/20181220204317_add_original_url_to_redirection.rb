class AddOriginalUrlToRedirection < ActiveRecord::Migration[5.2]
  def up
    add_column :redirections, :original_url, :text
    update 'UPDATE redirections SET original_url = url'
    change_column_null :redirections, :original_url, false
  end

  def down
    remove_column :redirections, :original_url
  end
end
