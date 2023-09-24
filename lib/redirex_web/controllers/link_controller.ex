defmodule RedirexWeb.LinkController do
  use RedirexWeb, :controller
  alias Redirex.{Links, HashCache}

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
    # case get_cached_url(hash) do
    #   nil -> socket
    #   url -> redirect(socket, external: url)
    # end
    with %Links.Link{} = link <- get_link(hash),
         {:ok, _} <- Links.update_link(link, %{visits: link.visits + 1}) do
      redirect(conn, external: Map.get(link, :url))
    else
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

  defp get_cached_url(hash) do
    with false <- HashCache.exists?(hash),
         link <- Links.get_link!(hash),
         url <- Map.get(link, :url),
         :ok <- HashCache.write(hash, url) do
      url
    else
      true ->
        {:ok, url} = HashCache.read(hash)
        url

      nil ->
        :error
    end
  end
end
