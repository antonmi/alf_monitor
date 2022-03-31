defmodule ALFMonitor.TelemetryHandler do

  alias ALFMonitor.LiveViewBroadcaster

  def handle_event([:alf, :component, :start], _measurements, metadata) do
    IO.inspect("start")
    pipeline_module = get_in(metadata, [:component, :pipeline_module])
    name = get_in(metadata, [:component, :name])
    IO.inspect({pipeline_module, name})

    pid = get_in(metadata, [:component, :pid])
    LiveViewBroadcaster.broadcast({pid, :start})
  end

  def handle_event([:alf, :component, :stop], %{duration: _duration}, _metadata) do
    IO.inspect("stop")
#    pid = get_in(metadata, [:component, :pid])
#    LiveViewBroadcaster.broadcast({pid, :stop})
  end
end
