defmodule Tictactoe.Repo.Migrations.AddStatusToGame do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :status, :string, default: "pending"
    end
  end
end
