Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebaseTest do
  use ExUnit.Case, async: false
  import ExVCR.Mock

  setup_all do
    ExFirebase.set_url("https://example-test.firebaseio.com/")
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "fixture/custom_cassettes")
    :ok
  end

  test "get_items" do
    use_cassette "get_items", custom: true do
      assert(ExFirebase.get("items") == [{"first", "Jack"}, {"last", "Sparrow"}])
    end
  end

  test "get with null response return []" do
    use_cassette "get_empty", custom: true do
      assert(ExFirebase.get("empty") == [])
    end
  end

  test "get with empty path returns data" do
    use_cassette "get_root", custom: true do
      assert(ExFirebase.get == [{"root_key", "root_value"}])
    end
  end

  test "get with auth token" do
    ExFirebase.set_auth_token("yyy")
    use_cassette "get_root_with_auth", custom: true do
      assert(ExFirebase.get == [{"root_key", "root_value"}])
    end
    ExFirebase.set_auth_token(nil)
  end

  test "get raw json" do
    use_cassette "get_items", custom: true do
      assert(ExFirebase.get_raw_json("items") == "{\"last\":\"Sparrow\",\"first\":\"Jack\"}")
    end
  end

  test "get raw json with pretty option = true should contain pretty param" do
    use_cassette "get_items_pretty", custom: true do
      assert(ExFirebase.get_raw_json("items", [pretty: true]) == "{\"last\":\"Sparrow\",\"first\":\"Jack\"}")
    end
  end

  test "get raw json with pretty option and auth params" do
    ExFirebase.set_auth_token("zzz")
    use_cassette "get_items_pretty_with_auth", custom: true do
      assert(ExFirebase.get_raw_json("items", [pretty: true]) == "{\"last\":\"Sparrow\",\"first\":\"Jack\"}")
    end
    ExFirebase.set_auth_token(nil)
  end

  test "put" do
    use_cassette "get_items_push", custom: true do
      assert(ExFirebase.put("items_push", "abc") == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
    end
  end

  test "post" do
    use_cassette "get_items_push", custom: true do
      assert(ExFirebase.post("items_push", "abc") == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
    end
  end

  test "patch" do
    use_cassette "get_items_push", custom: true do
      assert(ExFirebase.patch("items_push", "abc") == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
    end
  end

  test "delete" do
    use_cassette "get_items_push", custom: true do
      assert(ExFirebase.delete("items_push") == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
    end
  end

  test "push" do
    use_cassette "get_list_push", custom: true do
      assert ExFirebase.push("lists", 4) == [4, 1, 2, 3]
    end
  end

  test "append" do
    use_cassette "get_list_append", custom: true do
      assert ExFirebase.append("lists", 4) == [1, 2, 3, 4]
    end
  end
end
