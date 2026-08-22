# Hotline Webring

A webring for personal sites.

For more on what exactly this is and how to join the webring, please visit
[the homepage](https://hotlinewebring.club/).

## Getting Started

Set up the repo:

```sh
./bin/setup
```

Run the app using the built-in rails server:

```sh
bin/rails s
```

Run the specs:

```sh
bin/rake spec
```

## Removing a site from the webring

Use `Redirection#unlink`:

```rb
redirection = Redirection.find_by(slug: "whatever")
redirection.unlink
```

This will destroy the `Redirection` and re-link its ring neighbors, sealing the
breach.

## Blocking

When blocking a URL, specify the bare URL, without `http` or `www`
subdomain.

To block everything from `evil.com` but none of its subdomains:

```rb
BlockedReferrer.create!(host_with_path: "evil.com")
```

To block everything under the `/~evil/` directory without blocking the whole
domain:

```rb
BlockedReferrer.create!(host_with_path: "good.com/~evil")
```

To block a subdomain:

```rb
BlockedReferrer.create!(host_with_path: "evil.good.com")
```

## Prevent new redirections from being created

This helps when we're experiencing a flood of spam.

To prevent creation, set `DISALLOW_CREATING_NEW_REDIRECTIONS` environment to
anything wherever you deploy the app. To allow creating new redirections again,
unset the variable.

## API

We have an API, oddly enough. It's used by our Slack bot, and we don't expect
(or allow) anyone else to use it.

## Contribution Guidelines

This code is meant to empower and create connections between humans. We also
hope that in some small way we are able to push back against the influence of
large tech companies on the internet. To those ends, LLM contributions are not
allowed in this codebase. This includes generating code, prose, or translation.
To contribute in a non-English language, please write in whatever language you
find comfortable and allow the maintainers to translate your work using tools
that they choose.
