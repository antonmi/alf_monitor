defmodule Tictactoe.Interfaces.UserChecksTheirGames do
  alias Tictactoe.EventPool
  alias Tictactoe.Pipelines.UserChecksTheirGames

  def call(token) do
    case EventPool.process_event(%UserChecksTheirGames{token: token}) do
      {:ok, event} ->
        case event.error do
          nil ->
            {:ok, event.games_list}

          error ->
            {:error, error}
        end

      {:error, :error} ->
        {:error, :error}
    end
  end
end
