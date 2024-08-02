defmodule SyntaxBlastServer.Game.Level do
  use Ecto.Schema
  import Ecto.Changeset

  schema "levels" do
    field :author, :string
    field :level_json, :string
    field :total_losses, :string
    field :total_wins, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(level, attrs) do
    level
    |> cast(attrs, [:author, :total_wins, :total_losses, :level_json])
    |> validate_required([:author, :total_wins, :total_losses, :level_json])
  end
end
