defmodule RedditGather.Fetch do
  @moduledoc ~S"""
  The Fetch behaviour describes any module which can retrieve a resouce
  that is identifide by a String (such as a URL) and return the content.
  """

  @doc "Fetches a resources at a given string location"
  @type ok_response :: {:ok, String.t}
  @type error_response :: {:error, atom}
  @type fetch_response :: ok_response | error_response

  @callback fetch(location :: String.t) :: fetch_response
end