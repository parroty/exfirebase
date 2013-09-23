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

defmodule ExFirebase.Dict.Records do
  @moduledoc """
  Provides dict oerations along with record objects.
  """

  @doc """
  Get objects from the specified path as the Record format.
  It returns the list of the records in record_type.
  """
  def get(path, record_type) when is_atom(record_type) do
    verify_record_has_id_field(record_type)

    dict = ExFirebase.Dict.get(path)
    HashDict.keys(dict) |>
      Enum.map(&extract_record(dict, &1)) |>
      ExFirebase.Records.from_tuples(record_type)
  end

  @doc """
  Get object from the specified path as the Record format.
  It returns a records in record_type.
  """
  def get(path, key, record_type) when is_atom(record_type) do
    tuple = [{"id", key} | ExFirebase.Dict.get(path, key)]
    ExFirebase.Records.from_tuple(tuple, record_type)
  end

  @doc """
  Post object to the specified path.
  """
  def post(path, record, record_type) when is_record(record) and is_atom(record_type) do
    ExFirebase.Dict.post(path, record.update(id: nil).to_keywords)
      |> update_record_id(record)
  end

  defp update_record_id({key, _params}, record) do
    record.update(id: key)
  end

  @doc """
  Update the record in the path with the specified record.
  The record needs to have id field
  """
  def patch(path, record) when is_record(record) do
    verify_record_has_id_value(record)
    ExFirebase.Dict.patch(path, record.id, record.update(id: nil).to_keywords)
    record
  end

  @doc """
  delete the record stored in the specified path.
  """
  def delete(path, record) do
    verify_record_has_id_value(record)
    ExFirebase.Dict.delete(path, record.id)
  end

  defp extract_record(dict, key) do
    [{"id", key} | HashDict.fetch!(dict, key)]
  end

  defp verify_record_has_id_value(record) do
    if record.id == nil do
      raise "id field is empty for the specified record."
    end
  end

  defp verify_record_has_id_field(record_type) do
    if record_type.__info__(:functions)[:id] == nil do
      raise "Specified record #{record_type} does not have :id field."
    end
  end
end