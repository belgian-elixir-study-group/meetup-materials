defmodule Daws.Plug do

  import Plug.Conn

  def init(_options) do
    _options
  end

  def call(conn, _opts) do
    response = case Plug.Conn.Utils.params(conn.query_string) do
      %{"word" => word} ->

        words = Daws.DictionaryWorker.anagrams_for(word)
        readable_words = Enum.join(words, ", ")

        # IO.puts "#{word} -> #{readable_words}"

        {:ok, json} = JSON.encode(words)
        # {:ok, json} = JSON.encode(Map.put_new(%{}, word, words))

        json

      _ -> "Please form your query like this:  ?word=beats"
    end

    conn
    # |> put_resp_content_type("text/plain")
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

end
