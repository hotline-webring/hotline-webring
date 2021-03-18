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
      Rails.logger.info "Creating redirection from referrer: #{referrer}"
      redirection.original_url = referrer
      redirection.url = referrer
      Ring.new(redirection).link
      redirection
    end
  end

  private

  attr_reader :referrer, :slug
end
