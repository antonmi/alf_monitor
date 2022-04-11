defmodule ALFMonitor.TelemetryHandler do

  alias ALFMonitor.LiveViewBroadcaster

  def handle_event([:alf, :component, :start], %{system_time: system_time}, metadata) do

    ip = metadata[:ip]

    pid = get_in(metadata, [:component, :pid])

    LiveViewBroadcaster.broadcast({pid, :start, div(system_time, 1000), ip})
  end

  def handle_event([:alf, :component, :stop], %{duration: duration}, metadata) do
#    IO.inspect("stop")
    ip = metadata[:ip]

    pid = get_in(metadata, [:component, :pid])
    LiveViewBroadcaster.broadcast({pid, :stop, div(duration, 1000), ip})
  end
end
