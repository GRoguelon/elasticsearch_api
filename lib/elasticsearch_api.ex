defmodule ElasticsearchApi do
  @moduledoc """
  Provides some shortcuts to the most common functions.
  """

  ## Typespecs

  @type opts :: ElasticsearchApi.Client.opts()

  @type response :: ElasticsearchApi.Client.response()

  @type query :: map()

  ## Public functions

  @spec search(query(), opts()) :: {:ok, response()}
  defdelegate search(query, opts \\ []), to: ElasticsearchApi.Search.Core

  @spec extract_body!({:ok, response()}) :: any()
  defdelegate extract_body!(result), to: ElasticsearchApi.Utils

  @spec extract_hits!({:ok, response()} | {:error, any()}) :: [map()]
  defdelegate extract_hits!(result), to: ElasticsearchApi.Utils
end
