defmodule ALFMonitorWeb.GraphLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use ALFMonitorWeb, :live_view
  alias ALFMonitor.{Connector, LiveViewBroadcaster}

  def render(assigns) do
    ~H"""
      <%= raw(Jason.encode!(assigns[:data])) %>
    """
  end

  def mount(params, opts, socket) do
    LiveViewBroadcaster.add_pid(self())
    {nodes, edges} = nodes_and_edges()
    socket =
      socket
      |> assign(:nodes, Jason.encode!(nodes))
      |> assign(:edges, Jason.encode!(edges))
    {:ok, socket}
  end

  def handle_event("changes", _value, socket) do
#    socket =
#      socket
#      |> assign(:light_bulb_status, "on")

    {:noreply, socket}
  end

  def handle_info({:send_data_to_client, {pid, action}}, socket) when action in [:start, :stop] do
    data = %{pid: inspect(pid), action: action}
    socket =
      socket
      |> assign(:data, Jason.encode!(data))
    {:noreply, socket}
  end

  defp nodes_and_edges do
    Connector.pipelines()
    |> Map.keys()
    |> Enum.reduce({[], []}, fn (module, {acc_nodes, acc_edges}) ->
      {nodes, edges} = pipeline_graph(module)
      {acc_nodes ++ nodes, acc_edges ++ edges}
    end)
  end


  defp pipeline_graph(pipeline) do
    ALFMonitor.Connector.pipelines[pipeline]
    |> ALFMonitor.Graph.pipeline_to_graph()
  end

end
