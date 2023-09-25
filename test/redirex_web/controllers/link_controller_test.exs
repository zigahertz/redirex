defmodule RedirexWeb.LinkControllerTest do
  use RedirexWeb.ConnCase
  import Redirex.LinksFixtures

  setup do
    link = link_fixture()
    %{link: link}
  end

  test "redirection", %{conn: conn, link: link} do
    conn = get(conn, ~p"/#{link.hash}")
    assert redirected_to(conn, 302) == link.url
  end

  test "csv download", %{conn: conn, link: link} do
    conn = get(conn, ~p"/download")

    assert response_content_type(conn, :csv) =~ "charset=utf-8"
    assert response(conn, 200) =~ link.hash
  end
end
