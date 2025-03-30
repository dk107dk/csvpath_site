# Result API

You can get a list of Result object from the ResultsManager using a named-results name or a reference. What you get back is the results from each csvpath executed in a single run. Once you have the list of results there is a lot of information available to you, most of which is also available from the result files in each csvpath instance's folder.&#x20;

<figure><img src="../../../../../.gitbook/assets/Screenshot 2025-03-29 at 11.04.54 PM.png" alt=""><figcaption><p>Run directories contain csvpath instance folders that contain results files</p></figcaption></figure>

#### Get a list of named-results

Listing all named-results is not the same as listing runs. Each named-result is one directory in a flat list that is equal to the list of named-paths groups that have been run at least one time. Each name on the list may have had any number of runs.

```python
results:list[str] = CsvPaths().results_manager.list_named_results()
```

#### Get the results from a single run

Each run creates a set of one or more Result objects. Each Result object represents one csvpath in the named-paths group that was run against a single file. You can get the run's Result objects with:&#x20;

```python
results:list[Result] = CsvPaths().results_manager.get_named_results("orders")
```

The results returned are from the most recent run. Alternatively, you can get a specific run's results using a results reference:

```
results:list[Result] = CsvPaths().results_manager.get_named_results("$orders.results.2025-03-01_10:3")")
```

In this case, we are pulling results for the `orders` run on March 1st, 2025 at or after 10:30 AM UTC.  If there are multiple `orders` runs on March 1st, 2025 at or after 10:30 AM UTC the reference is not specific enough so the method returns None.

#### Get a specific csvpath instance from a run

To get a specific instance csvpath results you can use a reference like:

```python
result = paths.results_manager.get_specific_named_result("$food#candy check.results.:0")
```

Or like:&#x20;

```python
result = paths.results_manager.get_specific_named_result("$food.results.2025.candy check")
```

The more common syntax is as in the latter example: `$named-results-name.results.run_dir-match.instance-match` where:

* named-results-name is, as it sounds, any named-results name
* `results` is the datatype pointing to the published results area
* run\_dir-match is a path or timestamp match to the run's folder. This value can have pointers. In the example we're just matching the first part of the run\_dir name, `2025`, and taking the first run found.
* instance-match is the identity of the csvpath that created the results you want, or an index pointer

Equally, but less commonly, we can use the `#` character to add the instance name to the named-results name. In the first example we have `food#candy check`, indicating the `food` named-results's `candy check` instance, and the pointer `:0` indicating which run.



