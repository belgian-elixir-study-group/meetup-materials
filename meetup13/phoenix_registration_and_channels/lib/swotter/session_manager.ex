defmodule Swotter.SessionManager do

  require Ecto.Query
  alias Ecto.Query, as: Q

  def login(conn, %{"email" => email, "password" => password}) do
    login conn, email, password
  end

  def login(conn, email, password) do

    case user = find_user_by_email(email) do
      nil -> {:user_not_found, conn}
      _   -> authenticate(conn, user, password)
    end
  end

  def logout(conn) do
    conn |> Plug.Conn.delete_session(:current_user)
  end


  defp authenticate(conn, user, password) do

    case Swotter.Crypto.password_valid?(user.crypted_password, user.salt, password) do
      true ->
          {:ok, Plug.Conn.put_session(conn, :current_user, user.id), user}
        _  -> {:invalid_password, conn}
    end
  end

  def current_user(conn) do
    if uid = user_id_in_session(conn) do
      find_user_by_id(uid)
    end
  end

  def user_id_in_session(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end


  def logged_in?(conn) do
    current_user(conn) != nil
  end

  def logged_out?(conn) do
    !logged_in?(conn)
  end


  def find_user_by_email(email) do
    email = String.downcase(email)

    Q.from(
      u in Swotter.User,
      select: u,
      where: u.email == ^email
    )
    |> Swotter.Repo.one
  end

  def find_user_by_id(id) do
    Q.from(
      u in Swotter.User,
      select: u,
      where: u.id == ^id
    )
    |> Swotter.Repo.one
  end
end
