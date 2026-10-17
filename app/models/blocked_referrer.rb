class BlockedReferrer < ActiveRecord::Base
  DEFAULT_REGEX_TEMPLATE = "\\A(www\\.)?<domain>.*"

  # Be default we block the site's URL with an optional `www.` prefix and
  # anything after domain.
  #
  # e.g. an input example.com will also block www.example.com and
  # example.com/sub/path
  #
  # More complex regular expressions must be input manually
  def self.new_from_url(url)
    uri = URI.parse(url)
    host_regex = DEFAULT_REGEX_TEMPLATE.sub("<domain>", uri.host)

    new(uri_regex: host_regex)
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
