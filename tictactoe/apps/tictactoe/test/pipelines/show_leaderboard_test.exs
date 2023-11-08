defmodule Tictactoe.Pipelines.ShowLeaderBoardTest do
  use Tictactoe.DataCase

  alias Tictactoe.{Repo, User, Users}
  alias Tictactoe.Pipelines.ShowLeaderBoard

  setup do
    ShowLeaderBoard.start()
  end

  def process_event(event) do
    [event] =
      [event]
      |> ShowLeaderBoard.stream()
      |> Enum.to_list()

    event
  end

  def create_user(name, scores) do
    {:ok, user} = Users.create(name)

    {:ok, user} =
      user
      |> User.changeset(%{scores: scores})
      |> Repo.update()

    user
  end

  setup do
    user1 = create_user("john", 5)
    user2 = create_user("jack", 10)
    %{user1: user1, user2: user2}
  end

  test "check users list" do
    event = process_event(%ShowLeaderBoard{})

    assert [
             %{name: "jack", scores: 10},
             %{name: "john", scores: 5}
           ] = event.users_list
  end
end
