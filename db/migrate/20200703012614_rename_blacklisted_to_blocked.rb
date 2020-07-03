class RenameBlacklistedToBlocked < ActiveRecord::Migration[6.0]
  def change
    rename_table("blacklisted_referrers", "blocked_referrers")
  end
end
