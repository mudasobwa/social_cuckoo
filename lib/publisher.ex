defmodule SocialCuckoo.Publisher do
  @moduledoc """
  The default behaviour for all the publishers.
  """
  @callback publish(String.t, Keyword.t) :: {:ok, Keyword.t} | {:error, reason: String.t}
end
