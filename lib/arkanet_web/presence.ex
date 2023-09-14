defmodule ArkanetWeb.Presence do
  use Phoenix.Presence,
    otp_app: :arkanet,
    pubsub_server: Arkanet.PubSub

  alias ArkanetWeb.Presence

  def track_user(pid, lobby, user) do
    Presence.track(
      pid,
      "lobby:#{lobby.id}",
      user.id,
      %{email: user.email}
    )
  end
end
