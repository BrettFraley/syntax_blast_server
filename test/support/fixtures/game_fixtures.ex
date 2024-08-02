defmodule SyntaxBlastServer.GameFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SyntaxBlastServer.Game` context.
  """

  @doc """
  Generate a level.
  """
  def level_fixture(attrs \\ %{}) do
    {:ok, level} =
      attrs
      |> Enum.into(%{
        author: "some author",
        level_json: "some level_json",
        total_losses: "some total_losses",
        total_wins: "some total_wins"
      })
      |> SyntaxBlastServer.Game.create_level()

    level
  end
end
