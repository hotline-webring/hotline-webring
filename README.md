# Hotline Webring

[This can only mean one thing!][video]

[video]: https://www.youtube.com/watch?v=uxpDa-c-4Mc

**Q: No seriously, what is it?**

A: Way back in the 1990s, there were no search engines, but people still wanted
   that sweet sweet traffic. And thus the webring: a group (or ring) of websites
   with links to other websites in the ring.

**Q: So it's some weird old thing?**

A: Um it's [vintage, and so adorable](https://www.youtube.com/watch?v=kfLSjobM9bg).

**Q: How do I get in on this?**

A: Make up an identifier for yourself like `gabebw`. Then add links back and
   forward in the ring: `URL.com/gabebw/previous` and `URL.com/gabebw/next`.
   You'll be automatically added to the ring.

Example code:

```html
<a href="http://URL.com/gabebw/previous">&larr;</a>
Check out my webring!
<a href="http://URL.com/gabebw/next">&rarr;</a>
```

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

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
