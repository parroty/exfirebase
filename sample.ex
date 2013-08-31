defmodule Sample do
  def test do
    # acquire your Firebase URL (https://xxx.firebaseio.com/) from the environment variable.
    url = String.from_char_list!(:os.getenv("FIREBASE_URL"))

    # setup url for ExFirebase module
    ExFirebase.set_url(url)

    # put data in /test path"
    ExFirebase.put("test", ["abc", "def"])

    # get data in /test path" and print
    IO.inspect ExFirebase.get("test")  # -> returns ["abc", "def"])
  end
end

Sample.test
# ["abc", "def"]
