class Block
  def initialize(test_referer)
    @test_referer = test_referer
  end

  def blocked?
    if test_referer.nil?
      false
    else
      test_uri = URI.parse(test_referer)
      test_no_scheme = test_referer
        .delete_prefix("#{test_uri.scheme}://")
        .downcase

      BlockedReferrer.pluck(:uri_regex).any? do |blocked_no_scheme|
        blocked_regex = Regexp.new(blocked_no_scheme)

        test_no_scheme.match?(blocked_regex)
      end
    end
  end

  private

  attr_reader :test_referer
end
