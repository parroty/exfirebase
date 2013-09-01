defmodule ExFirebase.Setting do
  @moduledoc """
  An module to store the base-url setting for Firebase connection.
  Set method needs to be called in advance for API call.
  """
  use ExActor, export: :singleton

  definit do: HashDict.new
  defcall get, state: state, do: state
  defcast set(x), do: new_state(x)

  def set_url(url) do
    start
    hash = HashDict.put(get, :url, url)
    set(hash)
  end

  def get_url(path) do
    start
    url = HashDict.get(get, :url)
    if url == nil do
      raise ExFirebaseError.new(message: "call 'set_url' before using 'get_url'")
    end

    url <> path <> ".json"
  end

  def set_auth_token(token) do
    start
    hash = HashDict.put(get, :token, token)
    set(hash)
  end

  def get_auth_token do
    start
    HashDict.get(get, :token)
  end
end
