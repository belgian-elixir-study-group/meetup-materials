defmodule BSON.Decoder do

  defp decode_element_value( 0x01, payload) do
    <<(float) :: size(64)-float-little, rest :: bitstring >> = payload
    {float, rest}
  end
  defp decode_element_value( 0x12, payload) do
    <<(int) :: size(64)-integer-signed-little, rest :: bitstring >> = payload
    {int, rest}
  end
  defp decode_element_value(0x10, payload) do
    <<(int) :: size(32)-integer-signed-little, rest :: bitstring >> = payload
    {int, rest}
  end
  defp decode_element_value(0x02, payload), do: take_cstring(payload)

  defp decode_element_value(0x08, <<0x00, rest :: bitstring>>), do: {false, rest}
  defp decode_element_value(0x08, <<0x01, rest :: bitstring>>), do: {true, rest}

  defp decode_element_value(0x0A, rest), do: {nil, rest}


  defp take_element(<<>>, elist_elements), do: elist_elements
  defp take_element(elist, elist_elements) do

    << marker :: size(8), rest :: bitstring >> = elist

    {ename, rest} = take_cstring rest

    {value, rest} = decode_element_value(marker, rest)

    take_element rest, Map.put(elist_elements, ename, value)
  end


  ###

  defp take_cstring(bin), do: take_cstring(bin, <<>>)

  defp take_cstring(<< 0x00,  rest :: bitstring >>, accu), do: {accu, rest}

  defp take_cstring(<< firstbyte :: bitstring-size(8) ,  rest :: bitstring >>, accu) do
    take_cstring(rest, accu <> firstbyte)
  end

  ###


  @doc """
  Decodes BSON document from the given binary.
  Returns a tuple with the decoded document and the rest of the stream"
  """
  @spec decode_document(binary) :: {map, binary}
  def decode_document(<< document_length :: size(32)-integer-little, elist :: bitstring >>) do

    payload_size = (document_length - 5) * 8

    << elist :: bitstring-size(payload_size), 0x00 >> = elist

    # IO.inspect elist

    take_element(elist, %{})
  end

end