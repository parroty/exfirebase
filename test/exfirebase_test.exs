Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebaseTest do
  use ExUnit.Case, async: false
  import Mock

  # TODO : need to veirfy parameters

  setup_all do
    ExFirebase.set_url("https://example-test.firebaseio.com/")
  end

  test_with_mock "get", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(ExFirebase.get("items") == [{"first", "Jack"}, {"last", "Sparrow"}])
  end

  test_with_mock "get with null response return []", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(ExFirebase.get("empty") == [])
  end

  test_with_mock "get with empty path returns data", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(ExFirebase.get == [{"root_key", "root_value"}])
  end

  @auth_token_verify [pre_condition: "/.json", expected_match: "?auth=yyy"]
  test_with_mock "get with auth token", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url, nil, @auth_token_verify) end] do
    ExFirebase.set_auth_token("yyy")
    assert(ExFirebase.get == [{"root_key", "root_value"}])
    ExFirebase.set_auth_token(nil)
  end

  test_with_mock "get raw json", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    assert(ExFirebase.get_raw_json("items") == "{\"last\":\"Sparrow\",\"first\":\"Jack\"}")
  end

  @pretty_option_verify1 [pre_condition: "items.json", expected_match: "?print=pretty"]
  test_with_mock "get raw json with pretty option = true should contain pretty param",
      ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url, nil, @pretty_option_verify1) end] do
    assert(ExFirebase.get_raw_json("items", [pretty: true]) == "{\"last\":\"Sparrow\",\"first\":\"Jack\"}")
  end

  @pretty_option_verify2 [pre_condition: "items.json", expected_match: "?print=pretty&auth=zzz"]
  test_with_mock "get raw json with pretty option and auth params",
      ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url, nil, @pretty_option_verify2) end] do

    ExFirebase.set_auth_token("zzz")
    assert(ExFirebase.get_raw_json("items", [pretty: true]) == "{\"last\":\"Sparrow\",\"first\":\"Jack\"}")
    ExFirebase.set_auth_token(nil)
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

  test_with_mock "push", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end,
                                           put: fn(_url, data) -> assert(data == "[4,1,2,3]") && data end] do
    ExFirebase.push("lists", 4)
  end

  test_with_mock "append", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end,
                                           put: fn(_url, data) -> assert(data == "[1,2,3,4]") && data end] do
    ExFirebase.append("lists", 4)
  end
end
