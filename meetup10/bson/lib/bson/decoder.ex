defmodule BSON.Decoder do

  @doc """
  Decodes BSON document from the given binary.
  Returns a tuple with the decoded document and the rest of the stream"
  """
  @spec decode_document(binary) :: {map, binary}
  def decode_document(stream) do
  end

end