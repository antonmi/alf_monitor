defmodule Web.UserMoves do
  alias Tictactoe.Interfaces.UserMoves

  def call(game_uuid, move, token) do
    move = String.to_integer(move)

    case UserMoves.call(game_uuid, move, token) do
      {:ok, result} ->
        result

      {:error, error} ->
        %{error: error}
    end
  end
end
