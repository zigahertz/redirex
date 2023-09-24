defmodule Redirex.HashCache do
  use GenServer

  @name :hash_cash

  ## Client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def write(key, val) do
    GenServer.cast(@name, {:write, key, val})
  end

  def exists?(key) do
    GenServer.call(@name, {:exists?, key})
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def delete(key) do
    GenServer.cast(@name, {:delete, key})
  end

  def clear() do
    GenServer.cast(@name, {:clear_all})
  end

  ## Server API

  def init(:ok), do: {:ok, %{}}

  def handle_call({:read, key}, _from, cache) do
    {:reply, Map.fetch(cache, key), cache}
  end

  def handle_call({:exists?, key}, _from, cache) do
    {:reply, Map.has_key?(cache, key), cache}
  end

  def handle_cast({:delete, key}, cache) do
    {:noreply, Map.delete(cache, key)}
  end

  def handle_cast({:write, key, val}, cache) do
    {:noreply, Map.put(cache, key, val)}
  end

  def handle_cast({:clear_all}, _cache) do
    {:noreply, %{}}
  end
end
