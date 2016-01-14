atom_feed do |feed|
  feed.title title
  feed.updated @last_redirection.created_at
  feed.author do |author|
    author.name t("authors")
  end

  @redirections.each do |redirection|
    feed.tag!(:entry) do |entry|
      entry.id redirection.tag_uri
      entry.title "#{redirection.slug} joined #{title}"
      entry.updated redirection.updated_at.iso8601
      entry.content redirection.url
      entry.link redirection.url
      entry.author do |author|
        author.name t("authors")
      end
    end
  end
end
