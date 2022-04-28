defmodule ALFMonitor.Graph do
  @basic_width 160
  @basic_height 120

  def pipeline_to_graph(components) do
    components = group_by_stage_set_ref(components)
    nodes =
      components
      |> Enum.map(fn component ->
        width = width_for(component)
        height = height_for(component)
        %{
          id: inspect(component.pid),
          data: Map.merge(component, %{width: width, height: height}),
          position: %{x: 0, y: -height},
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

  defp group_by_stage_set_ref(components) do
    components
    |> Enum.reduce([], fn(component, acc) ->
      if (component.type == :stage) and component.count > 1 do
        if component.number == 0 do
          [component | acc]
        else
          acc
        end
      else
        [component | acc]
      end
    end)
    |> Enum.reverse
  end

  defp width_for(%{count: count}) do
    round(@basic_width * :math.pow(count, 1/3))
    @basic_width
  end
  defp width_for(_no_count), do: @basic_width

  defp height_for(%{count: count}) do
#    round(@basic_height * :math.pow(count, 1/3))
    @basic_height
  end
  defp height_for(_no_count), do: @basic_height
end
