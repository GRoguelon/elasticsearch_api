defmodule ElasticsearchApi.Search.Core do
  @moduledoc """
  Provides core search functionality.

  Source: [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html).
  """

  import ElasticsearchApi.Client, only: [post: 4]
  import ElasticsearchApi.Utils, only: [generate_path: 2, json_headers: 0]

  ## Module attributes

  @default_headers json_headers()

  ## Public functions

  @doc """
  Returns search hits that match the query defined in the request.
  """
  @spec search(map(), keyword()) :: any()
  def search(query, opts \\ []) do
    {path, opts} = generate_path(opts, &search_path/1)

    post(path, @default_headers, query, opts)
  end

  ## Private functions

  @spec search_path(nil | binary()) :: binary()
  defp search_path(nil) do
    "/_search"
  end

  defp search_path(targets) do
    "/#{targets}/_search"
  end
end
