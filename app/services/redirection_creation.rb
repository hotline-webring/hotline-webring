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
      redirection.url = normalized_referrer
      Ring.new(redirection).link
      redirection
    end
  end

  private

  attr_reader :referrer, :slug

  def normalized_referrer
    if referrer_uri.path.start_with?("/~")
      referrer_hostname + File.dirname(referrer_uri.path)
    else
      referrer_hostname
    end
  end

  def referrer_hostname
    "#{referrer_uri.scheme}://#{referrer_uri.hostname}"
  end

  def referrer_uri
    @_referrer_uri ||= URI.parse(referrer)
  end
end
