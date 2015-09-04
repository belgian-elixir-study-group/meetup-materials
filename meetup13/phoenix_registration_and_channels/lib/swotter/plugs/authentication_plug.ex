defmodule HelloPhoenix.Plugs.AuthenticationPlug do

  import Plug.Conn
  alias Phoenix.Controller

  @defaults [
    flash_key:   :info,
    flash_msg:   "You must be logged in to access this page.",
    redirect_to: "/login",
    api:         false,
    set_status:  false
  ]

  def require_login(conn, opts \\ []) do
    opts = Dict.merge(@defaults, opts)

    if conn.assigns[:current_user] do
      conn
    else
      if opts[:api] do
        api_unauthorized_response(conn, opts)
      else
        auth_redirect(conn, opts)
      end
    end
  end


  defp api_unauthorized_response(conn, opts) do

    if opts[:set_status] do
      conn = Plug.Conn.put_status(401)
    end

    conn
    |> Phoenix.Controller.json(%{})
    |> halt
  end

  defp auth_redirect(conn, opts) do
    conn
    |> Controller.put_flash(opts[:flash_key], opts[:flash_msg])
    |> Controller.redirect(to: opts[:redirect_to])
    |> halt
  end
end
