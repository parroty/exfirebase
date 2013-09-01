ExFirebase [![Build Status](https://secure.travis-ci.org/parroty/exfirebase.png?branch=master "Build Status")](http://travis-ci.org/parroty/exfirebase)
============
An elixir library for accessing the Firebase REST API.

Detail of the API is described in <a href="https://www.firebase.com/docs/rest-api.html" target="_blank">https://www.firebase.com/docs/rest-api.html</a>

## Prerequisite

Signing up Firebase and getting the access url (https://xxx.firebaseio.com/) is required.

## Sample

```elixir
defmodule Sample do
  def test do
    # acquire your Firebase URL (https://xxx.firebaseio.com/) from the environment variable.
    url = String.from_char_list!(:os.getenv("FIREBASE_URL"))

    # setup url for ExFirebase module
    ExFirebase.set_url(url)

    # put data in /test path"
    ExFirebase.put("test", ["abc", "def"])

    # get data in /test path" and print
    IO.inspect ExFirebase.get("test")  # -> ["abc", "def"]
  end
end

Sample.test
# ["abc", "def"]
```

### Running sample.ex
run_sample.sh calls the sample.ex.

#### Clone the repository

```
$ git clone git://github.com/parroty/exfirebase.git
```

#### Set environment variable for the script

```
$ export FIREBASE_URL="your firebase url"
```

#### Run the script

```
$ ./run_sample.sh
["abc", "def"]
```

### Running on iex
Specify environment variables in advance.

```
$ export FIREBASE_URL="your firebase url"
```

Then run the "run_iex.sh". It loads up "dot.iex" and related libraries.
It has pre-defined alias variables (fb) for API operations.

```elixir
$ ./run_iex.sh
iex(1)> fb
ExFirebase
iex(2)> fb.put("iex", [1, 3, 5])
[1, 3, 5]
iex(3)> a = fb.get("iex")
[1, 3, 5]
iex(4)> a = a ++ [7, 9]
[1, 3, 5, 7, 9]
iex(5)> fb.put("iex", a)
[1, 3, 5, 7, 9]
iex(6)> fb.delete("iex")
[]
iex(7)> fb.get("iex")
[]
```

## Usage
### raw json

```elixir
iex(1)> IO.puts fb.get_raw_json("pretty_test")
[{"name":"Jack","id":1},{"name":"John","id":2}]

iex(2)> IO.puts fb.get_raw_json("pretty_test", [pretty: true])
[ {
  "name" : "Jack",
  "id" : 1
}, {
  "name" : "John",
  "id" : 2
} ]
```

### auth token

```elixir
ex(1)> fb.get("login")
[{"error", "Permission denied."}]
iex(2)> fb.set_auth_token("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
:ok
iex(3)> fb.get("login")
[{"last", "Sparrow"}, {"first", "Jack"}]
```
