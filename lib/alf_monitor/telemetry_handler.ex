defmodule ALFMonitor.TelemetryHandler do
  alias ALFMonitor.LiveViewBroadcaster

  def handle_event([:alf, :component, :start], %{system_time: system_time}, metadata) do
    component = get_in(metadata, [:component])
    ip = metadata[:ip]

    LiveViewBroadcaster.broadcast(
      {:start, div(system_time, 1000), %{ip: ip, component: component}}
    )
  end

  def handle_event([:alf, :component, :stop], %{duration: duration}, metadata) do
    component = get_in(metadata, [:component])
    ip = metadata[:ip]
    LiveViewBroadcaster.broadcast({:stop, div(duration, 1000), %{ip: ip, component: component}})
  end
end
