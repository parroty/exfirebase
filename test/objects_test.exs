Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebase.ObjectsTest do
  use ExUnit.Case
  import Mock
  alias ExFirebase.Objects
  alias ExFirebase.Object

  test_with_mock "get single posted object", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    record = Object.new(name: "-J29m_688gi0nqXtK5sr", data: [{"a","1"}, {"b", "2"}])
    assert(Objects.get("objects") == [record])
  end

  test_with_mock "get multiple posted objects", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    record1 = Object.new(name: "-J29m_688gi0nqXtK5sr", data: [{"a","1"}, {"b", "2"}])
    record2 = Object.new(name: "-J29pC-tzADFDVUIdS-p", data: [{"c","3"}, {"d", "4"}])
    assert(Objects.get("objects2") == [record1, record2])
  end

  test_with_mock "post object", ExFirebase.HTTP, [post: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    record = Object.new(name: "-J29m_688gi0nqXtK5sr", data: [{"a","1"}, {"b", "2"}])
    assert(Objects.post("objects", [{"a","1"}, {"b", "2"}]) == record)
  end

  test_with_mock "update posted object", ExFirebase.HTTP, [patch: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    record = Object.new(name: "-J30m_688gi0nqXtK5sr", data: [{"a","1"}, {"b", "2"}])
    assert(Objects.patch("objects", record, [{"c","3"}, {"d", "4"}]) == Object.new(name: "-J30m_688gi0nqXtK5sr", data: [{"c","3"}, {"d", "4"}]))
  end

  test_with_mock "delete posted object", ExFirebase.HTTP, [delete: fn(url) -> ExFirebase.Mock.request(url) end] do
    record = Object.new(name: "-J31m_688gi0nqXtK5sr", data: [{"a","1"}, {"b", "2"}])
    assert(Objects.delete("objects", record) == [])
  end

end
