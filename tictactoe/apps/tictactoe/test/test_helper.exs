ExUnit.start(capture_log: true)
Ecto.Adapters.SQL.Sandbox.mode(Tictactoe.Repo, :manual)

defmodule Tictactoe.DataCase do
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias Tictactoe.Repo
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Tictactoe.Repo)

    unless tags[:async] do
      Sandbox.mode(Tictactoe.Repo, {:shared, self()})
    end
  end
end
