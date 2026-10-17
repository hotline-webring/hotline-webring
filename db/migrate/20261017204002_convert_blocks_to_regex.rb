class ConvertBlocksToRegex < ActiveRecord::Migration[8.1]
  def up
    rename_column(:blocked_referrers, :host_with_path, :uri_regex)
    BlockedReferrer.find_each do |block|
      uri_regex = BlockedReferrer::DEFAULT_REGEX_TEMPLATE
        .sub("<domain>", block.uri_regex)
      block.update(uri_regex:)
    end
  end

  def down
    rename_column(:blocked_referrers, :uri_regex, :host_with_path)
    BlockedReferrer.find_each do |block|
      host_with_path = block.host_with_path[10..-3]
      block.update(host_with_path:)
    end
  end
end
