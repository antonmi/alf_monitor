defmodule Tictactoe.GameTest do
  use ExUnit.Case

  alias Tictactoe.{Game, Move}

  @empty_field [nil, nil, nil, nil, nil, nil, nil, nil, nil]

  def build_game(field \\ @empty_field) do
    %Game{
      field: field,
      user_x_uuid: "user_x",
      user_o_uuid: "user_o",
      turn_uuid: "user_x"
    }
  end

  describe "validate_move/2" do
    test "valid move" do
      game = build_game()
      move = %Move{user_uuid: "user_x", position: 1}
      assert :ok = Game.validate_move(game, move)
    end

    test "not you turn" do
      game = build_game()
      move = %Move{user_uuid: "user_o", position: 1}
      assert {:error, :not_your_turn} = Game.validate_move(game, move)
    end

    test "position outside range" do
      game = build_game()
      move = %Move{user_uuid: "user_x", position: 10}
      assert {:error, :position_outside_range} = Game.validate_move(game, move)
    end

    test "square is taken" do
      game = build_game([1, 0, nil, nil, nil, nil, nil, nil, nil])
      move = %Move{user_uuid: "user_x", position: 1}
      assert {:error, :square_is_taken} = Game.validate_move(game, move)
    end
  end

  describe "apply_move/2" do
    setup do
      game = build_game([1, 0, nil, nil, nil, nil, nil, nil, nil])
      move = %Move{user_uuid: "user_x", position: 4}
      %{game: game, move: move}
    end

    test "game field", %{game: game, move: move} do
      new_game = Game.apply_move(game, move)
      assert new_game.field == [1, 0, nil, nil, 1, nil, nil, nil, nil]
    end
  end

  describe "toggle_turn/2" do
    setup do
      game = build_game([1, 0, nil, nil, nil, nil, nil, nil, nil])
      move = %Move{user_uuid: "user_x", position: 4}
      %{game: game, move: move}
    end

    test "game turn", %{game: game} do
      new_game = Game.toggle_turn(game)
      assert new_game.turn_uuid == "user_o"
    end
  end

  describe "check_game_status/1" do
    test "active" do
      game = %Game{field: [1, 0, nil, nil, 1, nil, nil, nil, nil]}
      assert "active" = Game.check_game_status(game)
    end

    test "victory cases" do
      [
        # rows
        %Game{field: [1, 1, 1, nil, 1, nil, nil, nil, nil]},
        %Game{field: [1, 1, nil, 0, 0, 0, nil, nil, nil]},
        # columns
        %Game{field: [1, 1, nil, 1, 0, 0, 1, nil, nil]},
        %Game{field: [1, nil, 0, nil, 0, 0, 1, nil, 0]},
        # diagonals
        %Game{field: [1, nil, 0, nil, 1, 0, 1, nil, 1]},
        %Game{field: [1, nil, 0, nil, 0, nil, 0, nil, 1]}
      ]
      |> Enum.map(fn game ->
        assert "victory" = Game.check_game_status(game)
      end)
    end

    test "draw cases" do
      [
        %Game{field: [1, 0, 1, 0, 1, 0, 0, 1, 0]}
      ]
      |> Enum.map(fn game ->
        assert "draw" = Game.check_game_status(game)
      end)
    end
  end
end
