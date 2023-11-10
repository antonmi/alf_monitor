defmodule ALFMonitor.Graph do
  @basic_width 160
  @basic_height 120

  def pipeline_to_graph(%{components: components, stats: stats}) do
    components = group_by_stage_set_ref(components)

    nodes =
      components
      |> Enum.map(fn component ->
        %{
          id: inspect(component.pid),
          data: component_data(component, stats),
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
            Enum.map(component.subscribed_to,
              fn
                {{to_pid, _to_ref}, _opts} ->
                  %{
                    id: "#{inspect(component.pid)}-#{inspect(to_pid)}",
                    source: inspect(component.pid),
                    target: inspect(to_pid)
                  }
                {to_ref, :sync} ->
                  %{
                    id: "#{inspect(component.pid)}-#{inspect(to_ref)}",
                    source: inspect(component.pid),
                    target: inspect(to_ref)
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
    |> Enum.reduce([], fn component, acc ->
      if component.type == :stage and component.count > 1 do
        if component.number == 0 do
          [component | acc]
        else
          acc
        end
      else
        [component | acc]
      end
    end)
    |> Enum.reverse()
  end

  defp component_data(component, stats) do
    width = width_for(component)
    height = height_for(component)

    data =
      component
      |> basic_component_data()
      |> Map.merge(%{width: width, height: height})

    case component[:type] do
      :producer ->
        counter = get_in(stats, [:producer, :counter])

        data
        |> Map.put(:ips_in_queue, length(component[:ips]))
        |> Map.put(:processed_ips, counter)
        |> Map.put(:avg_throughput, avg_throughput(stats[:since], counter))

      :consumer ->
        counter = get_in(stats, [:consumer, :counter])

        data
        |> Map.put(:processed_ips, counter)
        |> Map.put(:avg_throughput, avg_throughput(stats[:since], counter))

      :stage ->
        data
        |> Map.put(:max_throughput, component_max_throughput(component, stats))
        |> Map.put(:processed_ips, component_processed_ips(component, stats))
        |> Map.put(:average_processing_time, component_average_processing_time(component, stats))

      _other ->
        data
    end
  end

  defp basic_component_data(component) do
    Map.take(
      component,
      [
        :name,
        :pid,
        :pipe_module,
        :pipeline_module,
        :subscribed_to,
        :subscribers,
        :type,
        :module,
        :function,
        :count,
        :stage_set_ref,
        :opts,
        :source_code,
        :to
      ]
    )
  end

  def avg_throughput(since, counter) when not is_nil(since) and not is_nil(counter) do
    delta = DateTime.diff(DateTime.truncate(DateTime.utc_now(), :microsecond), since, :second)
    if delta > 0, do: round(counter / delta), else: 0
  end

  def avg_throughput(_since, _counter), do: :no_data

  defp component_max_throughput(_component, nil), do: :no_data

  defp component_max_throughput(component, stats) do
    stage_stats = Map.get(stats, component.stage_set_ref)

    if stage_stats do
      total_stage_set_speed(stage_stats)
    else
      :no_data
    end
  end

  defp component_processed_ips(_component, nil), do: :no_data

  defp component_processed_ips(component, stats) do
    stage_stats = Map.get(stats, component.stage_set_ref)

    if stage_stats do
      total_processed_ips(stage_stats)
    else
      :no_data
    end
  end

  defp component_average_processing_time(_component, nil), do: :no_data

  defp component_average_processing_time(component, stats) do
    stage_stats = Map.get(stats, component.stage_set_ref)

    if stage_stats do
      average_processing_time(stage_stats, component[:count])
    else
      :no_data
    end
  end

  defp total_stage_set_speed(stage_stats) do
    Enum.reduce(stage_stats, 0, fn {_key, data}, speed ->
      speed + round(data[:counter] / data[:sum_time_micro] * 1_000_000)
    end)
  end

  defp total_processed_ips(stage_stats) do
    Enum.reduce(stage_stats, 0, fn {_key, data}, count ->
      count + data[:counter]
    end)
  end

  defp average_processing_time(stage_stats, count) do
    sum =
      Enum.reduce(stage_stats, 0, fn {_key, data}, time ->
        time + data[:sum_time_micro] / data[:counter]
      end)

    Float.round(sum / count, 1)
  end

  defp width_for(%{count: _count}) do
    #    round(@basic_width * :math.pow(count, 1/3))
    @basic_width
  end

  defp width_for(_no_count), do: @basic_width

  defp height_for(%{count: _count}) do
    #    round(@basic_height * :math.pow(count, 1/3))
    @basic_height
  end

  defp height_for(_no_count), do: @basic_height
end
