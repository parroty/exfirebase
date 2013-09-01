Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebase.SettingTest do
  use ExUnit.Case, async: false

  test "get_url raise exception if set_url has not been used" do
    ExFirebase.Setting.set_url(nil)
    assert_raise ExFirebaseError, fn ->
      assert(ExFirebase.Setting.get_url("item") == "https://example-test.firebaseio.com/item.json")
    end
  end

  test "get_url returns the value of set_url" do
    ExFirebase.Setting.set_url("https://example-test.firebaseio.com/")
    assert(ExFirebase.Setting.get_url("item") == "https://example-test.firebaseio.com/item.json")
  end

  test "get_auth_token returns the value of set_auth_token" do
    ExFirebase.Setting.set_auth_token("TestToken")
    assert(ExFirebase.Setting.get_auth_token == "TestToken")
  end

  test "Changin URL and Token should not be affected each other" do
    ExFirebase.Setting.set_url("a")
    ExFirebase.Setting.set_auth_token("b")

    assert(ExFirebase.Setting.get_url("")    == "a.json")
    assert(ExFirebase.Setting.get_auth_token == "b")
  end

end
