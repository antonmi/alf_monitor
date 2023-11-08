defmodule Tictactoe.Pipelines.GameMoveAdapter do
  alias Tictactoe.Pipelines.{UserMoves, GameMove}
  alias Tictactoe.Move

  def plug(%UserMoves{} = event, _opts) do
    %GameMove{
      game: event.game,
      move: %Move{
        user_uuid: event.user.uuid,
        position: event.move
      }
    }
  end

  def unplug(%GameMove{} = event, %UserMoves{} = user_moves_event, _opts) do
    %{user_moves_event | game: event.game, move_result: event.result, error: event.error}
  end
end
