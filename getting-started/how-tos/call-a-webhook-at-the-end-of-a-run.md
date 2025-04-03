---
description: >-
  Calling a webhook at the end of a named-paths group run is a straightforward
  way to integrate systems
---

# Call a webhook at the end of a run

Your named-paths groups can be configured to call up to four webhooks at the end of a run. You can use this capability to easily trigger workflows that send emails or load webapps or move files, and much more using webhook calls to any of the dozens of automation platforms like Zapier.

<figure><img src="../../.gitbook/assets/Screenshot 2025-04-03 at 1.53.25 PM.png" alt="" width="375"><figcaption></figcaption></figure>

The four types determine if a request is made to a particular hook. The types are:&#x20;

* All — a webhook call is made at the end of every run
* On invalid — a call is made if there are any invalid csvpaths in the named-path group run
* On valid — a call is made if all csvpaths in the named-paths group are were found to be valid
* Errors — if there are errors, the concatenated contents of all the `errors.json` files, as well as any webhook params, are sent to the hook

The configuration you need to make is in the named-paths `definition.json`. The `definition.json` file is where you can define named-paths groups as dictionaries like:&#x20;

```json
{
  "numbers": [
    "tests/test_resources/named_paths/zips.csvpaths",
    "tests/test_resources/named_paths/select.csvpaths"
  ],
  "needs split": [
    "tests/test_resources/named_paths/zips.csvpaths"
  ],
  "_config": { }
}
```

You can name your JSON file whatever you like. CsvPath Framework will copy it into a `definitions.json` file when you load your named-paths groups using the file. Each of the named-paths groups defined in the JSON file will get its own copy of the JSON file.&#x20;

You can add your webhooks configuration to your JSON file by hand or you can add a dict to the loaded JSON file (i.e. CsvPath Framework's definition.json, not your original file) using a method on PathsManager. Either way, everytime you update your named-paths group with its JSON file you will rewrite the config, so you can work in your own file and load it into CsvPath with the PathsManager as often as needed.

## The Python configuration method

The PathsManager method is:&#x20;

```python
from csvpath import CsvPaths
cfg = {
    "on_complete_all_webhook":"type > all, me > var|me, name > meta|name, time > var|now"
    "all_webhook_url":"http://localhost:8000/json-hook"
}
CsvPaths().paths_manager.store_config_for_paths("hooks_test", cfg)
```

store\_config\_for\_paths overwrites the whole config for that named-paths group. If you want to keep your existing config, while modifying it, use:&#x20;

```python
from csvpath import CsvPaths
paths = CsvPaths()
paths.paths_manager.get_config_for_paths("hooks_test")
# config update goes here
paths.paths_manager.store_config_for_paths("hooks_test", cfg)
```

## The JSON configuration method

Alternatively, you can just edit your named-paths group JSON definition file to have the webhook config values. Then you just load your named-paths group as normal using:

```python
from csvpath import CsvPaths
CsvPaths().paths_manager.add_named_paths_from_json(file_path="./my_named_paths.json")
```

The webhooks configuration is goes in the `_config` _key._ `_config` is a dictionary that has keys for each named-paths group that has config information. The keys have a dict of config values. Your webhook config might look like this:

```json
  "_config": {
    "hooks": {
        "on_complete_all_webhook":"type > all, me > var|me, name > meta|name, time > var|now",
        "on_complete_valid_webhook":"type > valid, me > var|me, name > meta|name, time > var|now",
        "on_complete_invalid_webhook":"type > invalid, me > var|me, name > meta|name, time > var|now",
        "on_complete_errors_webhook":"type > errors, me > var|me, name > meta|name, time > var|now",
        "all_webhook_url":"http://localhost:8000/json-hook",
        "valid_webhook_url":"http://localhost:8000/json-hook",
        "invalid_webhook_url":"http://localhost:8000/json-hook",
        "errors_webhook_url":"http://localhost:8000/json-hook"
    }
  }
```

If you use the `store_config_for_paths()` method of adding the webhooks config and don't add csvpath files to your named-paths group in a JSON definition, then this would be all your `definitions.json` file would contain.&#x20;

In this example, the `hooks` key is a reference to a named-paths group named `hooks`. All the four types of webhooks are shown here. They are:&#x20;

* `on_complete_all_webhook`
* `on_complete_invalid_webhook`
* `on_complete_valid_webhook`
* `on_complete_errors_webhook`

Each one has a corresponding webhook URL which is what gets called.

The values under the main hooks keys (`on_complete_all_webhook`, etc) are value pairs. We use this same format for some of the modes. The data structure is a comma-separated list of name-value pairs, with some token substitution options. Each pair is like:&#x20;

```
name > value
```

You can read this as: _name points to value_. Each value can be in the form `meta|name` or `var|name`. A `meta|` value will come from the external comment metadata fields of a csvpath. The `var|` value will come from the csvpath variables. Since we're executing webhooks at the end of a run, not in the context of a particular csvpath, you have to keep in mind that all the metadata is bundled together with the later csvpaths in the group potentially overwriting metadata values set by earlier csvpaths. Likewise with variables, you're working from a superset of variables where the last variable setter wins.

These are all valid examples:&#x20;

```json
name > meta|name, date > var|today, content-type > text/plain, token > MY_KEY
```

The `content-type` key-value is static. The token key's `MY_KEY` is converted, if possible, to the value of the `MY_KEY` environment variable, if one exists. This attempted conversion to an env var value happens whenever a value is in all caps.

These key-value pairs are added to the JSON dictionary that forms the payload of the webhook post. At this time the webhook feature only supports `POST` requests. In the case you send to an errors webhook, your dict will additionally have an `errors` key with a list of all the errors from the run.

When your webhook is configured with:&#x20;

```html
"on_complete_all_webhook":"type > all, me > var|me, name > meta|name, time > var|now"
```

You will see a payload like this:&#x20;

```json
{
  "type": "all",
  "me": "one",
  "name": "my csvpaths",
  "time": "2025-04-03 14:11:23.353189+00:00"
}
```

