defmodule SyntaxBlastServerWeb.LevelLive.Show do
  use SyntaxBlastServerWeb, :live_view

  alias SyntaxBlastServer.Game

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:level, Game.get_level!(id))}
  end

  defp page_title(:show), do: "Show Level"
  defp page_title(:edit), do: "Edit Level"
end
