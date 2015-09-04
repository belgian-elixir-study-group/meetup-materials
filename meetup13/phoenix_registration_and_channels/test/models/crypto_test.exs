defmodule Swotter.CryptoTest do

  use ExUnit.Case

  test "salt" do
    s1 = Swotter.Crypto.generate_random_salt
    s2 = Swotter.Crypto.generate_random_salt
    assert s1
    assert s2
    assert(s1 != s2)
  end

  test "hashing" do
    salt = Swotter.Crypto.generate_random_salt

    crypted = Swotter.Crypto.hash_password(salt, "foo")

    assert Swotter.Crypto.password_valid?(crypted, salt, "foo")

    refute Swotter.Crypto.password_valid?(crypted, "1234", "foo")
    refute Swotter.Crypto.password_valid?(crypted, salt, "bar")
    refute Swotter.Crypto.password_valid?(crypted <> "1", salt, "bar")
  end

end
