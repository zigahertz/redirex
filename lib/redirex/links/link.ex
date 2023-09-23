defmodule Redirex.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Redirex.Links.Hash

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
    # |> validate_format(:url)
  end

end
