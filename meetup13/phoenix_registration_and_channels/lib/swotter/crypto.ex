defmodule Swotter.Crypto do

  def generate_random_salt, do: UUID.uuid4

  def hash_string(string) when is_binary(string) do
    Comeonin.Bcrypt.hashpwsalt(string)
  end

  def hash_password(salt, password) when is_binary(password) when is_binary(salt) do

    {password, salt}
    |> passwd_and_salt
    |> hash_string
  end

  def password_valid?(crypted, salt, password) when is_binary(password) when is_binary(salt)  do
    {password, salt}
    |> passwd_and_salt
    |> Comeonin.Bcrypt.checkpw(crypted)
  end

  defp passwd_and_salt({password, salt}) do
    password <> salt
  end

end
