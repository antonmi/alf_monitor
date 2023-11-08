defmodule Tictactoe.Pipelines.GameMoveTest do
  use ExUnit.Case

  alias Tictactoe.{Game, Move}
  alias Tictactoe.Pipelines.GameMove

  def build_game(field) do
    %Game{
      field: field,
      user_x_uuid: "user_x",
      user_o_uuid: "user_o",
      turn_uuid: "user_x"
    }
  end

  setup do
    GameMove.start()
  end

  setup do
    game = build_game([1, nil, nil, nil, nil, nil, nil, nil, nil])
    move = %Move{user_uuid: "user_x", position: 4}
    %{game: game, move: move}
  end

  describe "success case" do
    test "pipeline", %{game: game, move: move} do
      event = %GameMove{game: game, move: move}

      [%GameMove{game: game, error: error, result: result}] =
        [event]
        |> GameMove.stream()
        |> Enum.to_list()

      assert is_nil(error)
      assert result == "active"

      assert game.field == [1, nil, nil, nil, 1, nil, nil, nil, nil]
      assert game.turn_uuid == "user_o"
    end

    test "victory case" do
      game = build_game([1, nil, nil, nil, 1, nil, nil, nil, nil])
      move = %Move{user_uuid: "user_x", position: 8}

      [%GameMove{game: game, error: error, result: result}] =
        [%GameMove{game: game, move: move}]
        |> GameMove.stream()
        |> Enum.to_list()

      assert is_nil(error)
      assert result == "victory"

      assert game.field == [1, nil, nil, nil, 1, nil, nil, nil, 1]
      assert game.turn_uuid == "user_x"
    end

    test "draw case" do
      game = build_game([0, 1, 1, 1, 1, 0, 0, 0, nil])
      move = %Move{user_uuid: "user_x", position: 8}

      [%GameMove{game: game, error: error, result: result}] =
        [%GameMove{game: game, move: move}]
        |> GameMove.stream()
        |> Enum.to_list()

      assert is_nil(error)
      assert result == "draw"

      assert game.field == [0, 1, 1, 1, 1, 0, 0, 0, 1]
      assert game.turn_uuid == "user_x"
    end
  end

  describe "error cases" do
    test "invalid move", %{game: game} do
      move = %Move{user_uuid: "user_x", position: 0}

      [%GameMove{game: new_game, error: error}] =
        [%GameMove{game: game, move: move}]
        |> GameMove.stream()
        |> Enum.to_list()

      assert error == :square_is_taken

      assert new_game.field == [1, nil, nil, nil, nil, nil, nil, nil, nil]
      assert new_game.turn_uuid == "user_x"
    end
  end
end
