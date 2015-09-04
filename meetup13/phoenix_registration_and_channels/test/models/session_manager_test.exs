defmodule Swotter.UserTest do
  use Swotter.ModelCase

  alias Swotter.SessionManager
  alias Swotter.RegistrationManager


  test "find_user_by_email and find_user_by_id" do
    params = %{
      "email"  =>    "yuri@foo.com",
      "firstname"  =>"Yuri",
      "lastname"  => "Leikind",
      "crypted_password"  => "foobar",
      "crypted_password_confirmation"  => "foobar"
    }

    {:ok, _changeset, user} = RegistrationManager.register_user(params)

    assert(user.id)

    id = user.id

    user = SessionManager.find_user_by_email("yuri@foo.com")

    assert(user.id)
    assert(id == user.id)

    user = SessionManager.find_user_by_id(id)

    assert(user.id)

  end

  test "logging in with a non-existent user" do

    connection = Phoenix.ConnTest.conn

    {:user_not_found, conn} = SessionManager.login(connection, "www.fff@fff.com", "fooo")

    assert(conn == connection)
  end

  test "logging in with a wrong password" do

    params = %{
      "email" =>     "yuri@foo.com",
      "firstname" => "Yuri",
      "lastname" =>  "Leikind",
      "crypted_password" =>  "foobar",
      "crypted_password_confirmation" =>  "foobar"
    }

    {:ok, _changeset, _user} = RegistrationManager.register_user(params)

    connection = Phoenix.ConnTest.conn

    {:invalid_password, conn} = SessionManager.login(connection, "yuri@foo.com", "wrong_password")

    assert(conn == connection)
  end

  test "successful login" do

    params = %{
      "email" =>     "yuri@foo.com",
      "firstname" => "Yuri",
      "lastname" =>  "Leikind",
      "crypted_password" =>  "foobar",
      "crypted_password_confirmation" =>  "foobar"
    }

    {:ok, _changeset, _user} = RegistrationManager.register_user(params)

    opts = Plug.Session.init(store: :ets, key: "_my_app_session", secure: true, table: :session)

    connection =  Phoenix.ConnTest.conn
    |> Plug.Session.call(opts)
    |> Plug.Conn.fetch_session

    refute SessionManager.logged_in?(connection)

    {:ok, conn, user} = SessionManager.login(connection, "yuri@foo.com", "foobar")


    assert(Plug.Conn.get_session(conn, :current_user) == user.id)

    assert(SessionManager.current_user(conn) == user)
    assert SessionManager.logged_in?(conn)

    conn = SessionManager.logout(conn)

    refute SessionManager.logged_in?(conn)
    assert SessionManager.logged_out?(conn)
  end
end
