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
    nodes = Base.encode64(Jason.encode!(nodes))
    edges = Base.encode64(Jason.encode!(edges))
    socket =
      socket
      |> assign(:nodes, nodes)
      |> assign(:edges, edges)
    {:ok, socket}
  end

  def handle_event("changes", _value, socket) do
    {:noreply, socket}
  end

  def handle_info({:send_data_to_client, {pid, action, time, ip}}, socket) when action in [:start, :stop] do
    data = case action do
      :start ->
        %{pid: inspect(pid), time: time, action: action, ip: ip}
      :stop ->
        %{pid: inspect(pid), duration: time, action: action, ip: ip}
    end
    socket =
      socket
      |> assign(:data, Base.encode64(Jason.encode!(data)))
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
