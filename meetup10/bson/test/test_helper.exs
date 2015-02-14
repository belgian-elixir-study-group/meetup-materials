ExUnit.start()

defmodule BSONCodecTestHelpers do

  defmacro assert_bson_codec(document) do
    quote do
      assert (unquote(document) |> BSON.encode |> BSON.decode) == unquote(document)
    end
  end

end