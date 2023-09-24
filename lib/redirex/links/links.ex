defmodule Redirex.Links do

  import Ecto.Query, warn: false
  alias Redirex.Repo
  alias Redirex.Links.Link

  def list_links do
    Repo.all(Link)
  end

  def get_link!(hash), do: Repo.get!(Link, hash)

  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  def shortened_link(%Link{} = %{hash: hash}) do
    URI.parse(RedirexWeb.Endpoint.url <> "/" <> hash)
  end

  def shortened_link(%{hash: hash}) do
    RedirexWeb.Endpoint.url <> "/" <> hash
  end
end
