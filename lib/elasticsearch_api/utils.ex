defmodule ElasticsearchApi.Utils do
  @moduledoc """
  Provides some utilities to interact with Elasticsearch data.
  """

  ## Typespecs

  @type response :: ElasticsearchApi.Client.response()

  ## Public functions

  @spec extract_body!({:ok, response()}) :: any()
  def extract_body!({:ok, %{status: status, body: body}}) when status in 200..299 do
    body
  end

  def extract_body!({:ok, %{status: status, body: body}}) when status in 400..499 do
    raise ElasticsearchApi.Error, body
  end

  @spec extract_hits!({:ok, response()} | {:error, any()}) :: [map()]
  def extract_hits!(response) do
    response |> extract_body!() |> then(fn %{"hits" => %{"hits" => hits}, "timed_out" => false} -> hits end)
  end

  @spec json_headers() :: map()
  def json_headers() do
    %{"accept" => "application/json", "content-type" => "application/json"}
  end

  @spec generate_path(keyword(), (nil | binary() -> binary())) :: {binary() | URI.t(), keyword()}
  def generate_path(opts, path_fn) do
    {opts, params} = extract_options(opts)
    path = opts |> get_targets() |> path_fn.() |> do_generate_path(params)

    {path, opts}
  end

  ## Private functions

  @spec do_generate_path(binary(), keyword()) :: binary() | URI.t()
  defp do_generate_path(path, []) do
    path
  end

  defp do_generate_path(path, params) do
    encoded_params = URI.encode_query(params)

    %URI{} |> URI.append_path(path) |> URI.append_query(encoded_params)
  end

  @spec extract_options(keyword()) :: {keyword(), keyword()}
  defp extract_options(opts) do
    Keyword.split(opts, [:target, :cluster])
  end

  @spec get_targets(keyword()) :: nil | binary()
  defp get_targets(opts) do
    case Keyword.get_values(opts, :target) do
      [] ->
        nil

      values ->
        values |> List.flatten() |> Enum.join(",")
    end
  end
end
