defmodule Tictactoe.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :uuid, :uuid,
          primary_key: true,
          null: false,
          default: fragment("gen_random_uuid()")

      add :field, {:array, :integer}, null: false
      add :user_x_uuid, references(:users, column: :uuid, type: :uuid)
      add :user_o_uuid, references(:users, column: :uuid, type: :uuid)
      add :turn_uuid, references(:users, column: :uuid, type: :uuid)
    end
  end
end
