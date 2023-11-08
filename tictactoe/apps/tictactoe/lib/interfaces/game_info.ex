defmodule Tictactoe.Interfaces.GameInfo do
  alias Tictactoe.EventPool
  alias Tictactoe.Pipelines.GameInfo

  def call(uuid) do
    case EventPool.process_event(%GameInfo{uuid: uuid}) do
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
