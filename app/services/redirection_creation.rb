class RedirectionCreation
  def self.perform(referrer, slug)
    new(referrer, slug).perform
  end

  def initialize(referrer, slug)
    @referrer = referrer
    @slug = slug
  end

  def perform
    if Rails.configuration.closed
      return ClosedRedirection.new
    end

    redirection = Redirection.new(slug: slug)

    if referrer.present?
      Rails.logger.info "[#{slug}] Creating redirection from referrer: #{referrer}"
      redirection.original_url = referrer
      redirection.url = referrer
      Ring.new(redirection).link
      redirection
    end
  end

  private

  attr_reader :referrer, :slug
end

ClosedRedirection = Struct.new("ClosedRedirection") do
  def next_url
    "/pages/closed"
  end

  def previous_url
    "/pages/closed"
  end
end
