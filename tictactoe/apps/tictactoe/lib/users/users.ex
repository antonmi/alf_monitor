defmodule Tictactoe.Users do
  import Ecto.Query

  alias Tictactoe.{User, Repo}

  def find(uuid) do
    Repo.get(User, uuid)
  rescue
    Ecto.Query.CastError ->
      nil
  end

  @spec create(String.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(name) do
    %User{}
    |> User.changeset(%{name: name})
    |> Repo.insert()
  end

  def where_name_starts_with(name) do
    like = "#{name}%"

    Repo.all(from(u in User, where: ilike(u.name, ^like)))
  end

  def increase_scores(user, value) do
    user
    |> User.changeset(%{scores: user.scores + value})
    |> Repo.update()
  end

  def users_for_uuids(uuids) do
    Repo.all(from(u in User, where: u.uuid in ^uuids))
  end

  def top_users() do
    Repo.all(from(u in User, limit: 10, order_by: [desc: :scores]))
  end
end
