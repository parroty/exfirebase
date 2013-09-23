defmodule ExFirebase.Objects do
  @moduledoc """
  Provides object-posting operations for Firebase post API.
  Firebase's post API assigns random name attribute for its key.
  This module wraps the key and data in a record and provides the operations for them.
  """

  @doc """
  Get objects from the specified path. It returns ExFirebase.Object record
  """
  def get(path) do
    list = ExFirebase.get(path)
    Enum.reduce(list, HashDict.new, fn(x, d) -> parse(x, d) end)
  end

  @doc """
  Get objects from the specified path and key. It returns ExFirebase.Object record
  """
  def get(path, key) do
    ExFirebase.get("#{path}/#{key}")
  end

  @doc """
  Post data to the specified path.
  """
  def post(path, data) do
    ExFirebase.post(path, data)
      |> Enum.first
      |> parse(data)
  end

  @doc """
  Update the record in the path with the specified data.
  data parameter needs to be in list format.
  """
  def patch(path, key, data) do
    ExFirebase.patch("#{path}/#{key}", data)
    {key, data}
  end

  @doc """
  delete the record stored in the specified path.
  """
  def delete(path, key) do
    ExFirebase.delete("#{path}/#{key}")
  end

  defp parse({"name", name}, data) do
    {name, data}
  end

  defp parse({name, data}, dict) do
    HashDict.put(dict, name, data)
  end
end
