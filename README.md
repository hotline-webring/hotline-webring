# Hotline Webring

[This can only mean one thing!][video]

[video]: https://www.youtube.com/watch?v=uxpDa-c-4Mc

For more on what exactly this is and how to join the webring, please visit
[the homepage](https://hotlinewebring.club/).

## Getting Started

Set up the repo:

    $ ./bin/setup

Run the app using [Heroku Local]:

    $ heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

Run the specs:

    $ bin/drake spec

## Removing a site from the webring

Use `Redirection#unlink`:

    irb> redirection = Redirection.find_by(slug: "whatever")
    irb> redirection.unlink

This will destroy the `Redirection` and re-link its ring neighbors, sealing the
breach.

## Blacklisting

When blacklisting a URL, specify the bare URL, without `http` or `www`
subdomain.

To blacklist everything from `evil.com` but none of its subdomains:

    BlacklistedReferrer.create!(host_with_path: "evil.com")

To blacklist everything under the `/one/` directory (`evil.com/one/*`), but not
the root (for example, to blacklist a user directory):

    BlacklistedReferrer.create!(host_with_path: "good.com/~evil")

To blacklist a subdomain:

    BlacklistedReferrer.create!(host_with_path: "evil.good.com")

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
