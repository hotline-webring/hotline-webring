class Block
  def initialize(referrer_string)
    @referrer_string = referrer_string
  end

  def blocked?
    if referrer_string.nil?
      false
    else
      referrer_with_trailing_slash = referrer_string.delete_suffix("/") + "/"
      referrer_uri = URI.parse(referrer_with_trailing_slash).normalize

      BlockedReferrer.pluck(:uri_pattern).any? do |pattern|
        pattern_uri = URI.parse("https://" + pattern).normalize
        domain_match?(referrer_uri, pattern_uri) &&
          paths_match?(referrer_uri, pattern_uri)
      end
    end
  end

  private

  attr_reader :referrer_string

  def domain_match?(referrer_uri, pattern_uri)
    File.fnmatch?(pattern_uri.host, referrer_uri.host, File::FNM_CASEFOLD)
  end

  def paths_match?(referrer_uri, pattern_uri)
    File.fnmatch?(pattern_uri.path, referrer_uri.path, File::FNM_CASEFOLD)
  end
end
