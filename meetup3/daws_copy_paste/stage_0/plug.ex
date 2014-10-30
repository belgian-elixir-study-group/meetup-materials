defmodule Daws.Plug do

  import Plug.Conn

  def init(_options) do
    _options
  end

  def call(conn, _opts) do

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "hello")
  end

end