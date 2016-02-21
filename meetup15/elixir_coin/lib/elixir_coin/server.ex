defmodule ElixirCoin.Server do
  use GenServer

  alias ElixirCoin.{Miners, Dispenser, EventManager}

  defmodule State do
    defstruct secret: nil,
              miners: %{},
              workload: 1,
              wallet: []
  end

  #
  # Public API
  #

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: Dict.get(args, :name, __MODULE__))
  end

  def register(pid, name) do
    GenServer.call(pid, {:hello, name})
  end

  def coin(pid, name, x) do
    GenServer.call(pid, {:coin, name, x})
  end

  def done(pid, name) do
    GenServer.call(pid, {:done, name})
  end

  def leaderboard(pid) do
    GenServer.call(pid, :leaderboard)
  end

  def workload(pid, new_workload) do
    GenServer.cast(pid, {:workload, new_workload})
  end

  def worth(pid) do
    GenServer.call(pid, :worth)
  end

  def reset(pid, workload \\ 0) do
    GenServer.cast(pid, {:reset, workload})
  end

  #
  # Callbacks
  #

  def init(args) do
    initial_state = %State{
      secret: Keyword.fetch!(args, :secret),
      workload: Keyword.fetch!(args, :initial_load)
    }
    {:ok, initial_state, 0}
  end

  def handle_call({:hello, name}, _from, state) do
    case Miners.register(state.miners, name) do
      {:ok, miners} ->
        broadcast_event({:miner_registered, name})
        {:reply, {:ok, state.secret, next_unit_of_work(state)}, %{state | miners: miners}}
      error ->
        {:reply, error, state}
    end
  end

  # TODO check that x is in the given range to avoid cheating?
  def handle_call({:coin, name, x}, _from, state) do
    if ElixirCoin.valid?(state.secret, x) do
      {:ok, miners} = Miners.new_coin(state.miners, name)
      {:ok, count} = Miners.coins_mined(miners, name)
      broadcast_event({:coin_mined, name, x})
      {:reply, {:ok, count}, %{state | miners: miners, wallet: [x|state.wallet]}}
    else
      {:reply, {:error, "verification failed"}, state}
    end
  end

  def handle_call({:done, _name}, _from, state) do
    {:reply, {:ok, next_unit_of_work(state)}, state}
  end

  def handle_call(:leaderboard, _from, state) do
    {:reply, {:ok, Miners.leaderboard(state.miners)}, state}
  end

  def handle_call(:worth, _from, state) do
    {:reply, {:ok, Enum.count(state.wallet)}, state}
  end

  def handle_cast({:reset, workload}, state) do
    {:noreply, %{state | miners: %{}, workload: workload, wallet: []}}
  end


  def handle_cast({:workload, new_workload}, state) when new_workload > 0 do
    broadcast_event({:workload_changed, state.workload, new_workload})
    {:noreply, %{state | workload: new_workload}}
  end

  #
  # Helpers
  #

  defp next_unit_of_work(%{workload: workload}) do
    Dispenser.take(workload)
  end

  defp broadcast_event(event) do
    GenEvent.notify(EventManager, event)
  end

end
