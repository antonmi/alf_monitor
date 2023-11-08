defmodule Tictactoe.Pipelines.GameInfoTest do
  use Tictactoe.DataCase

  alias Tictactoe.{Games, Users}
  alias Tictactoe.Pipelines.GameInfo

  setup do
    GameInfo.start()
  end

  def process_event(event) do
    [event] =
      [event]
      |> GameInfo.stream()
      |> Enum.to_list()

    event
  end

  setup do
    {:ok, user} = Users.create("anton")
    {:ok, game} = Games.create(user.uuid, nil)

    %{game: game}
  end

  test "game data", %{game: game} do
    event = process_event(%GameInfo{uuid: game.uuid})

    assert %{
             game: %{
               field: [nil, nil, nil, nil, nil, nil, nil, nil, nil],
               status: "pending",
               turn_uuid: uuid,
               uuid: _game_uuid
             },
             user_o: %{},
             user_x: %{
               name: "anton",
               uuid: uuid
             }
           } = event.game_data
  end
end
