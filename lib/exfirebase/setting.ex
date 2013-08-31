defmodule ExFirebase.Setting do
  @moduledoc """
  An module to store the base-url setting for Firebase connection.
  Set method needs to be called in advance for API call.
  """

  use ExActor, export: :singleton   # The actor process will be locally registered

  defcall get, state: state, do: state
  defcast set(x), do: new_state(x)

  def set_url(url) do
    start
    set(url)
  end

  def get_url(path) do
    start
    if get == nil, do: raise ExFirebaseError.new(message: "call 'set_url' before using 'get_url'")

    get() <> path <> ".json"
  end
end
