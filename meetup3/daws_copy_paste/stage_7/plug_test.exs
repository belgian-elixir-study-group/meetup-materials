defmodule PlugTest do
  use ExUnit.Case
  use Plug.Test

  @options Daws.Plug.init([])

  test "returns help text" do

    connection = conn(:get, "/")

    connection = Daws.Plug.call(connection, @options)


    assert connection.state == :sent
    assert connection.status == 200
    assert connection.resp_body == "Please form your query like this:  ?word=beats"

  end

  test "returns words" do

    connection = conn(:get, "/?word=beats") |> Daws.Plug.call(@options)

    assert connection.state == :sent
    assert connection.status == 200

    {:ok, words} = JSON.decode(connection.resp_body)

    assert Enum.sort(words) == ["Bates", "abets", "baste", "bates", "beast", "betas", "tabes"]

  end


end