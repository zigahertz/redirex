defmodule RedirexWeb.LinkLive.Show do
  use RedirexWeb, :live_view

  alias Redirex.Links

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"hash" => hash}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:link, Links.get_link!(hash))}
  end

  defp page_title(:show), do: "Show Link"
  defp page_title(:edit), do: "Edit Link"
end
