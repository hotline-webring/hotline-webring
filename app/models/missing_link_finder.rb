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
    begin
      response = fetch(redirection.url)
      if response.is_a?(Net::HTTPSuccess)
        missing = missing_links(response.body)
        if missing.empty?
          { status: :good }
        else
          { status: :missing_links, missing: missing }
        end
      else
        { status: :offline }
      end
    rescue SocketError
      { status: :offline }
    rescue StandardError => error
      { status: :error, error: "#{error.class}: #{error.message}" }
    end
  end

  private

  attr_reader :redirection

  def missing_links(html)
    if html
      missing_links = []
      missing_links << "next" if !html.match?(next_link)
      missing_links << "prev" if !html.match?(prev_link)

      missing_links
    end
  end

  def next_link
    /#{HOST}#{SLASH}#{redirection.slug}#{SLASH}next/
  end

  def prev_link
    /#{HOST}#{SLASH}#{redirection.slug}#{SLASH}previous/
  end

  def fetch(url_string)
    url = URI(url_string)
    response = Net::HTTP.get_response(url)
    case response
    when Net::HTTPRedirection
      fetch(response["location"])
    else
      response
    end
  end
end
