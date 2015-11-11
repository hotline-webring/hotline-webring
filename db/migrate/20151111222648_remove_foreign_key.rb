class RemoveForeignKey < ActiveRecord::Migration
  def up
    remove_foreign_key :redirections, column: :next_id
  end

  def down
    add_foreign_key :redirections, :redirections, column: :next_id
  end
end
