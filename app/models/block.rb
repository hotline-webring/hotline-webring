class Block
  def initialize(possible_match)
    @possible_match = possible_match
  end

  def blocked?
    if possible_match.nil?
      false
    else
      uri = URI.parse(possible_match.downcase)

      BlockedReferrer.pluck(:host_with_path).any? do |blocked_host_with_path|
        blocked_uri = URI.parse("http://" + blocked_host_with_path.downcase)

        hosts_match?(uri, blocked_uri) && paths_match?(uri, blocked_uri)
      end
    end
  end

  private

  attr_reader :possible_match

  def hosts_match?(uri, blocked_uri)
    uri.host == blocked_uri.host || uri.host == "www.#{blocked_uri.host}"
  end

  def paths_match?(uri, blocked_uri)
    blocked_path = blocked_uri.path
    blocked_path == "" ||
      uri.path == blocked_path ||
      Pathname.new(uri.path).ascend.include?(Pathname.new(blocked_path))
  end
end
