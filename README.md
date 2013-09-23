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

### records

```elixir
Iex(1)> defrecord Test, id: nil, name: nil
{:module, Test,
 <<70, 79, 82, 49, 0, 0, 15, 60, 66, 69, 65, 77, 65, 116, 111, 109, 0, 0, 0, 230, 0, 0, 0, 26, 11, 69, 108, 105, 120, 105, 114, 46, 84, 101, 115, 116, 8, 95, 95, 105, 110, 102, 111, 95, 95, 4, 100, 111, 99, 115, ...>>,
 nil}
iex(2)> rec = [Test.new(id: 1, name: "Jack"), Test.new(id: 2, name: "John")]
[Test[id: 1, name: "Jack"], Test[id: 2, name: "John"]]
iex(3)> fb.Records.put("record", rec)
[[{"name", "Jack"}, {"id", 1}], [{"name", "John"}, {"id", 2}]]
iex(4)> fb.Records.get("record", Test)
[Test[id: 1, name: "Jack"], Test[id: 2, name: "John"]]
iex(5)> IO.puts fb.get_raw_json("record", [pretty: true])
[ {
  "name" : "Jack",
  "id" : 1
}, {
  "name" : "John",
  "id" : 2
} ]
```

### dicts

```elixir
iex(1)> defrecord Weather, id: "", city: "", temp_lo: 0, temp_hi: 0, prcp: 0
{:module, Weather,
 <<70, 79, 82, 49, 0, 0, 20, 100, 66, 69, 65, 77, 65, 116, 111, 109, 0, 0, 1, 45, 0, 0, 0, 33, 14, 69, 108, 105, 120, 105, 114, 46, 87, 101, 97, 116, 104, 101, 114, 8, 95, 95, 105, 110, 102, 111, 95, 95, 4, 100, ...>>,
 nil}

iex(2)> alias ExFirebase.Dict.Records
nil

iex(3)> Records.post("dict", Weather.new(city: "Tokyo"), Weather)
Weather[id: "-J4AFHhI0k5C1vpORZIy", city: "Tokyo", temp_lo: 0, temp_hi: 0, prcp: 0]

iex(4)> Records.post("dict", Weather.new(city: "Osaka"), Weather)
Weather[id: "-J4AFJDF2A2cEtJRMhgm", city: "Osaka", temp_lo: 0, temp_hi: 0,
 prcp: 0]

iex(5)> Records.get("dict", Weather)
[Weather[id: "-J4AFHhI0k5C1vpORZIy", city: "Tokyo", temp_lo: 0, temp_hi: 0,  prcp: 0],
 Weather[id: "-J4AFJDF2A2cEtJRMhgm", city: "Osaka", temp_lo: 0, temp_hi: 0,  prcp: 0]]

iex(6)> record = Records.get("dict", "-J4AFJDF2A2cEtJRMhgm", Weather)
Weather[id: "-J4AFJDF2A2cEtJRMhgm", city: "Osaka", temp_lo: 0, temp_hi: 0, prcp: 0]

iex(7)> record = record.update(temp_lo: 10)
Weather[id: "-J4AFJDF2A2cEtJRMhgm", city: "Osaka", temp_lo: 10, temp_hi: 0,  prcp: 0]

iex(8)> Records.patch("dict", record)
Weather[id: "-J4AFJDF2A2cEtJRMhgm", city: "Osaka", temp_lo: 10, temp_hi: 0,  prcp: 0]

iex(9)> Records.get("dict", "-J4AFJDF2A2cEtJRMhgm", Weather)
Weather[id: "-J4AFJDF2A2cEtJRMhgm", city: "Osaka", temp_lo: 10, temp_hi: 0,  prcp: 0]

iex(10)> Records.delete("dict", record)
[]

iex(11)> Records.get("dict",  Weather)
[Weather[id: "-J4AFHhI0k5C1vpORZIy", city: "Tokyo", temp_lo: 0, temp_hi: 0,  prcp: 0]]
```
