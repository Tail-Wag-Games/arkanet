defmodule ArkanetWeb.ArkanaChannel do
  use ArkanetWeb, :channel
  alias ArkanetWeb.Presence


  def join("arkana:" <> _lobbyId, message, socket) do
    send(self(), {:after_join, message})

    {:ok, assign(socket, :ready, false)}
  end

  @spec handle_info({:after_join, any}, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_info({:after_join, _msg}, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.current_user.id, %{
      online_at: inspect(System.system_time(:second))
    })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  def handle_in("server_ready:" <> _pid = topic, payload, socket) do
    broadcast!(socket, topic, payload)
    {:noreply, socket}
  end

  def handle_in("ready_for_candidates:" <> _pid = topic, payload, socket) do
    broadcast!(socket, topic, payload)
    {:noreply, socket}
  end

  def handle_in("offer", %{"from" => pid} = payload, socket) do
    broadcast!(socket, "offer:#{pid}", payload)
    {:noreply, socket}
  end

  def handle_in("answer:" <> _pid = topic, payload, socket) do
    broadcast!(socket, topic, payload)
    {:noreply, socket}
  end

  def handle_in("candidate" = topic, payload, socket) do
    broadcast_from!(socket, topic, payload)
    {:noreply, socket}
  end
end
