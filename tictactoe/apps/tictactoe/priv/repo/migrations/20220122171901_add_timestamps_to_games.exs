defmodule Tictactoe.Repo.Migrations.AddTimestampsToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      timestamps()
    end
  end
end
