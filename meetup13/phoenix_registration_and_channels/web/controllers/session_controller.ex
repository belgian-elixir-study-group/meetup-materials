defmodule Swotter.SessionController do

  use Swotter.Web, :controller

  alias Swotter.SessionManager

  def new(conn, _params) do
    # p _params
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do

    case SessionManager.login(conn, session_params) do
      {:user_not_found, conn} ->
        conn
        |> put_flash(:info, "No such user exists")
        |> redirect(to: session_path(conn, :new))

      {:invalid_password, conn} ->
        conn
        |> put_flash(:info, "Wrong password")
        |> redirect(to: session_path(conn, :new))

      {:ok, conn, user} ->
        conn
        |> put_flash(:info, "Hello!")
        |> redirect(to: page_path(conn, :index))
    end

  end

  def delete(conn, _params) do
    SessionManager.logout(conn)
    |> put_flash(:info, "Logged out succesfully.")
    |> redirect(to: page_path(conn, :index))
  end

end
