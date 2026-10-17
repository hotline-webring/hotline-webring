class Block
  def initialize(possible_match)
    @possible_match = possible_match
  end

  def blocked?
    if possible_match.nil?
      false
    else
      uri = URI.parse(prefixed_with_http(possible_match.downcase))

      BlockedReferrer.find_each.any? do |blocked_referrer|
        blocked_host_with_path = blocked_referrer.host_with_path
        blocked_uri = URI.parse("http://" + blocked_host_with_path.downcase)

        if blocked_referrer.block_by_domain?
          uri.host.downcase.end_with?(blocked_uri.hostname.downcase)
        else
          hosts_match?(uri, blocked_uri) && paths_match?(uri, blocked_uri)
        end
      end
    end
  end

  private

  attr_reader :possible_match

  def hosts_match?(uri, blocked_uri)
    uri.host == blocked_uri.host || uri.host == "www.#{blocked_uri.host}"
  end

  def paths_match?(uri, blocked_uri)
    blocked_uri.path == "" ||
      uri.path == blocked_uri.path ||
      Pathname.new(uri.path).ascend.include?(Pathname.new(blocked_uri.path))
  end

  def prefixed_with_http(s)
    if s.start_with?("http://", "https://")
      s
    else
      "http://#{s}"
    end
  end
end
