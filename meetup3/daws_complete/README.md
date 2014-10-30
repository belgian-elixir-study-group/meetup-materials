DAWS: Devspace Anagram Web Server :)
================

iex -S mix

mix anagram.launch

mix run --no-halt


<!-- do not start apps, but load the code -->
iex -S mix run --no-start



1) show counter.exs
    http://learnyousomeerlang.com/static/img/common-pattern.png

2) gen_server

3) overview of OTP: gen_servers, supervisors, OTP apps
https://www.safaribooksonline.com/library/view/erlang-programming/9780596803940/httpatomoreillycomsourceoreillyimages300738.png

one_for_one - if one child process terminates and should be restarted, only that child process is affected.
one_for_all - if one child process terminates and should be restarted, all other child processes are terminated and then all child processes are restarted.
rest_for_one
simple_one_for_one

standardization & guidelines
conventions
one framework template

:observer.start

4)

1> A = 2323.
2323
2> asdfasd.
asdfasd
4> lists:last([1,2,4]).


echo  "defmodule Foo do  def the_answer, do: 42 ; end" > foo.ex
elixirc foo.ex

5)
mix new foo --sup

show the app and :observer.start and :application.which_applications

iex -S mix run --no-start
Application.ensure_all_started(:daws)

iex -S mix
Application.stop(:daws)
Application.start(:daws)


6)
mix new daws

7)
mix.exs and daws.app

description: "Devspace anagram webserver",

8)
https://github.com/elixir-lang/plug

9) installation and
mix deps.get

iex -S mix
:observer.start

10)
Add a plug

copy stage 0

11)
in iex:  Plug.Adapters.Cowboy.http Daws.Plug, []

12)

mix task
lib/mix/tasks/daws

copy stage 1:  mix task

mix launch

13) Daws.AnagramSolver.word_signature
copy  stage 2   and anagram_solver.ex

14) Daws.Dictionary.load_words
copy tests stage 3   and dictionary.ex and dictionaries

15) Daws.Dictionary.load_signature_table

copy tests stage 4

first implement with Map


===
  def load_signature_table(dictionary_filename \\ @dictionary) do
    words = load_words(dictionary_filename)

    Enum.reduce words, Map.new, fn(word, map) ->

      signature = Daws.AnagramSolver.word_signature(word)

      Map.update(
        map,
        signature,
        [word],
        fn(word_list_before_insertion) ->
          [word | word_list_before_insertion]
        end
      )
    end

  end
===

- very slow
- force a smaller library
- removed old tests

protocols

Dict.update
HashDict.new

16)
richest_word_signature and anagrams_for
copy tests stage 5


17)
One app missing - our application
OTP app without its own sup tree

copy  stage 6

mod: { Daws, ["american-english-large"] },

remove Plug.Adapters.Cowboy.http Daws.Plug, []  from the mix task

:observer

review the code

18) Move
words = GenServer.call(:dictionary_worker, {:anagrams_for, "bates"})
into Daws.DictionaryWorker

  def anagrams_for(word) do
    GenServer.call(:dictionary_worker, {:anagrams_for, word})
  end

19)
Use Plug.Conn.Utils.params(conn.query_string) and pattern matching to process the real word
http://elixir-lang.org/docs/plug/

===
  def call(conn, _opts) do

    response = case Plug.Conn.Utils.params(conn.query_string) do
      %{"word" => word} ->

        words = Daws.DictionaryWorker.anagrams_for(word)
        readable_words = Enum.join(words, ", ")

        # IO.puts "#{word} -> #{readable_words}"

      _ -> "Please form your query like this:  ?word=beats"
    end

    conn  |> put_resp_content_type("text/plain")  |> send_resp(200, response)
  end
===

20) copy stage 7
Add json:  https://github.com/cblage/elixir-json

one of those cases when you don't need to start an OTP app, you just add it

21)
mix run --no-halt