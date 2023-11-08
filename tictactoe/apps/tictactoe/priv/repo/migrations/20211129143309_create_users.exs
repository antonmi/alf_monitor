defmodule Tictactoe.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :uuid, :uuid,
          primary_key: true,
          null: false,
          default: fragment("gen_random_uuid()")
      add :name, :string
    end

    create index(:users, [:name])
  end
end
