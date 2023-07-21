defmodule ElasticsearchApiTest do
  use ExUnit.Case
  doctest ElasticsearchApi

  test "greets the world" do
    assert ElasticsearchApi.hello() == :world
  end
end
