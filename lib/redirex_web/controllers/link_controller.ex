defmodule RedirexWeb.LinkController do
  use RedirexWeb, :controller
  alias Redirex.Links

  action_fallback RedirexWeb.FallbackController

  @fields ~w(hash url visits)a

  def csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"links.csv\"")
    |> put_root_layout(false)
    |> send_resp(200, csv_data())
  end

  def index(conn, %{"hash" => hash}) do
    case get_link(hash) do
      %Links.Link{} = link ->
        Links.update_link(link, %{visits: link.visits + 1})
        redirect(conn, external: Map.get(link, :url))
      nil -> {:error, :not_found}
    end
  end

  defp get_link(hash), do: Links.get_link(hash)

  defp csv_data() do
    Links.list_links()
    |> Enum.reduce([], &encode_for_csv/2)
    |> CSV.encode(headers: @fields)
    |> Enum.to_list()
    |> to_string()
  end

  defp encode_for_csv(link, acc) do
    data =
      link
      |> Map.from_struct()
      |> Map.replace(:hash, Links.shortened_link(link))

    [data | acc]
  end
end
