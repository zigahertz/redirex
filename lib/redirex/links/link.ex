defmodule Redirex.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Redirex.Links.Hash

  @url_regex ~r/^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/

  @primary_key {:hash, Hash, [autogenerate: true]}
  @derive {Phoenix.Param, key: :hash}
  schema "links" do
    field :url, :string
    field :visits, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :visits])
    |> validate_required([:url])
    |> unique_constraint(:url, name: :links_url_index, message: "this URL has already been saved")
    |> validate_format(:url, @url_regex, message: "please enter a valid URL")
  end
end
