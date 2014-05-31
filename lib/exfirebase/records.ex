defmodule ExFirebase.Records do
  @moduledoc """
  Provides Elixir's record-based operation for Firebase
  """
  alias ExFirebase.HTTP

  @doc """
  Get records from the specified path. The record_type indicates the record type.
  """
  defmacro get(path \\ "", record_type) do
    quote do
      record_tuples = ExFirebase.send_request(unquote(path), &HTTP.get/1)
      from_tuples(record_tuples, unquote(record_type))
    end
  end

  @doc """
  Put records to the specified path.
  """
  def put(record_list) do
    ExFirebase.Records.put("", record_list)
  end

  def put(path, record_list) do
    tuples = to_tuples(record_list)
    ExFirebase.send_request(path, &HTTP.put/2, tuples)
  end

  @doc "convert from tuple list to record list"
  defmacro from_tuples(tuples, record_type) do
    quote do
      Enum.map(unquote(tuples), fn(tuple) -> from_tuple(tuple, unquote(record_type)) end)
    end
  end

  @doc "convert from record list to tuple list"
  def to_tuples(record_list) do
    Enum.map(record_list, fn(record) ->
      Map.to_list(record) |> Enum.filter(fn({key,_val}) -> key != :__struct__ end)
    end)
  end

  @doc "convert from tuple to record"
  defmacro from_tuple(tuple, record_type) do
    quote do
      keywords = Enum.map(unquote(tuple), fn({a, b}) -> {binary_to_atom(a), b} end)
      #record_type.new(keywords)
      Enum.reduce(keywords, %unquote(record_type){}, fn({k,v}, acc) -> Map.put(acc, k, v) end)
    end
  end
end