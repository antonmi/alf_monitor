defmodule ALFMonitor.Graph do
  def pipeline_to_graph(components) do
    nodes =
      components
      |> Enum.map(fn component ->
        %{
          id: inspect(component.pid),
          data: Map.merge(component, %{width: 160, height: 120}),
          position: %{x: 0, y: 0},
          type: "componentNode",
          draggable: false
        }
      end)

    edges =
      components
      |> Enum.reduce([], fn component, edges ->
        if Enum.any?(component.subscribed_to) do
          new_edges =
            Enum.map(component.subscribed_to, fn {to, _ref} ->
              %{
                id: "#{inspect(component.pid)}-#{inspect(to)}",
                source: inspect(component.pid),
                target: inspect(to)
              }
            end)

          new_edges ++ edges
        else
          edges
        end
      end)

    {nodes, edges}
  end
end
