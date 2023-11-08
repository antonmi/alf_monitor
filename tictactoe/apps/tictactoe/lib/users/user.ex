defmodule Tictactoe.User do
  use Ecto.Schema
  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "users" do
    field(:name, :string)
    field(:scores, :integer, default: 0)

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> Changeset.cast(attrs, [:name, :scores])
    |> Changeset.validate_required([:name])
  end
end
