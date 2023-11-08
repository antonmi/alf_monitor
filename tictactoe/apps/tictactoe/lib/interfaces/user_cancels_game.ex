defmodule Tictactoe.Interfaces.UserCancelsGame do
  alias Tictactoe.EventPool
  alias Tictactoe.Pipelines.UserCancelsGame

  def call(game_uuid, token) do
    case EventPool.process_event(%UserCancelsGame{game_uuid: game_uuid, token: token}) do
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
