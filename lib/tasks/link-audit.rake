desc "Determine if all websites have links"
task link_audit: :environment do
  def green(text)
    puts "\e[32m#{text}\e[0m"
  end

  def red(text)
    puts "\e[31m#{text}\e[0m"
  end

  Redirection.find_each do |redirection|
    result = MissingLinkFinder.new(redirection).run

    if result[:status] == :good
      green("#{redirection.url} is all good")
    else
      # Something went wrong: unlink it no matter what the issue was.
      redirection.unlink

      if result[:status] == :offline
        red("#{redirection.url} is no longer online at all")
      elsif result[:status] == :not_found
        red("#{redirection.url} is a 404")
      elsif result[:status] == :error
        red("#{redirection.url} error: #{result[:error]} ")
      elsif result[:status] == :missing_links
        red("#{redirection.url} is missing #{result[:missing].join(" and ")}")
      end
    end
  end
end
