defmodule BSON.Encoder do

  defprotocol TermEncoding do
    def encode(term)
  end

  defimpl TermEncoding, for: Float do

    def encode(term), do: {<< 0x01 >>, << term :: size(64)-float-little >>}
  end

  defimpl TermEncoding, for: Integer do

    def encode(term) when -0x80000000 <= term and term <= 0x80000000 do
      {<< 0x10 >>, <<(term) :: size(32)-integer-signed-little >>}
    end

    def encode(term), do: {<< 0x12 >>, <<(term) :: size(64)-integer-signed-little >>}
  end

  defimpl TermEncoding, for: BitString do

    def encode(term), do: {<< 0x02 >>, BSON.Encoder.cstring(term) }
  end

  defimpl TermEncoding, for: Atom do
    def encode(true),  do: {<< 0x08 >>, << 0x01 >> }
    def encode(false), do: {<< 0x08 >>, << 0x00 >> }
    def encode(nil),   do: {<< 0x0A >>, <<  >> }
  end


  @doc """
  Encodes a map into BSON document
  """
  @spec encode_document(map) :: binary
  def encode_document(map) do
    payload = encode(map)
    number_of_byte = byte_size(payload) + 5
    << number_of_byte :: size(32)-integer-little, payload :: bitstring , 0x00 >>
  end

  def cstring(key), do: key <> << 0x00 >>

  defp encode(map) do

    map |> Enum.reduce(<<>>, fn({key, val}, acc) ->
      {marker, payload} = TermEncoding.encode(val)

      acc <> marker <> cstring(key) <> payload

    end)
  end
end
