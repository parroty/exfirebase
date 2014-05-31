Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebase.HTTPTest do
  use ExUnit.Case, async: false
  import Mock

  defmodule Dummy do
    defstruct body: "body"
  end

  test_with_mock "get", HTTPotion, [get: fn(_) -> %Dummy{} end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.get("url") == "body")
  end

  test_with_mock "post", HTTPotion, [post: fn(_,_) -> %Dummy{} end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.post("url", "data") == "body")
  end

  test_with_mock "put", HTTPotion, [put: fn(_,_) -> %Dummy{} end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.put("url", "data") == "body")
  end

  test_with_mock "patch", HTTPotion, [patch: fn(_,_) -> %Dummy{} end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.patch("url", "data") == "body")
  end

  test_with_mock "delete", HTTPotion, [delete: fn(_) -> %Dummy{} end, start: fn -> nil end] do
    assert(ExFirebase.HTTP.delete("url") == "body")
  end
end
