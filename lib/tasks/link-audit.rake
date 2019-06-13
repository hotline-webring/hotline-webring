desc "Determine if all websites have links"
task link_audit: :environment do
  def green(text)
    puts "\e[32m#{text}\e[0m"
  end

  def red(text)
    puts "\e[31m#{text}\e[0m"
  end

  Redirection.find_each do |redirection|
    missing_links = LinkAudit.new(redirection).run

    if missing_links.nil?
      red("#{redirection.url} is no longer online at all")
    elsif missing_links.empty?
      green("#{redirection.url} is all good")
    else
      red("#{redirection.url} is missing #{missing_links.join(' and ')}")
    end
  end
end
