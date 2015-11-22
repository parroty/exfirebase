defmodule ExFirebase.Dict do
  @moduledoc """
  Provides object-posting operations for Firebase post API.
  Firebase's post API assigns random name attribute for its key.
  This module wraps the key and data in a record and provides the operations for them.
  """

  @doc """
  Get objects from the specified path.
  """
  def get(path) do
    list = ExFirebase.get(path)
    Enum.reduce(list, HashDict.new, fn(x, d) -> parse(x, d) end)
  end

  @doc """
  Get objects from the specified path and key.
  """
  def get(path, key) do
    ExFirebase.get("#{path}/#{key}")
  end

  @doc """
  Post data to the specified path.
  """
  def post(path, data) do
    ExFirebase.post(path, data)
    |> Enum.at(0)
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

defmodule ExFirebase.Dict.Records do
  @moduledoc """
  Provides dict oerations along with record objects.
  """
  defmacro __using__(_opts \\ []) do
    quote do
      import ExFirebase.Records
      import ExFirebase.Dict.Records
    end
  end

  @doc """
  Get objects from the specified path as the Record format.
  It returns the list of the records in record_type.
  """
  defmacro get(path, record_type) do
    quote do
      verify_record_has_id_field(unquote(record_type))

      dict = ExFirebase.Dict.get(unquote(path))
      HashDict.keys(dict)
      |> Enum.map(&extract_record(dict, &1))
      |> ExFirebase.Records.from_tuples(unquote(record_type))
    end
  end

  @doc """
  Get object from the specified path as the Record format.
  It returns a records in record_type.
  """
  defmacro get(path, key, record_type) do
    quote do
      verify_record_has_id_field(unquote(record_type))

      map = ExFirebase.Dict.get(unquote(path), unquote(key))
      if map == [] do
        raise %ExFirebaseError{message: "Specified key [#{unquote(key)}] was not found."}
      else
        tuple = Map.put(map, "id", unquote(key))
        ExFirebase.Records.from_tuple(tuple, unquote(record_type))
      end
    end
  end

  @doc """
  Post object to the specified path.
  """
  def post(path, record) do
    ExFirebase.Dict.post(path, Map.to_list(%{record | id: nil}))
    |> update_record_id(record)
  end

  defp update_record_id({key, _params}, record) do
    %{record | id: key}
  end

  @doc """
  Update the record in the path with the specified record.
  The record needs to have id field
  """
  def patch(path, record) do
    verify_record_has_id_value(record)
    ExFirebase.Dict.patch(path, record.id, Map.to_list(%{record | id: nil}))
    record
  end

  @doc """
  delete the record stored in the specified path.
  """
  def delete(path, record) do
    verify_record_has_id_value(record)
    ExFirebase.Dict.delete(path, record.id)
  end

  def extract_record(dict, key) do
    Map.put(HashDict.fetch!(dict, key), "id", key)
  end

  def verify_record_has_id_value(record) do
    if record.id == nil do
      raise "id field is empty for the specified record."
    end
  end

  def verify_record_has_id_field(record_type) do
    unless Map.has_key?(record_type.__struct__, :id) do
      raise "Specified record #{record_type} does not have :id field."
    end
  end
end