Code.load_file("simple_mixin.exs")

ExUnit.start


defmodule SimpleMixinTest do
  use ExUnit.Case, async: true

  test "mixed-in function" do
    assert FriendlyModule.say_hello  == "I got added to this module by macro magic"
  end

  test "mixed-in function with a parametrized name" do
    assert FriendlyModule.say_buy  == "Bye, Peter"
  end

end
