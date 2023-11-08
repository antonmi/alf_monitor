defmodule Tictactoe.Pipelines.ShowLeaderBoard do
  use ALF.DSL

  alias Tictactoe.{User, Users}

  defstruct users: nil,
            users_list: [],
            error: nil

  @type t :: %__MODULE__{
          users: list(User.t()),
          users_list: list(map())
        }

  @components [
    stage(:find_users),
    stage(:format_users_list)
  ]

  def find_users(%__MODULE__{} = event, _) do
    users = Users.top_users()
    %{event | users: users}
  end

  def format_users_list(%__MODULE__{users: users} = event, _) do
    users_list =
      users
      |> Enum.map(
        &%{
          name: &1.name,
          scores: &1.scores
        }
      )

    %{event | users_list: users_list}
  end
end
