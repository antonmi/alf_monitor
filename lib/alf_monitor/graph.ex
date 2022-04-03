defmodule ALFMonitor.Graph do
  # https://visjs.github.io/vis-network/docs/network/nodes.html#

  def pipeline_to_graph(components) do
    nodes =
      components
      |> Enum.map(fn(component) ->
        %{
          id: inspect(component.pid),
          label: component.name,
          shape: "box"
        }
      end)

    edges =
      components
      |> Enum.reduce([], fn(component, edges) ->
      if Enum.any?(component.subscribe_to) do
        new_edges = Enum.map(component.subscribe_to, fn({to, _opts}) ->
          %{
            from: inspect(component.pid),
            to: inspect(to)
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
