class AddLastSeenToRedirections < ActiveRecord::Migration[8.0]
  def change
    add_column :redirections, :last_seen_at, :datetime
  end
end
