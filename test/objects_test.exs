Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebase.ObjectsTest do
  use ExUnit.Case
  import Mock
  alias ExFirebase.Objects
  alias ExFirebase.Object

  @dict1 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])
  @dict2 HashDict.put(@dict1, "-J29pC-tzADFDVUIdS-p", [{"c","3"}, {"d", "4"}])
  @dict3 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])

  test_with_mock "get single posted object", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(Objects.get("objects") == @dict1)
  end

  test_with_mock "get multiple posted objects", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(Objects.get("objects2") == @dict2)
  end

  test_with_mock "post object", ExFirebase.HTTP, [post: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    assert(Objects.post("objects_post", [{"a","1"}, {"b", "2"}]) == {"-J29m_688gi0nqXtK5sr", [{"a", "1"}, {"b", "2"}]})
  end

  test_with_mock "update posted object", ExFirebase.HTTP, [patch: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    assert(Objects.patch("objects", "-J30m_688gi0nqXtK5sr", [{"c","3"}, {"d", "4"}]) == {"-J30m_688gi0nqXtK5sr", [{"c","3"}, {"d", "4"}]})
  end

  test_with_mock "delete posted object", ExFirebase.HTTP, [delete: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(Objects.delete("objects", "-J31m_688gi0nqXtK5sr") == [])
  end

end
