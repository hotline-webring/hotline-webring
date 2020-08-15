require "capybara/mechanize"

Capybara.register_driver :mechanize do |app|
  # Allow using Mechanize without a Rack app, so we can access external services
  # https://github.com/jeroenvandijk/capybara-mechanize#usage-without-rack-app
  Capybara::Mechanize::Driver.new(proc {})
end

class MissingLinkFinder
  # Surprisingly, this works just fine:
  # <a href="https:&#x2F;&#x2F;hotlinewebring.club&#x2F;alexey&#x2F;next">next</a>
  # Therefore, we should allow encoded slashes.
  SLASH = Regexp.union("/", /&#x2f;/i)
  HOST = "hotlinewebring.club"

  def initialize(redirection)
    @redirection = redirection
    @session = Capybara::Session.new(:mechanize)
  end

  def run
    session.visit(redirection.url)
    if session.status_code.in?(200..299)
      missing = missing_links
      if missing.empty?
        {status: :good}
      else
        {status: :missing_links, missing: missing}
      end
    else
      {status: :offline}
    end
  rescue SocketError
    {status: :offline}
  rescue => error
    if error.message.include?("ERR_NAME_NOT_RESOLVED")
      {status: :offline}
    elsif error.message.include?("Net::HTTPNotFound")
      {status: :not_found}
    else
      {status: :error, error: "#{error.class}: #{error.message}"}
    end
  end

  private

  attr_reader :redirection, :session

  def missing_links
    missing_next = !has_next_link?
    missing_previous = !has_prev_link?
    session.all("iframe, frame").map { |i| i[:src] }.each do |iframe_src|
      if missing_next || missing_previous
        session.visit ensure_absolute_path(iframe_src)
        if has_next_link?
          missing_next = false
        end
        if has_prev_link?
          missing_previous = false
        end
      end
    end
    missing_links = []
    missing_links << "next" if missing_next
    missing_links << "prev" if missing_previous
    missing_links
  end

  def ensure_absolute_path(src)
    if src.start_with?("http")
      src
    else
      uri = URI.parse(session.current_url)
      "#{uri.scheme}://#{uri.host}/#{src}"
    end
  end

  def has_next_link?
    session.has_link?(href: next_link)
  end

  def has_prev_link?
    session.has_link?(href: prev_link)
  end

  def next_link
    /#{HOST}#{SLASH}#{redirection.slug}#{SLASH}next/
  end

  def prev_link
    /#{HOST}#{SLASH}#{redirection.slug}#{SLASH}previous/
  end
end
