defmodule ALFMonitorWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: ALFMonitorWeb

      import Plug.Conn
      import ALFMonitorWeb.Gettext
      alias ALFMonitorpWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/alf_monitor_web/templates",
        namespace: ALFMonitorWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ALFMonitorWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ALFMonitorWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML
      import Phoenix.LiveView.Helpers
      import Phoenix.Component
      import Phoenix.View

      import ALFMonitorWeb.ErrorHelpers
      import ALFMonitorWeb.Gettext
      alias ALFMonitorWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
