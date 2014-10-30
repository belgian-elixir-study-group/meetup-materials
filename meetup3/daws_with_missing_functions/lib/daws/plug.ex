defmodule Daws.Plug do

  import Plug.Conn

  def init(_options) do
    _options
  end

  def call(conn, _opts) do

    # Plug.Conn.Utils.params(conn.query_string)   is your friend

    # response = # TO DO

    conn
    # |> put_resp_content_type("text/plain")
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

end
