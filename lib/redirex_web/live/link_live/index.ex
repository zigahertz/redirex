defmodule RedirexWeb.LinkLive.Index do
  use RedirexWeb, :live_view

  alias Redirex.{Links,HashCache}
  alias Links.Link

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> attach_hook(:count, :handle_params, fn
        %{"hash" => hash}, _, socket ->
          link = Links.get_link!(hash)
          Links.update_link(link, %{count: 2})
          {:cont, socket}

        # _event, _params, socket ->
        #   {:cont, socket}
      end)
      |> stream_configure(:links, dom_id: &(&1.hash))
      |> stream(:links, Links.list_links())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.inspect(socket.assigns.live_action, label: :socket)
    IO.inspect(params, label: :params)
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :redirect, %{"hash" => hash}) do
    # redirect(socket, external: Map.get(Links.get_link!(hash), :url) )
    case get_cached_url(hash) do
      nil -> socket
      url -> redirect(socket, external: url)
    end
  end

  defp apply_action(socket, :edit, %{"hash" => hash}) do
    socket
    |> assign(:page_title, "Edit Link")
    |> assign(:link, Links.get_link!(hash))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Link")
    |> assign(:link, %Link{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Links")
    |> assign(:link, nil)
  end

  @impl true
  def handle_info({RedirexWeb.LinkLive.FormComponent, {:saved, link}}, socket) do
    {:noreply, stream_insert(socket, :links, link)}
  end

  @impl true
  def handle_event("delete", %{"hash" => hash}, socket) do
    link = Links.get_link!(hash)
    {:ok, _} = Links.delete_link(link)

    {:noreply, stream_delete(socket, :links, link)}
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
      nil -> :error
    end
    # Links.update_link(link, %{count: Map.get(link, :count) + 1})
  end

  def gen_url(%{hash: hash}), do: URI.parse(RedirexWeb.Endpoint.url <> "/" <> hash)
end
