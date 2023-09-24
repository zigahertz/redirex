defmodule RedirexWeb.ErrorHTMLTest do
  use RedirexWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(RedirexWeb.ErrorHTML, "404", "html", []) =~ "Invalid Link"
  end

  test "renders 500.html" do
    assert render_to_string(RedirexWeb.ErrorHTML, "500", "html", []) =~ "Server Error"
  end
end
