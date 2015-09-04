defmodule HelloPhoenix.Plugs.InitUser do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    if current_user = Swotter.SessionManager.current_user(conn) do
      conn = assign(conn, :current_user, current_user)
    end
    conn
  end

end
