class MissingLinkFinder
  # Surprisingly, this works just fine:
  # <a href="https:&#x2F;&#x2F;hotlinewebring.club&#x2F;alexey&#x2F;next">next</a>
  # Therefore, we should allow encoded slashes.
  SLASH = Regexp.union("/", /&#x2f;/i)
  HOST = "hotlinewebring.club"

  def initialize(redirection)
    @redirection = redirection
  end

  def run
    html = fetch(redirection.url)

    if html
      missing_links = []
      missing_links << "next" if !html.match?(next_link)
      missing_links << "prev" if !html.match?(prev_link)

      missing_links
    end
  end

  private

  attr_reader :redirection

  def next_link
    /#{HOST}#{SLASH}#{redirection.slug}#{SLASH}next/
  end

  def prev_link
    /#{HOST}#{SLASH}#{redirection.slug}#{SLASH}previous/
  end

  def fetch(url_string)
    url = URI(url_string)
    begin
      response = Net::HTTP.get_response(url)
      case response
      when Net::HTTPSuccess
        response.body
      when Net::HTTPRedirection
        fetch(response["location"])
      end
    rescue SocketError
      nil
    end
  end
end
