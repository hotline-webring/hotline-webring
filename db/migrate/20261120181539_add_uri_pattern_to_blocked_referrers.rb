class AddUriPatternToBlockedReferrers < ActiveRecord::Migration[8.1]
  def up
    add_column(:blocked_referrers, :uri_pattern, :string)
    execute(<<~SQL)
      update blocked_referrers
      set uri_pattern = host_with_path || '/*'
    SQL
    change_column_null(:blocked_referrers, :uri_pattern, false)
    remove_column(:blocked_referrers, :host_with_path)
  end

  def down
    add_column(:blocked_referrers, :host_with_path, :string)
    execute(<<~SQL)
      update blocked_referrers
      set host_with_path = replace(uri_pattern, '/*', '')
    SQL
    change_column_null(:blocked_referrers, :host_with_path, false)
    remove_column(:blocked_referrers, :uri_pattern)
  end
end
