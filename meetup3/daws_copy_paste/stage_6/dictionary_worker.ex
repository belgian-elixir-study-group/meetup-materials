defmodule Daws.DictionaryWorker do

  use GenServer

  def start_link(dictionary_filename) do
    GenServer.start_link(__MODULE__, dictionary_filename, name: :dictionary_worker)
  end



  def init(dictionary_filename) do
    # IO.inspect "initializing with dictionary #{dictionary_filename}"
    signature_table = Daws.Dictionary.load_signature_table(dictionary_filename)
    { :ok, signature_table }
  end


  def handle_call({:anagrams_for, word}, _from, signature_table) do
    words = Daws.AnagramSolver.anagrams_for(word, signature_table)
    { :reply, words, signature_table }
  end

end
