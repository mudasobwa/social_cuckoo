defmodule SocialCuckoo.Formatters.Twitter do
  @moduledoc """
  Provides a callback formatting an AST and/or a binary.
  Returns either a simple text or a tuple of text and params keyword.
  """

  @behaviour SocialCuckoo.Formatter
  @behaviour SocialCuckoo.Publisher

  @defaults (Application.get_env(:social_cuckoo, :options) || [])[:twitter] || [trim_user: true]

  @doc """
  Formats the string.

  ## Examples:

      iex> SocialCuckoo.Formatters.Twitter.format("Hello, world!")
      "Hello, world!"

      iex> SocialCuckoo.Formatters.Twitter.format(String.duplicate("Hello, world!!", 10) <> "×") \
      ...>  === String.duplicate("Hello, world!!", 9) <> "Hello, world…"

      iex> SocialCuckoo.Formatters.Twitter.format({:p, %{}, "Hello, world!"})
      "Hello, world!"

      iex> SocialCuckoo.Formatters.Twitter.format({:p, %{}, ["Hello, world!", "Other stuff."]})
      "Hello, world!"
  """
  def format(input) when is_binary(input) do
    if String.length(input) <= 140,
      do: input,
      else: String.slice(input, 0..138) <> "…"
  end

  @doc """
  Formats the AST as produced by
  [`Markright`](https://hexdocs.pm/markright/0.2.5/Markright.html#content)
  or manually.
  """
  def format({_tag, _attrs, content}), do: format(content)

  @doc """
  Formats the AST as produced by
  [`Markright`](https://hexdocs.pm/markright/0.2.5/Markright.html#content)
  or manually.
  """
  def format([h | _]) when is_binary(h) or is_tuple(h), do: format(h)

  @doc """
  Actually publishes the input to twitter, throws an exception on fail.
  """
  def publish!(data, opts \\ []) do
    with %ExTwitter.Model.Tweet{id: id} = payload <-
            ExTwitter.update(data, Keyword.merge(@defaults, opts)),
      do: [id: id, payload: payload]
  end

  @doc """
  Actually publishes the input to twitter, returns `{:ok, result}` or
  `{:error, message}` tuple.
  """
  def publish(data, opts \\ []) do
    try do
      {:ok, publish!(data, opts)}
    rescue
      e in ExTwitter.Error -> {:error, e.message}
    end
  end
end
