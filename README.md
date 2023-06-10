# Hotline Webring

[This can only mean one thing!][video]

[video]: https://www.youtube.com/watch?v=uxpDa-c-4Mc

For more on what exactly this is and how to join the webring, please visit
[the homepage](https://hotlinewebring.club/).

## Getting Started

Set up the repo:

    $ ./bin/setup

Run the app using [Heroku Local]:

    $ rails s

Run the specs:

    $ bin/drake spec

## Removing a site from the webring

Use `Redirection#unlink`:

    irb> redirection = Redirection.find_by(slug: "whatever")
    irb> redirection.unlink

This will destroy the `Redirection` and re-link its ring neighbors, sealing the
breach.

## Blocking

When blocking a URL, specify the bare URL, without `http` or `www`
subdomain.

To block everything from `evil.com` but none of its subdomains:

    BlockedReferrer.create!(host_with_path: "evil.com")

To block everything under the `/one/` directory (`evil.com/one/*`), but not the
root (for example, to block a user directory):

    BlockedReferrer.create!(host_with_path: "good.com/~evil")

To block a subdomain:

    BlockedReferrer.create!(host_with_path: "evil.good.com")

## Prevent new redirections from being created

This helps when we're experiencing a flood of spam.

To prevent creation, set `DISALLOW_CREATING_NEW_REDIRECTIONS` to anything on
Heroku:

    production config:set DISALLOW_CREATING_NEW_REDIRECTIONS=1

To allow creating new redirections again, unset the variable:

    production config:unset DISALLOW_CREATING_NEW_REDIRECTIONS

## API

We have an API, oddly enough. It's used by our Slack bot, and we don't expect
(or allow) anyone else to use it.

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
