class RedirectionCreation
  def self.perform(referrer, slug)
    new(referrer, slug).perform
  end

  def initialize(referrer, slug)
    @referrer = referrer
    @slug = slug
  end

  def perform
    redirection = Redirection.new(slug: slug)

    if referrer.present?
      redirection.original_url = referrer
      redirection.url = referrer_hostname
      Ring.new(redirection).link
      redirection
    end
  end

  private

  attr_reader :referrer, :slug

  def referrer_hostname
    referrer_uri = URI.parse(referrer)
    "#{referrer_uri.scheme}://#{referrer_uri.hostname}"
  end
end
