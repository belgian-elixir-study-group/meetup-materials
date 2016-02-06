defmodule ElixirCoin do

  def valid?(secret, x) do
    "#{secret}#{x}"
    |> hash
    |> String.starts_with?("00000")
  end

  defp hash(data) do
    :erlang.md5(data) |> Base.encode16(case: :lower)
  end

end
