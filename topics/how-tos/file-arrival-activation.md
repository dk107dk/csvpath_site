---
description: Automatically run a named-paths group when a new file arrives
---

# File Arrival Activation

You can have a named-paths group run automatically when a new file arrives and is registered as named-file version. This functionality is essentially the same as:

```python
csvpaths = CsvPaths()
csvpaths.file_manager.add_named_file(name="shipping", path="/my/path/to/my/file.csv")
run_ref = csvpaths.collect_paths(filename="shipping", pathsname="my_shipping_group")
```

It is also essentially the same as calling FlightPath Server's `/`[`register_and_run`](https://www.flightpathdata.com/swagger/dist/#/register/register_and_run_csvpath_register_and_run_post) endpoint.

Even though the functionality is not hard to replicate using plain Python or a JSON REST API endpoint, it still has value. Activating a named-paths group on file arrival is an automated, no-code operation. It is based on configuration that lives with the named-file. And it acts as a default behaviour that can consistently augment a workflow, even when it is not the main event.

Setting up the file arrival activation is equally straightforward. You add it to the named-file's definition.json file. It looks like:&#x20;

```json
{
  "on_arrival": {
    "named_paths_group": "shipping",
    "run_method": "collect_paths"
  }
}
```

It's that simple. Now when a. new CSV, Excel, or JSONL file is registered — in Python, using the API, or in FlightPath Data — our `shipping` named-paths group will run.&#x20;

