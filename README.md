# Hotline Webring

[This can only mean one thing!][video]

[video]: https://www.youtube.com/watch?v=uxpDa-c-4Mc

For more on what exactly this is and how to join the webring, please visit
[the homepage](https://hotlinewebring.club/).

## Getting Started

Set up the repo:

    $ ./bin/setup

Run it with Foreman:

    $ foreman start

Run the specs:

    $ bin/drake spec

If you don't have `foreman`, see [Foreman's install instructions][foreman]. It
is [purposefully excluded from the project's `Gemfile`][exclude].

[foreman]: https://github.com/ddollar/foreman
[exclude]: https://github.com/ddollar/foreman/pull/437#issuecomment-41110407

## Removing a site from the webring

Use `Redirection#unlink`:

    irb> redirection = Redirection.find_by(slug: "whatever")
    irb> redirection.unlink

This will destroy the `Redirection` and re-link its ring neighbors, sealing the
breach.

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
