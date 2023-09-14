defmodule Arkanet.MatchmakingTest do
  use Arkanet.DataCase

  alias Arkanet.Matchmaking

  describe "lobbies" do
    alias Arkanet.Matchmaking.Lobby

    import Arkanet.MatchmakingFixtures

    @invalid_attrs %{name: nil}

    test "list_lobbies/0 returns all lobbies" do
      lobby = lobby_fixture()
      assert Matchmaking.list_lobbies() == [lobby]
    end

    test "get_lobby!/1 returns the lobby with given id" do
      lobby = lobby_fixture()
      assert Matchmaking.get_lobby!(lobby.id) == lobby
    end

    test "create_lobby/1 with valid data creates a lobby" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Lobby{} = lobby} = Matchmaking.create_lobby(valid_attrs)
      assert lobby.name == "some name"
    end

    test "create_lobby/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matchmaking.create_lobby(@invalid_attrs)
    end

    test "update_lobby/2 with valid data updates the lobby" do
      lobby = lobby_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Lobby{} = lobby} = Matchmaking.update_lobby(lobby, update_attrs)
      assert lobby.name == "some updated name"
    end

    test "update_lobby/2 with invalid data returns error changeset" do
      lobby = lobby_fixture()
      assert {:error, %Ecto.Changeset{}} = Matchmaking.update_lobby(lobby, @invalid_attrs)
      assert lobby == Matchmaking.get_lobby!(lobby.id)
    end

    test "delete_lobby/1 deletes the lobby" do
      lobby = lobby_fixture()
      assert {:ok, %Lobby{}} = Matchmaking.delete_lobby(lobby)
      assert_raise Ecto.NoResultsError, fn -> Matchmaking.get_lobby!(lobby.id) end
    end

    test "change_lobby/1 returns a lobby changeset" do
      lobby = lobby_fixture()
      assert %Ecto.Changeset{} = Matchmaking.change_lobby(lobby)
    end
  end
end
