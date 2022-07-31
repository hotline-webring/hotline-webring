atom_feed do |feed|
  feed.title "Hotline Webring"
  feed.updated @last_redirection.created_at
  feed.author do |author|
    author.name t("authors")
  end

  @redirections.each do |redirection|
    feed.tag!(:entry) do |entry|
      entry.id redirection.tag_uri
      entry.title "#{redirection.slug} joined Hotline Webring"
      entry.updated redirection.created_at.iso8601
      entry.content redirection.url
      entry.link redirection.original_url
      entry.link redirection.url, rel: "alternate"
      entry.author do |author|
        author.name t("authors")
      end
    end
  end
end
