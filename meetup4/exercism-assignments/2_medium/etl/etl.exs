defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  Examples

  iex> ETL.transform(Enum.into([{"a", ["ABILITY", "AARDVARK"]}, {"b", ["BALLAST", "BEAUTY"]}], HashDict.new))
  Enum.into [{"ability", "a"},{"aardvark","a"},{"ballast","b"},{"beauty","b"}], HashDict.new
  """
  @spec transform(Dict.t) :: HashDict.t
  def transform(input) do

  end

end
