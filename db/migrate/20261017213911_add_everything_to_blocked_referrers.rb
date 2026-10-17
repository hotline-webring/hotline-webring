class AddEverythingToBlockedReferrers < ActiveRecord::Migration[8.1]
  def change
    add_column :blocked_referrers, :block_by_domain, :boolean, default: false, null: false
  end
end
