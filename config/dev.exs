elasticsearch_uri = URI.parse("https://elastic:elastic@localhost:9200")

config :elasticsearch_api,
  clusters: %{
    default1: %{
      endpoint: URI.to_string(%{elasticsearch_uri | userinfo: nil}),
      headers: %{"authorization" => "ApiKey #{Base.encode64("elastic:elastic")}"}
    }
  }
