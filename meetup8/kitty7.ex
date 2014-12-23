# Please consult this page: http://elixir-lang.org/docs/stable/elixir/GenServer.html
# If not enough (and not afraid of Erlang): http://erldocs.com/current/stdlib/gen_server.html?i=0&search=gen_ser#undefined

defmodule Cat do
  defstruct name: "", color: :green, description: nil
end


defmodule KittyShop do

  use GenServer

  #### Client API ####

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end


  def order_cat(pid, name, color, description) do
    GenServer.call(pid, {:order, name, color, description} )
  end

  # asynchronous call
  def return_cat(pid, cat = %Cat{}) do
    GenServer.cast pid, {:return, cat}
  end

  # synchronous call
  def close_shop(pid) do
    GenServer.call(pid, :terminate)
  end


  ### Server ###

  # it's ok to delete it
  def init(state), do: {:ok, state}

  def handle_call({:order, name, color, description}, _from, cats) do
    case cats do

      [] ->
        new_cat = %Cat{name: name, color: color, description: description}

        { :reply, new_cat, cats }

      [first_cat | other_cats]  ->

        { :reply, first_cat, other_cats }
    end
  end

  def handle_call(:terminate, _from, cats) do

    cats
    |> Enum.each &( IO.puts "#{&1.name} is set free" )

    {:stop, :terminated, cats}

  end


  def handle_cast({:return, cat = %Cat{}}, cats) do
    {:noreply, [cat | cats]}
  end

end


defmodule KittyShopTest do


  def run do
    {:ok, kitty_shop_pid} = KittyShop.start_link

    cat0 = KittyShop.order_cat(kitty_shop_pid, "Bandit", "white", "likes to pee into shoes")

    IO.inspect cat0


    cat1 = KittyShop.order_cat(kitty_shop_pid, "Carl", "brown", "loves to burn bridges")

    IO.inspect cat1

    cat2 = KittyShop.order_cat(kitty_shop_pid, "Jimmy", "orange", "loves to purrrr")

    IO.inspect cat2


    KittyShop.return_cat(kitty_shop_pid, %Cat{})

    cat3 = KittyShop.order_cat(kitty_shop_pid, "Lucas", "black", "eats a lot")

    KittyShop.return_cat(kitty_shop_pid, cat1)
    KittyShop.return_cat(kitty_shop_pid, cat0)

    IO.inspect cat3 # oops :(

    KittyShop.close_shop(kitty_shop_pid)

    :ok
  end

end


KittyShopTest.run