class HostValidator
  INVALID_HOSTS = %w(127.0.0.1 localhost)
  INVALID_TLDS = %w(.dev)

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
    INVALID_HOSTS.include?(host)
  end

  def invalid_tld?
    INVALID_TLDS.include?(File.extname(host))
  end

  def host
    URI.parse(url).host
  end
end
