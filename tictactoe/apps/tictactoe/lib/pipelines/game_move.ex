defmodule Tictactoe.Pipelines.GameMove do
  use ALF.DSL

  alias Tictactoe.{Game, Move}

  defstruct game: %Game{},
            move: %Move{},
            result: nil,
            error: nil

  @type t :: %__MODULE__{
          game: Game.t(),
          move: Move.t(),
          # "active" | "victory" | "draw",
          result: String.t(),
          error: atom
        }

  @components [
    stage(:validate_move),
    done(:done_if_move_is_not_valid),
    stage(:apply_move),
    stage(:check_game_status),
    stage(:toggle_turn)
  ]

  def validate_move(%__MODULE__{game: game, move: move} = event, _opts) do
    case Game.validate_move(game, move) do
      :ok ->
        event

      {:error, error} ->
        %{event | error: error}
    end
  end

  def done_if_move_is_not_valid(%__MODULE__{error: nil}, _opts), do: false
  def done_if_move_is_not_valid(%__MODULE__{error: _error}, _opts), do: true

  def apply_move(%__MODULE__{error: nil} = event, _opts) do
    game = Game.apply_move(event.game, event.move)
    %{event | game: game}
  end

  def check_game_status(%__MODULE__{error: nil, game: game} = event, _opts) do
    status = Game.check_game_status(event.game)

    %{event | result: status, game: %{game | status: status}}
  end

  def toggle_turn(%__MODULE__{error: nil, game: game, result: status} = event, _opts) do
    game =
      if status == "active" do
        Game.toggle_turn(game)
      else
        game
      end

    %{event | game: game}
  end
end
