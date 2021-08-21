class Block
  def initialize(possible_match)
    @possible_match = possible_match
  end

  def blocked?
    if possible_match.nil?
      false
    else
      uri = URI.parse(possible_match)
      host_with_path = "#{uri.host}#{uri.path}"

      BlockedReferrer.where("starts_with(lower(?), lower(host_with_path))", host_with_path).
        or(BlockedReferrer.where("starts_with(lower(?), lower('www.'||host_with_path))", host_with_path)).
        any?
    end
  end

  private

  attr_reader :possible_match
end
