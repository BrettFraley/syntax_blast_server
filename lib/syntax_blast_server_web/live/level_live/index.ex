defmodule SyntaxBlastServerWeb.LevelLive.Index do
  use SyntaxBlastServerWeb, :live_view

  alias SyntaxBlastServer.Game
  alias SyntaxBlastServer.Game.Level

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :levels, Game.list_levels())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Level")
    |> assign(:level, Game.get_level!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Level")
    |> assign(:level, %Level{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Levels")
    |> assign(:level, nil)
  end

  @impl true
  def handle_info({SyntaxBlastServerWeb.LevelLive.FormComponent, {:saved, level}}, socket) do
    {:noreply, stream_insert(socket, :levels, level)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    level = Game.get_level!(id)
    {:ok, _} = Game.delete_level(level)

    {:noreply, stream_delete(socket, :levels, level)}
  end
end
