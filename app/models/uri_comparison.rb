class UriComparison
  def self.same_normalized_uri?(one, two)
    normalize_uri(one) == normalize_uri(two)
  end

  def self.normalize_uri(uri)
    path = uri.path.sub(/\/$/, "")
    "#{uri.host.sub(/^www./, "")}/#{path}?#{uri.query}"
  end
end
