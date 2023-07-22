# Elasticsearch API

Elixir library to query Elasticsearch.

[Documentation](https://hexdocs.pm/elasticsearch_api)

## Installation

```elixir
def deps do
  [
    {:elasticsearch_api, "~> 0.1"}
    {:req, "~> 0.3"}
    {:jason, "~> 1.4"}
  ]
end
```

## Configuration

Declare your favorite HTTP library in the configuration

```elixir
config :any_http, client_adapter: AnyHttp.Adapters.Req

config :any_json, json_adapter: AnyJson.Jason

config :elasticsearch_api, clusters: %{
  default: %{
    endpoint: "https://localhost:9200",
    headers: %{"authorization" => "Basic #{Base.encode64("elastic:elastic")}"}
  }
}
```

## Usage

```elixir
ElasticsearchApi.search(%{query: %{match_all: %{}}}, target: "my_index", track_total_hits: false)
```

The result will look like:

```elixir
{:ok,
  %{
    status: 200,
    headers: [{"content-type", "application/json"}],
    body: %{
      "hits" => %{
        "hits" => [
          %{"_id" => "", "_source" => %{}}
        ]
      }
    }
  }
}
```
