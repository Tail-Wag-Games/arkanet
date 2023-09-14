defmodule ArkanetWeb.LobbyLive.Show do
  use ArkanetWeb, :live_view

  alias Arkanet.Matchmaking
  alias ArkanetWeb.Presence

  @impl true
  @spec mount(any, any, %{
          :assigns => %{
            :current_user => %{:id => any, optional(any) => any},
            optional(any) => any
          },
          optional(any) => any
        }) :: {:ok, map}
  def mount(_params, _session, %{assigns: %{current_user: %{id: current_user_id}}} = socket) do
    {:ok,
     socket
     |> assign(:connected_users, [])
     |> assign(:offer_requests, [])
     |> assign(:ice_candidate_offers, [])
     |> assign(:sdp_offers, [])
     |> assign(:answers, [])}
  end

  @impl true
  def handle_params(
        %{"id" => id},
        _,
        %{
          root_pid: root_pid,
          assigns: %{live_action: :show, current_user: %{id: current_user_id} = current_user}
        } = socket
      ) do
    lobby = Matchmaking.get_lobby!(id)
    {:ok, host_id} = Cachex.get(:lobby_hosts, "lobby:#{id}")

    ArkanetWeb.Endpoint.subscribe("lobby:#{id}")
    ArkanetWeb.Endpoint.subscribe("lobby:#{id}:#{current_user_id}")

    maybe_track_user(lobby, socket)

    {:noreply,
     socket
     |> assign(:host, host_id == current_user_id)
     |> assign(:host_id, host_id)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:lobby, lobby)}
  end

  @impl true
  def handle_event("start_game", _params, socket) do
    for user <- socket.assigns.connected_users do
      if user != socket.assigns.host_id do
        send_direct_message(
          socket.assigns.lobby.id,
          user,
          "game_started",
          nil
        )
      end
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("new_ice_candidate", payload, socket) do
    payload = Map.merge(payload, %{"from_user" => socket.assigns.current_user.id})

    send_direct_message(socket.assigns.lobby.id, payload["toUser"], "new_ice_candidate", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_event("new_sdp_offer", payload, socket) do
    payload = Map.merge(payload, %{"from_user" => socket.assigns.current_user.id})

    send_direct_message(socket.assigns.lobby.id, socket.assigns.host_id, "new_sdp_offer", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_event("new_answer", payload, socket) do
    payload = Map.merge(payload, %{"from_user" => socket.assigns.current_user.id})

    send_direct_message(socket.assigns.lobby.id, payload["toUser"], "new_answer", payload)
    {:noreply, socket}
  end

  @impl true
  @doc """
  When an offer request has been received, add it to the `@offer_requests` list.
  """
  def handle_info(%{event: "game_started", payload: nil}, socket) do
    {:noreply, push_event(socket, "game-started", %{})}
  end

  @impl true
  def handle_info(
        %{
          topic: "lobby:" <> lobby_id = topic,
          event: "presence_diff"
        },
        %{assigns: %{lobby: %{id: lobby_id}}} = socket
      ) do
    {:noreply,
     socket
     |> assign(:connected_users, Enum.map(Presence.list(topic), fn {user_id, _} -> user_id end))}
  end

  @impl true
  def handle_info(%{event: "new_ice_candidate", payload: payload}, socket) do
    {:noreply,
      socket
      |> assign(:ice_candidate_offers, socket.assigns.ice_candidate_offers ++ [payload])
    }
  end

  @impl true
  def handle_info(%{event: "new_sdp_offer", payload: payload}, socket) do
    {:noreply,
      socket
      |> assign(:sdp_offers, socket.assigns.sdp_offers ++ [payload])
    }
  end

  @impl true
  def handle_info(%{event: "new_answer", payload: payload}, socket) do
    {:noreply,
      socket
      |> assign(:answers, socket.assigns.answers ++ [payload])
    }
  end

  defp maybe_track_user(
         lobby,
         %{assigns: %{live_action: :show, current_user: current_user}} = socket
       ) do
    if connected?(socket) do
      Presence.track_user(self(), lobby, current_user)
    end
  end

  defp maybe_track_user(_lobby, _socket), do: nil

  defp send_direct_message(lobby_id, user_id, event, payload) do
    ArkanetWeb.Endpoint.broadcast_from(
      self(),
      "lobby:#{lobby_id}:#{user_id}",
      event,
      payload
    )
  end

  defp page_title(:show), do: "Show Lobby"
  defp page_title(:edit), do: "Edit Lobby"
end
