defmodule Swotter.RegistrationController do

  use Swotter.Web, :controller

  alias Swotter.User

  plug :scrub_params, "user" when action in [:create, :update]


  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    # IO.inspect user_params

    case Swotter.RegistrationManager.register_user(user_params) do

      {:ok, changeset, user} ->
        conn
        |> put_flash(:info, "You have registered successfully")
        |> redirect(to: session_path(conn, :new))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end

  end


end
