class BlockedReferrer < ActiveRecord::Base
  # Create a blocked referrer that blocks everything from this site using a glob
  # pattern. See the Block class for more details.
  def self.new_from_url(url)
    uri = URI.parse(url)
    uri_pattern = "#{uri.host}/*"
    new(uri_pattern:)
  end

  def self.block_and_unlink(redirection)
    blocked_referrer = new_from_url(redirection.url)
    transaction do
      blocked_referrer.save!
      redirection.unlink
      blocked_referrer
    end
  end
end
