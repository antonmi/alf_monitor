defmodule ALFMonitor.Graph do
  # https://visjs.github.io/vis-network/docs/network/nodes.html#

  def pipeline_to_graph(components) do
    nodes =
      components
      |> Enum.map(fn(component) ->
#      IO.inspect("========================================================")
#      IO.inspect(component)
        %{
          id: inspect(component.pid),
          data: %{label: component.name, type: component.type},
          position: %{x: 0, y: 0},
          type: "customNode",
          draggable: false
        }
      end)

    edges =
      components
      |> Enum.reduce([], fn(component, edges) ->
      if Enum.any?(component.subscribe_to) do
        new_edges = Enum.map(component.subscribe_to, fn({to, _opts}) ->
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

    goto_edges = []
#      components
#      |> Enum.reduce([], fn(component, edges) ->
#        if component[:type] == :goto do
#          goto_point = Enum.find(components, &(&1[:name] == component[:to]))
#
#          edge = %{
#              from: inspect(component.pid),
#              to: inspect(goto_point.pid)
#            }
#
#          edges ++ [edge]
#        else
#          edges
#        end
#      end)

    {nodes, edges ++ goto_edges}
  end
end
