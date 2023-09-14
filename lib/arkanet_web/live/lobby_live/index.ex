defmodule ArkanetWeb.LobbyLive.Index do
  use ArkanetWeb, :live_view

  alias Arkanet.Matchmaking
  alias Arkanet.Matchmaking.Lobby

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :lobbies, Matchmaking.list_lobbies())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Lobby")
    |> assign(:lobby, Matchmaking.get_lobby!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Lobby")
    |> assign(:lobby, %Lobby{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lobbies")
    |> assign(:lobby, nil)
  end

  @impl true
  def handle_info(
        {ArkanetWeb.LobbyLive.FormComponent, {:saved, lobby}},
        %{assigns: %{current_user: %{id: host_id}}} = socket
      ) do
    Cachex.put(:lobby_hosts, "lobby:#{lobby.id}", host_id)

    {:noreply,
     socket
     |> stream_insert(:lobbies, lobby)
    #  |> push_navigate(
    #    to: ArkanetWeb.Router.Helpers.lobbies_lobby_lobby_show_path(socket, :show, lobby.id), replace: true
    #  )
    }
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    lobby = Matchmaking.get_lobby!(id)
    {:ok, _} = Matchmaking.delete_lobby(lobby)

    {:noreply, stream_delete(socket, :lobbies, lobby)}
  end
end
