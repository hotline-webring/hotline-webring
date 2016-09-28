desc "Determine if all websites have links"
task link_audit: :environment do
  def green(text)
    puts "\e[32m#{text}\e[0m"
  end

  def red(text)
    puts "\e[31m#{text}\e[0m"
  end

  Redirection.find_each do |redirection|
    url = URI(redirection.url)
    html = Net::HTTP.get(url)
    next_link = "hotlinewebring.club/#{redirection.slug}/next"
    prev_link = "hotlinewebring.club/#{redirection.slug}/previous"

    missing_links = []
    missing_links << "next" if !html.include?(next_link)
    missing_links << "prev" if !html.include?(prev_link)

    if missing_links.empty?
      green("#{redirection.url} is all good")
    else
      red("#{redirection.url} is missing #{missing_links.join(' and ')}")
    end
  end
end
