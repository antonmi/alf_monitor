defmodule Tictactoe.Repo.Migrations.AddScoresToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :scores, :integer, null: false, default: 0
    end
  end
end
