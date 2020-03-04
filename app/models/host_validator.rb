class HostValidator
  INVALID_HOSTS = %w(127.0.0.1 localhost example.com example.org example.net example.dev)
  INVALID_TLDS = %w(.example .local .test)

  def initialize(url)
    @url = url
  end

  def invalid?
    if url.present?
      invalid_host? || invalid_tld?
    else
      false
    end
  end

  private

  attr_reader :url

  def invalid_host?
    puts host
    INVALID_HOSTS.include?(host)
  end

  def invalid_tld?
    INVALID_TLDS.include?(File.extname(host))
  end

  def host
    URI.parse(url).host
  end
end
