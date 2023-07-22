defmodule ElasticsearchApi.Client do
  @moduledoc """
  Provides a HTTP client for Elasticsearch. It leverages the `any_http` library in order to defer
  to the user the choice of the Elixir HTTP client.

  # connect_options: [transport_opts: [verify: :verify_none]]
  """

  require Logger

  ## Typespecs

  @type opts :: keyword()

  @type path :: binary() | URI.t()

  @type status :: pos_integer()

  @type headers :: map() | [{binary(), binary()}]

  @type body :: any()

  @type response :: %{required(:status) => status(), required(:headers) => headers(), required(:body) => body()}

  @type cluster :: %{required(:endpoint) => path(), optional(:headers) => headers()}

  ## Module attributes

  @content_type_keys ~w[Content-Type content-type]

  @default_uri URI.parse("https://elastic:elastic@localhost:9200")

  @default_cluster %{
    endpoint: %{@default_uri | userinfo: nil},
    headers: %{"authorization" => "Basic #{Base.encode64(@default_uri.userinfo)}"}
  }

  @clusters Application.compile_env(:elasticsearch_api, :clusters, @default_cluster)

  ## Public functions

  @spec post(path(), headers(), body(), opts()) :: {:ok, response()}
  def post(path, headers \\ [], body, opts \\ []) do
    {url, headers, body} = prepare_request!(path, headers, body, opts)
    response = AnyHttp.post(url, headers, body, decode_body: false)

    parse_response(response)
  end

  ## Private functions

  @spec prepare_request!(path(), headers(), body(), opts()) :: {path(), headers(), body()}
  defp prepare_request!(path, headers, body, opts) do
    cluster = get_cluster!(opts)
    default_headers = cluster |> Map.get(:headers, []) |> Enum.to_list()
    request_headers = Enum.to_list(headers)
    headers = default_headers |> Enum.concat(request_headers)
    {headers, body} = format_body(headers, body)
    url = cluster |> Map.fetch!(:endpoint) |> URI.merge(path)

    # IO.inspect(URI.to_string(url), label: "URL")

    {url, headers, body}
  end

  @spec parse_response({:ok, AnyHttp.Response.t()}) :: {:ok, response()}
  defp parse_response({:ok, %AnyHttp.Response{} = response}) do
    body = parse_body(response.headers, response.body)

    {:ok, %{status: response.status, headers: response.headers, body: body}}
  end

  @spec get_cluster!(opts()) :: cluster()
  defp get_cluster!(opts) do
    case Keyword.get(opts, :cluster) do
      nil ->
        Logger.warning("No cluster specified, using default cluster")

        Map.get(@clusters, :default, @default_cluster)

      cluster when is_map(cluster) and is_map_key(cluster, :endpoint) ->
        cluster

      cluster_key when is_atom(cluster_key) ->
        if Map.has_key?(@clusters, cluster_key) do
          Map.fetch!(@clusters, cluster_key)
        else
          Logger.warning("Invalid cluster: #{inspect(cluster_key)}, using default cluster")

          Map.get(@clusters, :default, @default_cluster)
        end
    end
  end

  @spec format_body(headers(), body()) :: {headers(), body()}
  defp format_body(headers, body) do
    body =
      if json?(headers) do
        AnyJson.encode!(body)
      else
        body
      end

    {headers, body}
  end

  @spec parse_body(headers(), body()) :: any()
  defp parse_body(headers, body) do
    if json?(headers) do
      AnyJson.decode!(body)
    else
      body
    end
  end

  @spec json?(headers()) :: boolean()
  defp json?(headers) do
    Enum.any?(headers, fn {key, value} ->
      key in @content_type_keys and value == "application/json"
    end)
  end
end
