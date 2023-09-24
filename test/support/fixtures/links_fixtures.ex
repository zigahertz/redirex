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
      |> Enum.into(%{url: "http://dog.com"})
      |> Redirex.Links.create_link()

    link
  end
end
