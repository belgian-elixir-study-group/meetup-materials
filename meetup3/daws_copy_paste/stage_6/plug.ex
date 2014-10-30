defmodule Daws.Plug do

  import Plug.Conn

  def init(_options) do
    _options
  end

  def call(conn, _opts) do

    words = GenServer.call(:dictionary_worker, {:anagrams_for, "bates"})

    readable_words = Enum.join(words, ", ")

    conn  |> put_resp_content_type("text/plain")  |> send_resp(200, readable_words)
  end

end
