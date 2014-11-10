defmodule SimpleMixin do


  defmacro __using__(name: name) do

  end
end


defmodule FriendlyModule do

  use SimpleMixin, name: "Peter"

  # same as:
  #     require SimpleMixin
  #     SimpleMixin.__using__

end
