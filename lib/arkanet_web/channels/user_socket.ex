defmodule ArkanetWeb.UserSocket do
  use Phoenix.Socket

  channel "arkana:*", ArkanetWeb.ArkanaChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
      {:ok, user_id} ->
        {:ok,
         socket
         |> assign(:current_user, Arkanet.Repo.get!(Arkanet.Accounts.User, user_id))}

      {:error, _} ->
        :error
    end
  end

  @impl true
  def id(_socket), do: nil
end
