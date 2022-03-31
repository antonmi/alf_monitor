defmodule ALFMonitor.LiveViewBroadcaster do
  use GenServer

  defstruct pids: []

  def start_link([]) do
    GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__)
  end

  def init(%__MODULE__{} = state) do
    {:ok, state}
  end

  def add_pid(pid) do
    GenServer.call(__MODULE__, {:add_pid, pid})
  end

  def broadcast(data) do
    GenServer.cast(__MODULE__, {:broadcast, data})
  end

  def handle_call({:add_pid, pid}, _from, state) do
    state = %{state | pids: [pid | state.pids]}
    {:reply, state.pids, state}
  end

  def handle_cast({:broadcast, data}, state) do
    Enum.each(state.pids, &send(&1, {:send_data_to_client, data}))
    {:noreply, state}
  end
end
