defmodule SyntaxBlastServer.GameTest do
  use SyntaxBlastServer.DataCase

  alias SyntaxBlastServer.Game

  describe "levels" do
    alias SyntaxBlastServer.Game.Level

    import SyntaxBlastServer.GameFixtures

    @invalid_attrs %{author: nil, level_json: nil, total_losses: nil, total_wins: nil}

    test "list_levels/0 returns all levels" do
      level = level_fixture()
      assert Game.list_levels() == [level]
    end

    test "get_level!/1 returns the level with given id" do
      level = level_fixture()
      assert Game.get_level!(level.id) == level
    end

    test "create_level/1 with valid data creates a level" do
      valid_attrs = %{author: "some author", level_json: "some level_json", total_losses: "some total_losses", total_wins: "some total_wins"}

      assert {:ok, %Level{} = level} = Game.create_level(valid_attrs)
      assert level.author == "some author"
      assert level.level_json == "some level_json"
      assert level.total_losses == "some total_losses"
      assert level.total_wins == "some total_wins"
    end

    test "create_level/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_level(@invalid_attrs)
    end

    test "update_level/2 with valid data updates the level" do
      level = level_fixture()
      update_attrs = %{author: "some updated author", level_json: "some updated level_json", total_losses: "some updated total_losses", total_wins: "some updated total_wins"}

      assert {:ok, %Level{} = level} = Game.update_level(level, update_attrs)
      assert level.author == "some updated author"
      assert level.level_json == "some updated level_json"
      assert level.total_losses == "some updated total_losses"
      assert level.total_wins == "some updated total_wins"
    end

    test "update_level/2 with invalid data returns error changeset" do
      level = level_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_level(level, @invalid_attrs)
      assert level == Game.get_level!(level.id)
    end

    test "delete_level/1 deletes the level" do
      level = level_fixture()
      assert {:ok, %Level{}} = Game.delete_level(level)
      assert_raise Ecto.NoResultsError, fn -> Game.get_level!(level.id) end
    end

    test "change_level/1 returns a level changeset" do
      level = level_fixture()
      assert %Ecto.Changeset{} = Game.change_level(level)
    end
  end
end
