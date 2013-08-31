Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebaseTest do
  use ExUnit.Case, async: false
  import Mock

  # TODO : need to veirfy parameters

  setup_all do
    ExFirebase.set_url("https://example-test.firebaseio.com/")
  end

  test_with_mock "get", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(ExFirebase.get("items") == [{"last", "Sparrow"}, {"first", "Jack"}])
  end

  test_with_mock "get with null response return []", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(ExFirebase.get("empty") == [])
  end

  test_with_mock "get with empty path returns data", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(ExFirebase.get == [{"root_key", "root_value"}])
  end

  test_with_mock "get with raw option", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(ExFirebase.get_raw_json("items") == "{\"last\":\"Sparrow\",\"first\":\"Jack\"}")
  end

  test_with_mock "put", ExFirebase.HTTP, [put: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    assert(ExFirebase.put("items_push", "abc") == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
  end

  test_with_mock "post", ExFirebase.HTTP, [post: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    assert(ExFirebase.post("items_push", "abc") == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
  end

  test_with_mock "patch", ExFirebase.HTTP, [patch: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    assert(ExFirebase.patch("items_push", "abc") == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
  end

  test_with_mock "delete", ExFirebase.HTTP, [delete: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(ExFirebase.delete("items_push") == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
  end
end
