defmodule Arkanet.MatchmakingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Arkanet.Matchmaking` context.
  """

  @doc """
  Generate a unique lobby name.
  """
  def unique_lobby_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a lobby.
  """
  def lobby_fixture(attrs \\ %{}) do
    {:ok, lobby} =
      attrs
      |> Enum.into(%{
        name: unique_lobby_name()
      })
      |> Arkanet.Matchmaking.create_lobby()

    lobby
  end
end
