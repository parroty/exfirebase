ExFirebase [![Build Status](https://secure.travis-ci.org/parroty/exfirebase.png?branch=master "Build Status")](http://travis-ci.org/parroty/exfirebase) [![Coverage Status](https://coveralls.io/repos/parroty/exfirebase/badge.png?branch=master)](https://coveralls.io/r/parroty/exfirebase?branch=master)
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
    url = System.get_env("FIREBASE_URL")

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
iex(6)> fb.get("iex")
[1, 3, 5, 7, 9]
iex(7)> fb.delete("iex")
[]
iex(8)> fb.get("iex")
[]
```

### Running on Dynamo
The following repo is a sample dynamo project for implementing rails-like scaffold page built using exfirebase.

- https://github.com/parroty/dynamo_firebase


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

### records

```elixir
iex(1)> defmodule Test do
...(1)>   defstruct id: nil, name: nil
...(1)> end
{:module, Test,
 <<70, 79, 82, 49, 0, 0, 4, 204, 66, 69, 65, 77, 65, 116, 111, 109, 0, 0, 0, 110, 0, 0, 0, 11, 11, 69, 108, 105, 120, 105, 114, 46, 84, 101, 115, 116, 8, 95, 95, 105, 110, 102, 111, 95, 95, 4, 100, 111, 99, 115, ...>>,
 [id: nil, name: nil]}

iex(2)> rec = [%Test{id: 1, name: "Jack"}, %Test{id: 2, name: "John"}]
[%Test{id: 1, name: "Jack"}, %Test{id: 2, name: "John"}]

iex(3)> ExFirebase.Records.put("record", rec)
[%{"id" => 1, "name" => "Jack"}, %{"id" => 2, "name" => "John"}]

iex(4)> ExFirebase.Records.get("record", Test)
[%Test{id: 1, name: "Jack"}, %Test{id: 2, name: "John"}]

iex(5)> IO.puts ExFirebase.get_raw_json("record", [pretty: true])
[ {
  "name" : "Jack",
  "id" : 1
}, {
  "name" : "John",
  "id" : 2
} ]
```

### dicts
ExFirebase.Dict provides a dictionary operation based on the Firebase-assigned name parameter.

```elixir
iex(1)> alias ExFirebase.Dict
nil

iex(2)> Dict.post("object", [1,2,3])
{"-J4ARC-BzalPwVIbMY9-", [1, 2, 3]}

iex(3)> Dict.post("object", [4,5,6])
{"-J4ARDLsZplq-ZNlFhgD", [4, 5, 6]}

iex(4)> Dict.get("object")
#HashDict<[{"-J4ARC-BzalPwVIbMY9-", [1, 2, 3]},
 {"-J4ARDLsZplq-ZNlFhgD", [4, 5, 6]}]>
```

ExFirebase.Dict.Records uses the name parameter as "id" field of the record.

```elixir
iex(1)>
iex(1)> defmodule Weather do
...(1)>   defstruct id: "", city: "", temp_lo: 0, temp_hi: 0
...(1)> end
{:module, Weather,
 <<70, 79, 82, 49, 0, 0, 5, 0, 66, 69, 65, 77, 65, 116, 111, 109, 0, 0, 0, 113, 0, 0, 0, 11, 14, 69, 108, 105, 120, 105, 114, 46, 87, 101, 97, 116, 104, 101, 114, 8, 95, 95, 105, 110, 102, 111, 95, 95, 4, 100, ...>>,
 [id: "", city: "", temp_lo: 0, temp_hi: 0]}

iex(2)> alias ExFirebase.Dict.Records
nil

iex(3)> use ExFirebase.Dict.Records
nil

iex(4)> Records.post("dict", %Weather{city: "Tokyo"})
%Weather{city: "Tokyo", id: "-JOMPMelEyQUsdDCnZBj", temp_hi: 0, temp_lo: 0}

iex(5)> Records.post("dict", %Weather{city: "Osaka"})
%Weather{city: "Osaka", id: "-JOMPdn8czXNQPiUWWqq", temp_hi: 0, temp_lo: 0}

iex(6)> Records.get("dict", Weather)
%Weather{city: "Tokyo", id: "-JOMVZwI9zFE4xHBuew2", temp_hi: 0, temp_lo: 0},
 %Weather{city: "Osaka", id: "-JOMV_7ePOHc9eTiqNSO", temp_hi: 0, temp_lo: 0}]

iex(7)> record = Records.get("dict", "-JOMVZwI9zFE4xHBuew2", Weather)
%Weather{city: "Tokyo", id: "-JOMVZwI9zFE4xHBuew2", temp_hi: 0, temp_lo: 0}

iex(8)> record = %{record | temp_lo: 10}
%Weather{city: "Tokyo", id: "-JOMVZwI9zFE4xHBuew2", temp_hi: 0, temp_lo: 10}

iex(9)> Records.patch("dict", record)
%Weather{city: "Tokyo", id: "-JOMVZwI9zFE4xHBuew2", temp_hi: 0, temp_lo: 10}

iex(10)> Records.get("dict", "-JOMVZwI9zFE4xHBuew2", Weather)
Weather[id: "-J4AFJDF2A2cEtJRMhgm", city: "Osaka", temp_lo: 10, temp_hi: 0,  prcp: 0]

iex(11)> Records.delete("dict", record)
[]

iex(12)> Records.get("dict",  Weather)
[%Weather{city: "Osaka", id: "-JOMV_7ePOHc9eTiqNSO", temp_hi: 0, temp_lo: 0}]
```

## TODO
- Support push notification using websocket.
- Support priority attribute.
