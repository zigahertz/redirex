defmodule RedirexWeb.LinkLive.Index do
  use RedirexWeb, :live_view

  alias Redirex.Links
  alias Redirex.Links.Link

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream_configure(:links, dom_id: &(&1.hash))
      |> stream(:links, Links.list_links())
    }
      # stream(socket, :links, Links.list_links())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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
end
