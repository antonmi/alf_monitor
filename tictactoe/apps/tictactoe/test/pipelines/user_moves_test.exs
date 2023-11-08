defmodule Tictactoe.Pipelines.UserMovesTest do
  use Tictactoe.DataCase

  alias Tictactoe.{Games, Game, Repo, Users}
  alias Tictactoe.Pipelines.UserMoves

  setup do
    UserMoves.start()
  end

  def process_event(event) do
    [event] =
      [event]
      |> UserMoves.stream()
      |> Enum.to_list()

    event
  end

  setup do
    {:ok, user_x} = Users.create("john")
    {:ok, user_o} = Users.create("jack")
    {:ok, game} = Games.create(user_x.uuid, user_o.uuid)
    %{user_x: user_x, user_o: user_o, game: game}
  end

  describe "simple success case - move in existing active game" do
    setup %{user_x: user_x, game: game} do
      event = %UserMoves{token: user_x.uuid, game_uuid: game.uuid, move: 4}

      %{event: event}
    end

    test "it sets 1 and return continue status", %{event: event, user_x: user_x, user_o: user_o} do
      event = process_event(event)

      game_data = event.game_data
      user_o_uuid = user_o.uuid

      assert %{
               field: [nil, nil, nil, nil, 1, nil, nil, nil, nil],
               status: "active",
               turn_uuid: ^user_o_uuid
             } = game_data[:game]

      user_x = Users.find(user_x.uuid)
      assert user_x.scores == 0
    end
  end

  describe "victory move" do
    setup %{user_x: user_x, game: game} do
      {:ok, game} =
        game
        |> Game.changeset(%{field: [1, 0, nil, nil, 1, 0, nil, nil, nil]})
        |> Repo.update()

      event = %UserMoves{token: user_x.uuid, game_uuid: game.uuid, move: 8}

      %{event: event, game: game}
    end

    test "status victory", %{event: event, user_x: user_x} do
      event = process_event(event)

      game_data = event.game_data
      user_x_uuid = user_x.uuid

      assert %{
               field: [1, 0, nil, nil, 1, 0, nil, nil, 1],
               status: "victory",
               turn_uuid: ^user_x_uuid
             } = game_data[:game]

      user_x = Users.find(user_x.uuid)
      assert user_x.scores == 3
    end
  end

  describe "draw move" do
    setup %{user_x: user_x, game: game} do
      {:ok, game} =
        game
        |> Game.changeset(%{field: [0, 1, 1, 1, 1, 0, 0, 0, nil]})
        |> Repo.update()

      event = %UserMoves{token: user_x.uuid, game_uuid: game.uuid, move: 8}

      %{event: event, game: game}
    end

    test "status victory", %{event: event, user_x: user_x} do
      event = process_event(event)

      game_data = event.game_data
      user_x_uuid = user_x.uuid

      assert %{
               field: [0, 1, 1, 1, 1, 0, 0, 0, 1],
               status: "draw",
               turn_uuid: ^user_x_uuid
             } = game_data[:game]

      user_x = Users.find(user_x.uuid)
      assert user_x.scores == 1
    end
  end

  describe "error case when game is not active" do
    setup %{user_x: user_x, game: game} do
      {:ok, game} =
        game
        |> Game.changeset(%{status: Enum.random(["pending", "victory", "draw"])})
        |> Repo.update()

      event = %UserMoves{token: user_x.uuid, game_uuid: game.uuid, move: 8}

      %{event: event, game: game}
    end

    test "error", %{event: event} do
      event = process_event(event)

      assert event.error == :game_is_not_active
    end
  end

  describe "error case when game is cancelled" do
    setup %{user_x: user_x, game: game} do
      {:ok, game} =
        game
        |> Game.changeset(%{status: "cancelled"})
        |> Repo.update()

      event = %UserMoves{token: user_x.uuid, game_uuid: game.uuid, move: 8}

      %{event: event, game: game}
    end

    test "error", %{event: event} do
      event = process_event(event)

      assert event.error == :game_is_cancelled
    end
  end
end
