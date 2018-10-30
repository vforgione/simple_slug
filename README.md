# SimpleSlug

[![Build Status](https://travis-ci.com/vforgione/simple_slug.svg?branch=master)](https://travis-ci.com/vforgione/simple_slug)

A passive slugging module -- simple, transliteration-free slugs.

Given Elixir handles UTF-8 without issue, and browsers handle UtF-8
without issue both in content and in URIs, why should you fight your
users' preferred input?

Transliteration is ridiculously difficult and expensive. The best
we have are brute force libraries:

- [http://cldr.unicode.org/index/cldr-spec/transliteration-guidelines](http://cldr.unicode.org/index/cldr-spec/transliteration-guidelines)
- [http://userguide.icu-project.org/transforms/general](http://userguide.icu-project.org/transforms/general)

Here's an example: what would a typical transliteration of _消防署_
be? Chances are it would be transformed to _xiāofángshǔ_. That's fine if
you intended it to be Chinese, but totally incorrect if it was supposed
to be Japanese (_shōbōsho_). Do all German speakers want _ß_ to be cast
to _s_ or _ss_?

The gist of all of this is: take the path of least resistance and don't
try to force everything to conform to ASCII.

## Installation

SimpleSlug can be installed by adding `simple_slug` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:simple_slug, "~> 0.1.0"}
  ]
end
```

## Examples

```elixir
iex> SimpleSlug.slugify("Hello World")
"hello-world"

iex> SimpleSlug.slugify("Hello World", joiner: "_")
"hello_world"

iex> SimpleSlug.slugify("Hello World", lowercase?: false)
"Hello-World"

iex> SimpleSlug.slugify("Hello World", truncate: 5)
"hello"

iex> SimpleSlug.slugify("Hello World", truncate: 6)
"hello"

iex> SimpleSlug.slugify("Straßen von Berlin")
"straßen-von-berlin"

iex> SimpleSlug.slugify("東京キャブ乗り場2018年1月")
"東京キャブ乗り場2018年1月"
```