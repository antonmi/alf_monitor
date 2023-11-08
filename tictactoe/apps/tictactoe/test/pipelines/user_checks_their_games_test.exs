defmodule Tictactoe.Pipelines.UserChecksTheirGamesTest do
  use Tictactoe.DataCase

  alias Tictactoe.{Games, Users}
  alias Tictactoe.Pipelines.UserChecksTheirGames

  setup do
    UserChecksTheirGames.start()
  end

  def process_event(event) do
    [event] =
      [event]
      |> UserChecksTheirGames.stream()
      |> Enum.to_list()

    event
  end

  setup do
    {:ok, user} = Users.create("john")
    {:ok, user_o} = Users.create("jimmy")
    {:ok, user_x} = Users.create("jack")
    {:ok, game1} = Games.create(user.uuid, user_o.uuid)
    {:ok, game2} = Games.create(user_x.uuid, user.uuid)
    {:ok, game3} = Games.create(user.uuid, nil)
    %{user: user, game1: game1, game2: game2, game3: game3}
  end

  describe "success case" do
    setup %{user: user} do
      event = %UserChecksTheirGames{token: user.uuid}

      %{event: event}
    end

    test "check games list ", %{event: event} do
      event = process_event(event)
      [game3, game2, game1] = event.games_list

      assert %{
               field: [nil, nil, nil, nil, nil, nil, nil, nil, nil],
               opponent_name: nil,
               status: "pending",
               uuid: _uuid
             } = game1

      assert game2.opponent_name == "jack"
      assert game3.opponent_name == "jimmy"
    end
  end
end
