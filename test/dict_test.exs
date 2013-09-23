Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebase.DictTest do
  use ExUnit.Case
  import Mock
  alias ExFirebase.Dict

  setup_all do
    ExFirebase.set_url("https://example-test.firebaseio.com/")
  end

  @dict1 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])
  @dict2 HashDict.put(@dict1, "-J29pC-tzADFDVUIdS-p", [{"c","3"}, {"d", "4"}])
  @dict3 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])

  test_with_mock "get single posted object", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(Dict.get("objects") == @dict1)
  end

  test_with_mock "get multiple posted objects", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(Dict.get("objects2") == @dict2)
  end

  test_with_mock "post object", ExFirebase.HTTP, [post: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    assert(Dict.post("objects_post", [{"a","1"}, {"b", "2"}]) == {"-J29m_688gi0nqXtK5sr", [{"a", "1"}, {"b", "2"}]})
  end

  test_with_mock "update posted object", ExFirebase.HTTP, [patch: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    assert(Dict.patch("objects", "-J30m_688gi0nqXtK5sr", [{"c","3"}, {"d", "4"}]) == {"-J30m_688gi0nqXtK5sr", [{"c","3"}, {"d", "4"}]})
  end

  test_with_mock "delete posted object", ExFirebase.HTTP, [delete: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(Dict.delete("objects", "-J31m_688gi0nqXtK5sr") == [])
  end

end

defmodule ExFirebase.Dict.RecordsTest do
  use ExUnit.Case
  import Mock
  alias ExFirebase.Dict

  @dict1 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])
  @dict2 HashDict.put(@dict1, "-J29pC-tzADFDVUIdS-p", [{"c","3"}, {"d", "4"}])
  @dict3 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])

  defrecord NoIdDummy, a: nil, b: nil, c: nil, d: nil
  defrecord Dummy, id: nil, a: nil, b: nil, c: nil, d: nil

  setup_all do
    ExFirebase.set_url("https://example-test.firebaseio.com/")
  end

  test_with_mock "get records", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(Dict.Records.get("objects", Dummy) == [Dummy.new(id: "-J29m_688gi0nqXtK5sr", a: "1", b: "2")])
  end

  test_with_mock "get a record", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(Dict.Records.get("objects", "-J29m_688gi0nqXtK5sr", Dummy) ==
      Dummy.new(id: "-J29m_688gi0nqXtK5sr", a: "1", b: "2")
    )
  end

  test_with_mock "post a record", ExFirebase.HTTP, [post: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    assert(Dict.Records.post("objects_post", Dummy.new(a: "1", b: "2")) ==
             Dummy.new(id: "-J29m_688gi0nqXtK5sr", a: "1", b: "2"))
  end

  test_with_mock "update a record", ExFirebase.HTTP, [patch: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    rec = Dummy.new(id: "-J30m_688gi0nqXtK5sr", c: "3", d: "4")
    assert(Dict.Records.patch("objects", rec) == rec)
  end

  test_with_mock "delete a record", ExFirebase.HTTP, [delete: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(Dict.Records.delete("objects", Dummy.new(id: "-J31m_688gi0nqXtK5sr", c: "3", d: "4")) == [])
  end

  test_with_mock "get records dict without id field throws error", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert_raise RuntimeError, fn ->
      Dict.Records.get("objects", NoIdDummy)
    end
  end

  test_with_mock "updating a record with nil id throws error", ExFirebase.HTTP, [patch: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    assert_raise RuntimeError, fn ->
      Dict.Records.patch("objects", Dummy.new(id: nil, c: "3", d: "4"))
    end
  end
end
