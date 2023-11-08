defmodule Tictactoe.Interfaces.UserMoves do
  alias Tictactoe.EventPool
  alias Tictactoe.Pipelines.UserMoves

  def call(game_uuid, move, token) do
    case EventPool.process_event(%UserMoves{game_uuid: game_uuid, move: move, token: token}) do
      {:ok, event} ->
        case event.error do
          nil ->
            {:ok, event.game_data}

          error ->
            {:error, error}
        end

      {:error, :error} ->
        {:error, :error}
    end
  end
end
