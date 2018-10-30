defmodule SimpleSlug do
  @moduledoc """
  A passive slugging module -- simple, transliteration-free slugs.

  Given Elixir handles UTF-8 without issue, and browsers handle UtF-8
  without issue both in content and in URIs, why should you fight your
  users' preferred input?

  Transliteration is ridiculously difficult and expensive. The best
  we have are brute force libraries:

    - http://cldr.unicode.org/index/cldr-spec/transliteration-guidelines
    - http://userguide.icu-project.org/transforms/general

  Here's an example: what would a typical transliteration of _消防署_
  be? Chances are it would be transformed to _xiāofángshǔ_. That's fine if
  you intended it to be Chinese, but totally incorrect if it was supposed
  to be Japanese (_shōbōsho_). Do all German speakers want _ß_ to be cast
  to _s_ or _ss_?

  The gist of all of this is: take the path of least resistance and don't
  try to force everything to conform to ASCII.
  """

  @split_re ~r/[\00-\57]/

  @default_joiner "-"

  @default_lowercase true

  @default_truncate false

  @doc """
  Creates a slugified version of a string.

  ## Parameters

    * `value` : The string that you want to use to create a slug.
    * `opts` : See __Options__ section.

  ## Options

    * `joiner` : The value that will join the separated parts of
    the value. Default is `"-"`.
    * `lowercase?` : Should the slug be cast to all lowercase?
    Default is `true`.
    * `truncate` : The maximum length of the slug. The value is not
    a guarantee of the length of the resulting slug -- for example,
    if you specify truncating at the 6th character, but that character
    is the `joiner`, that value is removed -- if it would otherwise
    return `hello-` it will return `hello`. Default is `false`;
    use an integer to apply.

  ## Examples

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
  """
  @spec slugify(binary(), keyword()) :: binary()
  def slugify(value, opts \\ []) do
    opts = [
      joiner: @default_joiner,
      lowercase?: @default_lowercase,
      truncate: @default_truncate
    ]
    |> Keyword.merge(opts)

    value
    |> String.split(@split_re)
    |> Enum.reject(& &1 == "")
    |> Enum.join(opts[:joiner])
    |> lowercase(opts[:lowercase?])
    |> truncate(opts[:truncate])
    |> trim(opts[:joiner])
  end

  defp lowercase(value, true), do: String.downcase(value)
  defp lowercase(value, _), do: value

  defp truncate(value, len) when is_integer(len), do: String.slice(value, 0, len) |> String.trim()
  defp truncate(value, _), do: value

  defp trim(value, joiner) do
    case String.ends_with?(value, joiner) do
      false -> value
      true -> trim(String.slice(value, 0, String.length(value) - 1), joiner)
    end
  end
end
