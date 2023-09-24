defmodule RedirexWeb.LinkLiveTest do
  use RedirexWeb.ConnCase

  import Phoenix.LiveViewTest
  import Redirex.LinksFixtures

  @create_attrs %{url: "http://tomato.com"}
  @invalid_attrs %{url: "banana"}

  defp create_link(_) do
    link = link_fixture()
    %{link: link}
  end

  describe "Index" do
    @describetag :this
    setup [:create_link]

    test "lists all links", %{conn: conn, link: link} do
      {:ok, _index_live, html} = live(conn, ~p"/stats")

      assert html =~ "Listing Links"
      assert html =~ link.url
    end

    test "saves new link", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "please enter a valid URL"

      assert index_live
             |> form("#link-form", link: @create_attrs)
             |> render_submit()

      html = render(index_live)
      assert html =~ "http://tomato.com"
    end
  end

  describe "Show" do
    setup [:create_link]

    test "displays link", %{conn: conn, link: link} do
      {:ok, _show_live, html} = live(conn, ~p"/links/#{link}")

      assert html =~ link.url
    end
  end
end
