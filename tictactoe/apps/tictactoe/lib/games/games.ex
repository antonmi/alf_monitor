defmodule Tictactoe.Games do
  import Ecto.Query

  alias Tictactoe.{Game, Repo, Users}

  def find(uuid) do
    Repo.get(Game, uuid)
  rescue
    Ecto.Query.CastError ->
      nil
  end

  def create(user_x_uuid, user_o_uuid) do
    status = if user_o_uuid, do: "active", else: "pending"

    %Game{}
    |> Game.changeset(%{
      user_x_uuid: user_x_uuid,
      user_o_uuid: user_o_uuid,
      turn_uuid: user_x_uuid,
      status: status
    })
    |> Repo.insert()
  end

  def insert(game) do
    Repo.insert(game, on_conflict: :replace_all, conflict_target: [:uuid])
  end

  def activate(game) do
    game
    |> Game.changeset(%{status: "active"})
    |> Repo.update()
  end

  def find_free_game() do
    Repo.all(
      from(g in Game,
        where: is_nil(g.user_o_uuid) and g.status == "pending"
      ),
      limit: 1
    )
    |> List.first()
  end

  def assign_second_player(game, user_uuid) do
    game
    |> Game.changeset(%{user_o_uuid: user_uuid})
    |> Repo.update()
  end

  def games_for_user(user_uuid) do
    Repo.all(
      from(
        g in base_query_for_user_game(user_uuid),
        order_by: [desc: :inserted_at]
      )
    )
  end

  def active_game_for_user(user_uuid) do
    Repo.one(
      from(
        g in base_query_for_user_game(user_uuid),
        where: g.status == "active"
      )
    )
  end

  defp base_query_for_user_game(user_uuid) do
    from(
      g in Game,
      where: g.user_x_uuid == ^user_uuid or g.user_o_uuid == ^user_uuid
    )
  end

  def pending_game_for_user(user_uuid) do
    Repo.one(
      from(
        g in Game,
        where: g.status == "pending",
        where: g.user_x_uuid == ^user_uuid
      )
    )
  end

  def game_data(game) do
    user_x = Users.find(game.user_x_uuid)
    user_o = if game.user_o_uuid, do: Users.find(game.user_o_uuid), else: %{}

    %{
      game: Map.take(game, [:uuid, :field, :user_x, :user_o, :turn_uuid, :status]),
      user_o: Map.take(user_o, [:uuid, :name]),
      user_x: Map.take(user_x, [:uuid, :name])
    }
  end

  def cancel_game(game) do
    game
    |> Game.changeset(%{status: "cancelled"})
    |> Repo.update()
  end
end
