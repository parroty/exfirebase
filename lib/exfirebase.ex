defmodule ExFirebase do
  @moduledoc """
  Provides interfaces for Firebase API calls.
  Also, the following modules provides object-based operation interface.

    - ExFirebase.Records : Helper for Elixir's record-based operations
    - ExFirebase.Objects : Helper for getting/posting objects
  """
  alias ExFirebase.HTTP

  @doc """
  Setup base url for Firebase (https://xxx.firebaseio.com/).
  """
  def set_url(url) do
    ExFirebase.Setting.set_url(url)
    :ok
  end

  @doc """
  Get json url for the specified path concatinated with the
  prespecified base url.
  """
  def get_url(path, options \\ nil) do
    generate_url(ExFirebase.Setting.get_url(path), get_auth_token, options)
  end

  @doc """
  Setup auth token for accesing the API.
  """
  def set_auth_token(token) do
    ExFirebase.Setting.set_auth_token(token)
  end

  @doc """
  Returns auth token previously specified with 'set_auth_token'
  """
  def get_auth_token do
    ExFirebase.Setting.get_auth_token
  end

  @doc """
  Get objects on the specified path.
  """
  def get do
    ExFirebase.get("")
  end

  def get(path) do
    send_request(path, &HTTP.get/1)
  end

  @doc """
  Put specified object.
  It replaces the data on the specified path.
  """
  def put(path, object) do
    send_request(path, &HTTP.put/2, object)
  end

  @doc """
  Push the object into the first position of the items
  """
  def push(path, object) do
    items = ExFirebase.get(path)
    ExFirebase.put(path, [object|items])
  end

  @doc """
  Append the object into the last position of the items
  """
  def append(path, object) do
    items = ExFirebase.get(path)
    ExFirebase.put(path, items ++ [object])
  end

  @doc """
  Post specified object.
  It appends the data to the specified path.
  """
  def post(path, object) do
    send_request(path, &HTTP.post/2, object)
  end

  @doc """
  Update data on the specified path with the specified object.
  """
  def patch(path, object) do
    send_request(path, &HTTP.patch/2, object)
  end

  @doc """
  Delete objects on the specified path.
  """
  def delete(path) do
    send_request(path, &HTTP.delete/1)
  end

  @doc """
  Get objects on the specified path in raw json format.
  Options can be used to provide additional parameter for requqest.

    - options[pretty: true] : Specify 'print=pretty' for human readable format.
  """
  def get_raw_json(path \\ "", options \\ nil) do
    HTTP.get(get_url(path, options))
  end

  @doc """
  Send the request to server and returns response in tuple/list format
  """
  def send_request(path, method) do
    method.(get_url(path)) |> parse_json
  end

  @doc """
  Send the request to server and returns response in tuple/list format
  """
  def send_request(path, method, data) do
    method.(get_url(path), JSEX.encode!(data)) |> parse_json
  end

  defp generate_url(url, token, options) do
    params =
      (parse_option_param(options) ++ parse_token_param(token))
        |> Enum.join("&")

    if params == "" do
      url
    else
      url <> "?" <> params
    end
  end

  defp parse_token_param(nil), do: []
  defp parse_token_param(token) do
    ["auth=#{token}"]
  end

  defp parse_option_param(nil), do: []
  defp parse_option_param(options) do
    if options[:pretty] == true do
      ["print=pretty"]
    else
      []
    end
  end

  defp parse_json("null"), do: []

  defp parse_json(string) do
    JSEX.decode!(string) |> parse_object
  end

  defp parse_object(object) when is_record(object, HashDict) do
    Enum.map(object.to_list, &parse_object/1)
  end

  defp parse_object(object) when is_tuple(object) do
    Enum.map(tuple_to_list(object), &parse_object/1) |> list_to_tuple
  end

  defp parse_object(object) when is_list(object) do
    Enum.map(object, &parse_object/1)
  end

  defp parse_object(object) do
    object
  end
end
