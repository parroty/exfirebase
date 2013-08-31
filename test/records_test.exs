Code.require_file "test_helper.exs", __DIR__

defmodule ExFirebase.RecordsTest do
  use ExUnit.Case, async: false
  import Mock

  defrecord Dummy, id: 1, name: "name"

  test_with_mock "get records", ExFirebase.HTTP, [get: fn(url) -> ExFirebase.Mock.request(url) end] do
    records = [Dummy.new(id: "2", name: "Jack"), Dummy.new(id: "3", name: "Sparrow")]
    assert(ExFirebase.Records.get("items_records", Dummy) == records)
  end

  test_with_mock "push record", ExFirebase.HTTP, [put: fn(url, data) -> ExFirebase.Mock.request(url, data) end] do
    record = Dummy.new(id: "2", name: "Jack")
    assert(ExFirebase.Records.push("items_push_record", [record]) == [{"name", "-INOQPH-aV_psbk3ZXEX"}])
  end

  test "generate records from tuples" do
    tuple  = [{"id", 2}, {"name", "test"}]
    record = ExFirebase.Records.from_tuples([tuple], Dummy)
    assert(record == [Dummy.new(id: 2, name: "test")])
  end

  test "generate tuples from records" do
    record = Dummy.new(id: 2, name: "test")
    tuple  = [{"id", 2}, {"name", "test"}]
    assert(ExFirebase.Records.to_tuples([record]) == [tuple])
  end

end
