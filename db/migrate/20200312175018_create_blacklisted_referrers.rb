class CreateBlacklistedReferrers < ActiveRecord::Migration[6.0]
  def change
    create_table :blacklisted_referrers do |t|
      t.string :host_with_path, null: false
      t.index :host_with_path, unique: true

      t.timestamps null: false
    end
  end
end
