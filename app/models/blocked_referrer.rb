class BlockedReferrer < ActiveRecord::Base
  # Create a blocked referrer that blocks everything from this site.
  #
  # If the URL's host is sites.google.com, it removes all info after
  # /sites/foobar:
  # sites.google.com/sites/foobar/baz/bat -> sites.google.com/sites/foobar
  # (This ensures that we do not block every single Google Site URL.)
  #
  # Otherwise, it simply uses the site's host.
  def self.new_from_url(url)
    uri = URI.parse(url)

    if uri.host == "sites.google.com" && uri.path.start_with?("/site/")
      site_name = uri.path.split("/")[2]
      host_with_path = "#{uri.host}/site/#{site_name}"
    else
      host_with_path = uri.host.sub(/www\./, "")
    end

    new(host_with_path: host_with_path)
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
