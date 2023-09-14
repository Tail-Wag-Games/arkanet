defmodule ArkanetWeb.LobbyLive.FormComponent do
  use ArkanetWeb, :live_component

  alias Arkanet.Matchmaking

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage lobby records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="lobby-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Lobby</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{lobby: lobby} = assigns, socket) do
    changeset = Matchmaking.change_lobby(lobby)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"lobby" => lobby_params}, socket) do
    changeset =
      socket.assigns.lobby
      |> Matchmaking.change_lobby(lobby_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"lobby" => lobby_params}, socket) do
    save_lobby(socket, socket.assigns.action, lobby_params)
  end

  defp save_lobby(socket, :edit, lobby_params) do
    case Matchmaking.update_lobby(socket.assigns.lobby, lobby_params) do
      {:ok, lobby} ->
        notify_parent({:saved, lobby})

        {:noreply,
         socket
         |> put_flash(:info, "Lobby updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_lobby(socket, :new, lobby_params) do
    case Matchmaking.create_lobby(lobby_params) do
      {:ok, lobby} ->
        notify_parent({:saved, lobby})

        {:noreply,
         socket
         |> put_flash(:info, "Lobby created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
