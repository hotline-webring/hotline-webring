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
      if missing_links.empty?
        {status: :good}
      else
        {status: :missing_links, missing: missing_links}
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
    found_next = has_next_link?
    found_previous = has_prev_link?
    if !found_next || !found_previous
      session.all("iframe, frame").map { |i| i[:src] }.each do |iframe_src|
        unless iframe_src.start_with?("http")
          uri = URI.parse(session.current_url)
          iframe_src = "#{uri.scheme}://#{uri.host}/#{iframe_src}"
        end

        session.visit iframe_src
        found_next ||= has_next_link?
        found_previous ||= has_prev_link?
      end
    end
    missing_links = []
    missing_links << "next" unless found_next
    missing_links << "prev" unless found_previous
    missing_links
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
