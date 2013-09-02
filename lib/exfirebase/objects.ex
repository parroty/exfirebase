defmodule ExFirebase.Objects do
  @moduledoc """
  Provides object-posting operations for Firebase post API.
  Firebase's post API assigns random name attribute for its key.
  This module wraps the key and data in a record and provides the operations for them.
  """

  @doc """
  Get objects from the specified path and returns ExFirebase.Object record
  """
  def get(path) do
    list = ExFirebase.get(path)
    Enum.map(list, fn(x) -> parse(x) end)
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
  def patch(path, record, data) do
    ExFirebase.patch("#{path}/#{record.name}", data)
      |> Enum.first
      |> parse
  end

  @doc """
  delete the record stored in the specified path.
  """
  def delete(path, record) do
    ExFirebase.delete("#{path}/#{record.name}")
  end

  defp parse({"name", name}, data) do
    ExFirebase.Object.new(name: name, data: data)
  end

  defp parse({name, data}) do
    ExFirebase.Object.new(name: name, data: data)
  end
end
