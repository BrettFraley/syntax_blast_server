defmodule SyntaxBlastServerWeb.LevelLiveTest do
  use SyntaxBlastServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import SyntaxBlastServer.GameFixtures

  @create_attrs %{author: "some author", level_json: "some level_json", total_losses: "some total_losses", total_wins: "some total_wins"}
  @update_attrs %{author: "some updated author", level_json: "some updated level_json", total_losses: "some updated total_losses", total_wins: "some updated total_wins"}
  @invalid_attrs %{author: nil, level_json: nil, total_losses: nil, total_wins: nil}

  defp create_level(_) do
    level = level_fixture()
    %{level: level}
  end

  describe "Index" do
    setup [:create_level]

    test "lists all levels", %{conn: conn, level: level} do
      {:ok, _index_live, html} = live(conn, ~p"/levels")

      assert html =~ "Listing Levels"
      assert html =~ level.author
    end

    test "saves new level", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/levels")

      assert index_live |> element("a", "New Level") |> render_click() =~
               "New Level"

      assert_patch(index_live, ~p"/levels/new")

      assert index_live
             |> form("#level-form", level: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#level-form", level: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/levels")

      html = render(index_live)
      assert html =~ "Level created successfully"
      assert html =~ "some author"
    end

    test "updates level in listing", %{conn: conn, level: level} do
      {:ok, index_live, _html} = live(conn, ~p"/levels")

      assert index_live |> element("#levels-#{level.id} a", "Edit") |> render_click() =~
               "Edit Level"

      assert_patch(index_live, ~p"/levels/#{level}/edit")

      assert index_live
             |> form("#level-form", level: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#level-form", level: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/levels")

      html = render(index_live)
      assert html =~ "Level updated successfully"
      assert html =~ "some updated author"
    end

    test "deletes level in listing", %{conn: conn, level: level} do
      {:ok, index_live, _html} = live(conn, ~p"/levels")

      assert index_live |> element("#levels-#{level.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#levels-#{level.id}")
    end
  end

  describe "Show" do
    setup [:create_level]

    test "displays level", %{conn: conn, level: level} do
      {:ok, _show_live, html} = live(conn, ~p"/levels/#{level}")

      assert html =~ "Show Level"
      assert html =~ level.author
    end

    test "updates level within modal", %{conn: conn, level: level} do
      {:ok, show_live, _html} = live(conn, ~p"/levels/#{level}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Level"

      assert_patch(show_live, ~p"/levels/#{level}/show/edit")

      assert show_live
             |> form("#level-form", level: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#level-form", level: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/levels/#{level}")

      html = render(show_live)
      assert html =~ "Level updated successfully"
      assert html =~ "some updated author"
    end
  end
end
