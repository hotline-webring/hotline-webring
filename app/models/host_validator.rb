class HostValidator
  INVALID_HOSTS = %w(localhost)
  INVALID_TLDS = %w(.example .local .test)
  # https://en.wikipedia.org/wiki/Reserved_IP_addresses
  INVALID_IP_RANGES = %w(
    0.0.0.0/8
    127.0.0.0/8
    192.168.0.0/16
  ).map { |address| IPAddr.new(address) }

  def initialize(url)
    @url = url
  end

  def invalid?
    if url.present?
      invalid_host? || invalid_tld? || invalid_ip?
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

  def invalid_ip?
    if is_ip?(host)
      INVALID_IP_RANGES.any? { |ip_range| ip_range.include?(host) }
    else
      false
    end
  end

  def host
    URI.parse(url).host
  end

  def is_ip?(host)
    begin
      IPAddr.new(host)
      true
    rescue IPAddr::InvalidAddressError
      false
    end
  end
end
