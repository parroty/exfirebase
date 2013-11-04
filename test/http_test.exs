Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebase.HTTPTest do
  use ExUnit.Case, async: false
  import Mock

  defrecord Dummy, body: "body"

  test_with_mock "get", HTTPotion, [get: fn(_) -> Dummy.new end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.get("url") == "body")
  end

  test_with_mock "post", HTTPotion, [post: fn(_,_) -> Dummy.new end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.post("url", "data") == "body")
  end

  test_with_mock "put", HTTPotion, [put: fn(_,_) -> Dummy.new end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.put("url", "data") == "body")
  end

  test_with_mock "patch", HTTPotion, [patch: fn(_,_) -> Dummy.new end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.patch("url", "data") == "body")
  end

  test_with_mock "delete", HTTPotion, [delete: fn(_) -> Dummy.new end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.delete("url") == "body")
  end
end
