defmodule SyntaxBlastServer.Repo.Migrations.CreateLevels do
  use Ecto.Migration

  def change do
    create table(:levels) do
      add :author, :string
      add :total_wins, :string
      add :total_losses, :string
      add :level_json, :string

      timestamps(type: :utc_datetime)
    end
  end
end
