defmodule Tictactoe.Interfaces.ShowLeaderBoard do
  alias Tictactoe.EventPool
  alias Tictactoe.Pipelines.ShowLeaderBoard

  def call() do
    case EventPool.process_event(%ShowLeaderBoard{}) do
      {:ok, event} ->
        case event.error do
          nil ->
            {:ok, event.users_list}

          error ->
            {:error, error}
        end

      {:error, :error} ->
        {:error, :error}
    end
  end
end
