defmodule Redirex.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Redirex.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        hash: "some hash",
        url: "some url",
        visits: 42
      })
      |> Redirex.Links.create_link()

    link
  end
end
