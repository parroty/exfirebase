Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebase.RecordsTest do
  use ExUnit.Case, async: false
  import ExVCR.Mock

  defrecord Dummy, id: 1, name: "name"

  test "get records" do
    use_cassette "get_items_records", custom: true do
      records = [Dummy.new(id: "2", name: "Jack"), Dummy.new(id: "3", name: "Sparrow")]
      assert(ExFirebase.Records.get("items_records", Dummy) == records)
    end
  end

  test "put record" do
    use_cassette "get_items_push_record", custom: true do
      record = Dummy.new(id: "2", name: "Jack")
      assert(ExFirebase.Records.put("items_push_record", [record]) == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
    end
  end

  test "generate records from tuples" do
    tuple  = [{"id", 2}, {"name", "test"}]
    record = ExFirebase.Records.from_tuples([tuple], Dummy)
    assert(record == [Dummy.new(id: 2, name: "test")])
  end

  test "generate tuples from records" do
    record = Dummy.new(id: 2, name: "test")
    keywords = [id: 2, name: "test"]
    assert(ExFirebase.Records.to_tuples([record]) == [keywords])
  end

end
