defmodule Swotter.PrivatePageController do

  use Swotter.Web, :controller

  alias Swotter.SessionManager

  import HelloPhoenix.Plugs.AuthenticationPlug

  plug :require_login, flash_msg: "You must be logged in to access this page. Please login."

  # plug :require_login, [
  #     flash_key: :info,
  #     flash_msg: "You must be logged in.",
  #     redirect_to: "/signin"
  #   ] when action in [:index]


  def index(conn, _params) do
    # p _params
    render conn, "index.html"
  end

end
