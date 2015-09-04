defmodule Swotter.AuthTicketController do

  use Swotter.Web, :controller

  import HelloPhoenix.Plugs.AuthenticationPlug

  plug :require_login, api: true, set_status: false

  def new(conn, _params) do

    current_user = conn.assigns[:current_user]

    token = Phoenix.Token.sign(conn, "user_id", current_user.id)

    json conn, %{token: token, id: current_user.id}
  end

end
