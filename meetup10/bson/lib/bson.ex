defmodule BSON do

  @doc "Encodes a map into a BSON document"
  @spec encode(map) :: binary
  def encode(doc) do
    BSON.Encoder.encode_document(doc)
  end

  @doc "Decodes a BSON document at the start of the given stream and returns the corresponding map"
  @spec decode(binary) :: map
  def decode(stream) do
    BSON.Decoder.decode_document(stream)
  end

end
