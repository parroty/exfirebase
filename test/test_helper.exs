ExUnit.start

defmodule ExFirebase.Mock do
  use ExUnit.Case

  @empty [url: "", response: ""]
  @default_patterns [
    [url: %r/.*items.json*/, response: "{\"last\":\"Sparrow\",\"first\":\"Jack\"}"],
    [url: %r/.*empty.json*/, response: "null"],
    [url: %r/.*\/.json*/,    response: "{\"root_key\":\"root_value\"}"],
    [url: %r/.*items_push.json*/, response: "{\"name\":\"-INOQPH-aV_psbk3ZXEX\"}"],
    [url: %r/.*items_records.json*/, response: "[{\"id\":\"2\",\"name\":\"Jack\"}, {\"id\":\"3\",\"name\":\"Sparrow\"}]"],
    [url: %r/.*items_push_record.json*/, response: "{\"name\":\"-INOQPH-aV_psbk3ZXEX\"}"],
    [url: %r/.*objects.json*/, response: "{\"-J29m_688gi0nqXtK5sr\":{\"a\":\"1\",\"b\":\"2\"}}"],
    [url: %r/.*objects2.json*/, response: "{\"-J29m_688gi0nqXtK5sr\":{\"a\":\"1\",\"b\":\"2\"},\"-J29pC-tzADFDVUIdS-p\":{\"c\":\"3\",\"d\":\"4\"}}"],
    [url: %r/.*objects\/-J29m_688gi0nqXtK5sr.json*/, response: "{\"-J29m_688gi0nqXtK5sr\":{\"a\":\"1\",\"b\":\"2\"}}"],
    [url: %r/.*objects\/-J30m_688gi0nqXtK5sr.json*/, response: "{\"c\":\"3\",\"d\":\"4\"}"],
    [url: %r/.*objects\/-J31m_688gi0nqXtK5sr.json*/, response: ""],
    [url: %r/.*objects_post.json*/, response: "{\"name\":\"-J29m_688gi0nqXtK5sr\"}"]
  ]

  def request(url, _data // nil, assertion // nil) do
    do_request([@default_patterns], url, assertion)
  end

  defp read_file(file_name) do
    case File.read(file_name) do
      {:ok, content} ->
        content
      {:error, _content} ->
        raise "file not found : file_name = #{file_name}"
    end
  end

  defp do_request(patterns_list, url, assertion) do
    matches         = Enum.map(patterns_list, fn(patterns) -> find_item(patterns, url) end)
    not_nil_matches = Enum.filter(matches, fn(x) -> x != nil end)

    if assertion != nil do
      verify_url_assertion(url, assertion)
    end

    if Enum.count(not_nil_matches) == 0 do
      raise "mock pattern specified in the test was not found."
    else
      item = Enum.first(not_nil_matches)
      if item[:response_file] do
        read_file(item[:response_file])
      else
        item[:response]
      end
    end
  end

  # verify request url contains specified string (used to verify outgoing command)
  defp verify_url_assertion(url, assertion) do
    if String.contains?(url, assertion[:pre_condition]) do
      assert(String.contains?(url, assertion[:expected_match]),
        "expected string '#{url} to contain '#{assertion[:expected_match]}', but didn't.")
    end
  end

  defp find_item(patterns, url) do
    Enum.find(patterns, fn(x) -> Regex.match?(x[:url], url) end)
  end
end

