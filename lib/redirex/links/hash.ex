defmodule Redirex.Links.Hash do
  use Ecto.Type

  @hash_length 7

  def type, do: :string

  def cast(v) when is_binary(v), do: {:ok, v}
  def cast(_), do: :error

  def dump(v) when is_binary(v), do: {:ok, v}
  def dump(_), do: :error

  def load(v) when is_binary(v), do: {:ok, v}
  def load(_), do: :error

  def autogenerate, do: generate()

  defp generate() do
    @hash_length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
    |> binary_part(0, @hash_length)
  end
end
