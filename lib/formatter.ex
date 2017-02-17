defmodule SocialCuckoo.Formatter do
  @moduledoc """
  The default behaviour for all the formatters.
  """
  @callback format(List.t | Tuple.t | String.t) :: String.t | {String.t, Keyword.t}
end
