desc "Determine if all websites have links"
task link_audit: :environment do
  def green(text)
    puts "\e[32m#{text}\e[0m"
  end

  def red(text)
    puts "\e[31m#{text}\e[0m"
  end

  def fetch(url_string)
    url = URI(url_string)
    begin
      response = Net::HTTP.get_response(url)
      case response
      when Net::HTTPSuccess then
        response.body
      when Net::HTTPRedirection, Net::HTTPMovedPermanently then
        fetch(response["location"])
      end
    rescue SocketError
      nil
    end
  end

  Redirection.find_each do |redirection|
    html = fetch(redirection.url)

    if html
      # Surprisingly, this works just fine:
      # <a href="https:&#x2F;&#x2F;hotlinewebring.club&#x2F;alexey&#x2F;next">next</a>
      # Therefore, we should allow encoded slashes.
      slash = Regexp.union(['/', '&#x2f;'])
      host = 'hotlinewebring.club'
      next_link = /#{host}#{slash}#{redirection.slug}#{slash}next/
      prev_link = /#{host}#{slash}#{redirection.slug}#{slash}previous/

      missing_links = []
      missing_links << "next" if !html.match?(next_link)
      missing_links << "prev" if !html.match?(prev_link)

      if missing_links.empty?
        green("#{redirection.url} is all good")
      else
        red("#{redirection.url} is missing #{missing_links.join(' and ')}")
      end
    else
      red("#{redirection.url} is no longer online at all")
    end
  end
end
