class RedirectionCreation
  def self.perform(referrer, slug, open:)
    new(referrer, slug, open:).perform
  end

  def initialize(referrer, slug, open:)
    @referrer = referrer
    @slug = slug
    @open = open
  end

  def perform
    if !@open
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
