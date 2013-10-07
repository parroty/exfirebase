Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebase.DictTest do
  use ExUnit.Case
  import ExVCR.Mock
  alias ExFirebase.Dict

  setup_all do
    ExFirebase.set_url("https://example-test.firebaseio.com/")
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "fixture/custom_cassettes")
  end

  @dict1 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])
  @dict2 HashDict.put(@dict1, "-J29pC-tzADFDVUIdS-p", [{"c","3"}, {"d", "4"}])
  @dict3 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])

  test "get single posted object" do
    use_cassette "get_objects", custom: true do
      assert(Dict.get("objects") == @dict1)
    end
  end

  test "get multiple posted objects" do
    use_cassette "get_objects2", custom: true do
      assert(Dict.get("objects2") == @dict2)
    end
  end

  test "post object" do
    use_cassette "get_objects_post", custom: true do
      assert(Dict.post("objects_post", [{"a","1"}, {"b", "2"}]) == {"-J29m_688gi0nqXtK5sr", [{"a", "1"}, {"b", "2"}]})
    end
  end

  test "update posted object" do
    use_cassette "get_objects_post_patch", custom: true do
      assert(Dict.patch("objects", "-J30m_688gi0nqXtK5sr", [{"c","3"}, {"d", "4"}]) == {"-J30m_688gi0nqXtK5sr", [{"c","3"}, {"d", "4"}]})
    end
  end

  test "delete posted object" do
    use_cassette "get_objects_post_delete", custom: true do
      assert(Dict.delete("objects", "-J31m_688gi0nqXtK5sr") == [])
    end
  end
end

defmodule ExFirebase.Dict.RecordsTest do
  use ExUnit.Case
  import ExVCR.Mock
  alias ExFirebase.Dict

  @dict1 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])
  @dict2 HashDict.put(@dict1, "-J29pC-tzADFDVUIdS-p", [{"c","3"}, {"d", "4"}])
  @dict3 HashDict.new([{"-J29m_688gi0nqXtK5sr", [{"a","1"}, {"b", "2"}]}])

  defrecord NoIdDummy, a: nil, b: nil, c: nil, d: nil
  defrecord Dummy, id: nil, a: nil, b: nil, c: nil, d: nil

  setup_all do
    ExFirebase.set_url("https://example-test.firebaseio.com/")
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "fixture/custom_cassettes")
  end

  test "get records" do
    use_cassette "get_objects", custom: true do
      assert(Dict.Records.get("objects", Dummy) == [Dummy.new(id: "-J29m_688gi0nqXtK5sr", a: "1", b: "2")])
    end
  end

  test "get a record" do
    use_cassette "get_objects3", custom: true do
      assert(Dict.Records.get("objects", "-J29m_688gi0nqXtK5sr", Dummy) ==
        Dummy.new(id: "-J29m_688gi0nqXtK5sr", a: "1", b: "2")
      )
    end
  end

  test "post a record" do
    use_cassette "get_objects_post", custom: true do
      assert(Dict.Records.post("objects_post", Dummy.new(a: "1", b: "2")) ==
               Dummy.new(id: "-J29m_688gi0nqXtK5sr", a: "1", b: "2"))
    end
  end

  test "update a record" do
    use_cassette "get_objects_post_patch", custom: true do
      rec = Dummy.new(id: "-J30m_688gi0nqXtK5sr", c: "3", d: "4")
      assert(Dict.Records.patch("objects", rec) == rec)
    end
  end

  test "delete a record" do
    use_cassette "get_objects_post_delete", custom: true do
      assert(Dict.Records.delete("objects", Dummy.new(id: "-J31m_688gi0nqXtK5sr", c: "3", d: "4")) == [])
    end
  end

  test "get records dict without id field throws error" do
    assert_raise RuntimeError, fn ->
      use_cassette "get_objects", custom: true do
        Dict.Records.get("objects", NoIdDummy)
      end
    end
  end

  test "updating a record with nil id throws error" do
    assert_raise RuntimeError, fn ->
      use_cassette "get_objects_post_patch", custom: true do
        Dict.Records.patch("objects", Dummy.new(id: nil, c: "3", d: "4"))
      end
    end
  end
end
