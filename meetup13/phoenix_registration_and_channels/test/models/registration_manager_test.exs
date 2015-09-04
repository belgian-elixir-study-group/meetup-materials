defmodule Swotter.RegistrationManagerTest do
  use Swotter.ModelCase

  alias Ecto.Changeset
  alias Swotter.RegistrationManager

  test "password is crypted and user is saved" do
    params = %{
      "email" =>     "yuri@foo.com",
      "firstname" => "Yuri",
      "lastname" =>  "Leikind",
      "crypted_password" => "foobar",
      "crypted_password_confirmation" =>  "foobar"
    }

    {:ok, changeset, user} = RegistrationManager.register_user(params)

    refute(changeset.action)

    crypted_password = Changeset.get_field(changeset, :crypted_password)
    salt = Changeset.get_field(changeset, :salt)

    assert(crypted_password)
    assert(salt)

    assert Swotter.Crypto.password_valid?(crypted_password, salt, "foobar")
    assert Swotter.Crypto.password_valid?(user.crypted_password, user.salt, "foobar")

    assert(user.id)
  end

  test "password and password confirmation are compared" do


    params = %{
      "email" =>     "yuri@foo.com",
      "firstname" => "Yuri",
      "lastname" =>  "Leikind",
      "crypted_password" =>  "foobar",
      "crypted_password_confirmation" =>  "bfgfg"
    }

    {:error, changeset} = RegistrationManager.register_user(params)

    assert(changeset.action == :insert)

    # IO.inspect changeset.valid?

    assert(has_errors_on?(changeset, :crypted_password))

  end


  test "password is mandatory" do


    params = %{
      "email" =>     "Yuri@FOO.com",
      "firstname" => "Yuri",
      "lastname" =>  "Leikind",
      "crypted_password" =>  nil,
      "crypted_password_confirmation" =>  nil
    }
    {:error, changeset} = RegistrationManager.register_user(params)
    assert(has_errors_on?(changeset, :crypted_password))

    assert(changeset.action == :insert)
  end


  test "email is mandatory" do

    params = %{
      "firstname" => "Yuri",
      "lastname" =>  "Leikind",
      "crypted_password" =>  "foobar",
      "crypted_password_confirmation" =>  "foobar"
    }

    {:error, changeset} = RegistrationManager.register_user(params)
    assert(has_errors_on?(changeset, :email))

    assert(changeset.action == :insert)

  end

  test "email is downcased" do
    params = %{
      "firstname" => "Yuri",
      "lastname" =>  "Leikind",
      "crypted_password" =>  "foobar",
      "crypted_password_confirmation" =>  "foobar",
      "email" =>     "Yuri@FOO.com"
    }

    {:ok, changeset, user} = RegistrationManager.register_user(params)

    email = Changeset.get_field(changeset, :email)

    assert(email == "yuri@foo.com")
    assert(user.email == "yuri@foo.com")

    refute(changeset.action)

  end

end
