class Block
  def initialize(possible_match)
    @possible_match = possible_match
  end

  def blocked?
    if possible_match.nil?
      false
    else
      host = URI.parse(possible_match).host

      BlockedReferrer.where("host_with_path LIKE ?", "#{host}%").
        or(BlockedReferrer.where("'www.'||host_with_path LIKE ?", "#{host}%")).
        any?
    end
  end

  private

  attr_reader :possible_match
end
