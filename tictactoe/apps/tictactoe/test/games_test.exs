defmodule Tictactoe.GamesTest do
  use Tictactoe.DataCase

  alias Tictactoe.{Games, Users}

  setup do
    {:ok, user_x} = Users.create("user_x")
    {:ok, user_o} = Users.create("user_o")
    %{user_x: user_x, user_o: user_o}
  end

  describe "find_game/1" do
    setup %{user_x: user_x, user_o: user_o} do
      {:ok, game} = Games.create(user_x.uuid, user_o.uuid)
      %{game: game}
    end

    test "it finds the game", %{game: game} do
      assert Games.find(game.uuid)
    end
  end

  describe "create" do
    test "success case", %{user_x: user_x, user_o: user_o} do
      {:ok, game} = Games.create(user_x.uuid, user_o.uuid)
      assert game.field == [nil, nil, nil, nil, nil, nil, nil, nil, nil]
      assert game.turn_uuid == user_x.uuid
      assert game.status == "active"
    end

    test "success case without user_o", %{user_x: user_x} do
      {:ok, game} = Games.create(user_x.uuid, nil)
      assert game.turn_uuid == user_x.uuid
      assert is_nil(game.user_o_uuid)
      assert game.status == "pending"
    end
  end

  describe "find_free_game/0" do
    test "when there is a free game", %{user_x: user_x} do
      {:ok, game} = Games.create(user_x.uuid, nil)
      assert Games.find_free_game() == game
    end

    test "when there is no free game", %{user_x: user_x, user_o: user_o} do
      {:ok, _game} = Games.create(user_x.uuid, user_o.uuid)
      assert is_nil(Games.find_free_game())
    end
  end

  describe "assign_second_player/2" do
    setup %{user_x: user_x} do
      {:ok, game} = Games.create(user_x.uuid, nil)
      %{game: game}
    end

    test "it assigns a user", %{game: game, user_o: user_o} do
      {:ok, game} = Games.assign_second_player(game, user_o.uuid)
      game = Games.find(game.uuid)
      assert game.user_o_uuid == user_o.uuid
    end
  end

  describe "game_data/1" do
    setup %{user_x: user_x, user_o: user_o} do
      {:ok, game} = Games.create(user_x.uuid, user_o.uuid)
      %{game: game}
    end

    test "it returns game_data", %{game: game} do
      game_data = Games.game_data(game)
      assert game_data[:game]
      assert game_data[:user_x]
      assert game_data[:user_o]
    end
  end

  describe "games_for_user/1" do
    test "when there is a game", %{user_x: user_x, user_o: user_o} do
      {:ok, game1} = Games.create(user_x.uuid, user_o.uuid)
      {:ok, game2} = Games.create(user_o.uuid, user_x.uuid)
      games = Games.games_for_user(user_x.uuid)
      assert games == [game1, game2]
    end
  end

  describe "active_game_for_user/1" do
    test "when there is a game", %{user_x: user_x, user_o: user_o} do
      {:ok, game} = Games.create(user_x.uuid, user_o.uuid)
      assert ^game = Games.active_game_for_user(user_x.uuid)
      assert ^game = Games.active_game_for_user(user_o.uuid)
    end

    test "when there no such game", %{user_x: user_x} do
      {:ok, _game} = Games.create(user_x.uuid, nil)
      assert is_nil(Games.active_game_for_user(user_x.uuid))
    end
  end

  describe "pending_game_for_user/1" do
    test "when there is a game", %{user_x: user_x} do
      {:ok, game} = Games.create(user_x.uuid, nil)
      assert ^game = Games.pending_game_for_user(user_x.uuid)
    end
  end

  describe "cancel_game/1" do
    test "cancelled status", %{user_x: user_x} do
      {:ok, game} = Games.create(user_x.uuid, nil)
      {:ok, game} = Games.cancel_game(game)
      assert game.status == "cancelled"
    end
  end
end
