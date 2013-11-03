defmodule ExFirebase.Setting do
  @moduledoc """
  An module to store the base-url setting for Firebase connection.
  Set method needs to be called in advance for API call.
  """
  @ets_table :exfirebase_setting

  def setup do
    if :ets.info(@ets_table) == :undefined do
      :ets.new(@ets_table, [:set, :public, :named_table])
    end
  end

  def get(key) do
    setup
    :ets.lookup(@ets_table, key)[key]
  end

  def set(key, value) do
    setup
    :ets.insert(@ets_table, {key, value})
  end

  def set_url(url) do
    set(:url, url)
  end

  def get_url(path) do
    url = get(:url)
    if url == nil, do: raise ExFirebaseError.new(message: "call 'set_url' before using 'get_url'")
    url <> path <> ".json"
  end

  def set_auth_token(token) do
    set(:token, token)
  end

  def get_auth_token do
    get(:token)
  end
end
