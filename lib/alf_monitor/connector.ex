defmodule ALFMonitor.Connector do
  use GenServer

  @interval 500
  @node :node1@localhost
  # iex --sname node2@localhost -S mix

  alias ALFMonitor.TelemetryHandler

  defstruct pipelines: %{}

  def start_link([]) do
    GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__)
  end

  def init(%__MODULE__{} = state) do
    {:ok, state}
  end

  def pipelines(), do: GenServer.call(__MODULE__, :pipelines)
  def load_data(), do: GenServer.call(__MODULE__, :load_data)
  def init_telemetry_handlers(), do: GenServer.call(__MODULE__, :init_telemetry_handlers)

  def handle_call(:pipelines, _from, state), do:  {:reply, state.pipelines, state}

  def handle_call(:load_data, _from, state) do
    state = %{state | pipelines: do_load_data()}
    {:reply, state.pipelines, state}
  end

  def handle_call(:init_telemetry_handlers, _from, state) do
    :rpc.call(
      @node,
      ALF.TelemetryBroadcaster,
      :register_remote_function,
      [Node.self(), TelemetryHandler, :handle_event, [interval: @interval]]
    )
    {:reply, :ok, state}
  end


  defp do_load_data() do
    case Node.connect(@node) do
      true ->
        pipelines = :rpc.call(@node, ALF.Introspection, :pipelines, [])

        pipelines
        |> Enum.reduce(%{}, fn pipeline, acc ->
          components = :rpc.call(@node, ALF.Introspection, :components, [pipeline])
          stats = :rpc.call(@node, ALF.Introspection, :performance_stats, [pipeline])
          Map.merge(acc, %{pipeline => %{components: components, stats: stats}})
        end)

      false ->
        %{}

      :ignored ->
        %{}
    end
  end
end
