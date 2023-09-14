defmodule ArkanetWeb.LobbyLiveTest do
  use ArkanetWeb.ConnCase

  import Phoenix.LiveViewTest
  import Arkanet.MatchmakingFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_lobby(_) do
    lobby = lobby_fixture()
    %{lobby: lobby}
  end

  describe "Index" do
    setup [:create_lobby]

    test "lists all lobbies", %{conn: conn, lobby: lobby} do
      {:ok, _index_live, html} = live(conn, ~p"/lobbies")

      assert html =~ "Listing Lobbies"
      assert html =~ lobby.name
    end

    test "saves new lobby", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/lobbies")

      assert index_live |> element("a", "New Lobby") |> render_click() =~
               "New Lobby"

      assert_patch(index_live, ~p"/lobbies/new")

      assert index_live
             |> form("#lobby-form", lobby: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#lobby-form", lobby: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/lobbies")

      html = render(index_live)
      assert html =~ "Lobby created successfully"
      assert html =~ "some name"
    end

    test "updates lobby in listing", %{conn: conn, lobby: lobby} do
      {:ok, index_live, _html} = live(conn, ~p"/lobbies")

      assert index_live |> element("#lobbies-#{lobby.id} a", "Edit") |> render_click() =~
               "Edit Lobby"

      assert_patch(index_live, ~p"/lobbies/#{lobby}/edit")

      assert index_live
             |> form("#lobby-form", lobby: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#lobby-form", lobby: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/lobbies")

      html = render(index_live)
      assert html =~ "Lobby updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes lobby in listing", %{conn: conn, lobby: lobby} do
      {:ok, index_live, _html} = live(conn, ~p"/lobbies")

      assert index_live |> element("#lobbies-#{lobby.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#lobbies-#{lobby.id}")
    end
  end

  describe "Show" do
    setup [:create_lobby]

    test "displays lobby", %{conn: conn, lobby: lobby} do
      {:ok, _show_live, html} = live(conn, ~p"/lobbies/#{lobby}")

      assert html =~ "Show Lobby"
      assert html =~ lobby.name
    end

    test "updates lobby within modal", %{conn: conn, lobby: lobby} do
      {:ok, show_live, _html} = live(conn, ~p"/lobbies/#{lobby}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Lobby"

      assert_patch(show_live, ~p"/lobbies/#{lobby}/show/edit")

      assert show_live
             |> form("#lobby-form", lobby: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#lobby-form", lobby: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/lobbies/#{lobby}")

      html = render(show_live)
      assert html =~ "Lobby updated successfully"
      assert html =~ "some updated name"
    end
  end
end
