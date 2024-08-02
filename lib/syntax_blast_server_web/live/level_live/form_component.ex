defmodule SyntaxBlastServerWeb.LevelLive.FormComponent do
  use SyntaxBlastServerWeb, :live_component

  alias SyntaxBlastServer.Game

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage level records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="level-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:author]} type="text" label="Author" />
        <.input field={@form[:total_wins]} type="text" label="Total wins" />
        <.input field={@form[:total_losses]} type="text" label="Total losses" />
        <.input field={@form[:level_json]} type="text" label="Level json" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Level</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{level: level} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Game.change_level(level))
     end)}
  end

  @impl true
  def handle_event("validate", %{"level" => level_params}, socket) do
    changeset = Game.change_level(socket.assigns.level, level_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"level" => level_params}, socket) do
    save_level(socket, socket.assigns.action, level_params)
  end

  defp save_level(socket, :edit, level_params) do
    case Game.update_level(socket.assigns.level, level_params) do
      {:ok, level} ->
        notify_parent({:saved, level})

        {:noreply,
         socket
         |> put_flash(:info, "Level updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_level(socket, :new, level_params) do
    case Game.create_level(level_params) do
      {:ok, level} ->
        notify_parent({:saved, level})

        {:noreply,
         socket
         |> put_flash(:info, "Level created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
