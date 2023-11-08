defmodule Tictactoe.Pipelines.UserCancelsGameTest do
  use Tictactoe.DataCase

  alias Tictactoe.{Games, Game, Repo, Users}
  alias Tictactoe.Pipelines.UserCancelsGame

  setup do
    UserCancelsGame.start()
  end

  def process_event(event) do
    [event] =
      [event]
      |> UserCancelsGame.stream()
      |> Enum.to_list()

    event
  end

  setup do
    {:ok, user_x} = Users.create("john")
    {:ok, user_o} = Users.create("jack")
    {:ok, game} = Games.create(user_x.uuid, user_o.uuid)
    %{user_x: user_x, user_o: user_o, game: game}
  end

  describe "success when game active" do
    setup %{user_x: user_x, game: game} do
      event = %UserCancelsGame{token: user_x.uuid, game_uuid: game.uuid}

      %{event: event, game: game}
    end

    test "check status ", %{event: event} do
      event = process_event(event)

      game_data = event.game_data

      assert %{
               field: [nil, nil, nil, nil, nil, nil, nil, nil, nil],
               status: "cancelled"
             } = game_data[:game]
    end
  end

  describe "when game is not active" do
    setup %{user_x: user_x, game: game} do
      {:ok, game} =
        game
        |> Game.changeset(%{status: Enum.random(["pending", "victory", "draw", "cancelled"])})
        |> Repo.update()

      event = %UserCancelsGame{token: user_x.uuid, game_uuid: game.uuid}

      %{event: event, game: game}
    end

    test "check error ", %{event: event} do
      event = process_event(event)

      assert event.error == :game_is_not_active
    end
  end
end
