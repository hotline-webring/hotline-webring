unless Redirection.exists?(slug: "gabe")
  gabe = Redirection.create!(
    slug: "gabe",
    url: "http://gabebw.com",
    next_id: -1, # fake data
  )

  edward = Redirection.new(
    slug: "edward",
    url: "http://edwardloveall.com",
  )

  edward.update!(next: gabe)
  gabe.update!(next: edward)
end
