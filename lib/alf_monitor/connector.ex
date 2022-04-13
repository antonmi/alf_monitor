defmodule ALFMonitor.Connector do
  use GenServer

  @interval 3_000
  @node :node1@localhost
  # iex --sname node2@localhost -S mix

  alias ALFMonitor.TelemetryHandler

  defstruct pipelines: %{}

  def start_link([]) do
    GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__)
  end

  def init(%__MODULE__{} = state) do
    {:ok, state, {:continue, :load_data}}
  end

  def handle_continue(:load_data, state) do
    {:noreply, %{state | pipelines: do_load_data()}, {:continue, :init_telemetry_handlers}}
  end

  def handle_continue(:init_telemetry_handlers, state) do
    :rpc.call(
      @node,
      ALF.TelemetryBroadcaster,
      :register_remote_function,
      [Node.self(), TelemetryHandler, :handle_event, [interval: @interval]]
    )

    {:noreply, state}
  end

  def load_data(), do: GenServer.call(__MODULE__, :load_data)
  def pipelines(), do: GenServer.call(__MODULE__, :pipelines)

  def handle_call(:load_data, _from, state) do
    state = %{state | pipelines: do_load_data()}
    {:reply, state.pipelines, state}
  end

  def handle_call(:pipelines, _from, state) do
    {:reply, state.pipelines, state}
  end

  defp do_load_data() do
    case Node.connect(@node) do
      true ->
        pipelines = :rpc.call(@node, ALF.Introspection, :pipelines, [])

        pipelines
        |> Enum.reduce(%{}, fn pipeline, acc ->
          info = :rpc.call(@node, ALF.Introspection, :info, [pipeline])
          Map.put(acc, pipeline, info)
        end)

      false ->
        %{}

      :ignored ->
        %{}
    end
  end
end
