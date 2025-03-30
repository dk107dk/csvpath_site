# Result API

You can get a list of Result object from the ResultsManager using a named-results name or a reference. What you get back is the results from each csvpath executed in a single run. Once you have the list of results there is a lot of information available to you, most of which is also available from the result files in each csvpath instance's folder.&#x20;

<figure><img src="../../../../../.gitbook/assets/Screenshot 2025-03-29 at 11.04.54 PM.png" alt=""><figcaption><p>Run directories contain csvpath instance folders that contain results files</p></figcaption></figure>

To get a specific instance csvpath results you can use a reference like:

```
results = paths.results_manager.get_specific_named_result("$food#candy check.results.:0")
```

Or like:&#x20;

```
results = paths.results_manager.get_specific_named_result("$food.results.2025.candy check")
```

The common syntax is: `$named-results-name.results.run_dir-match.instance-match` where:

* named-results-name is, as it sounds, any named-results name
* results is the datatype pointing to the published results area
* run\_dir-match is a path or timestamp match to the run's folder. This value can have pointers.
* instance-match is the identity of the csvpath that created the results you want, or an index pointer

Less commonly, we can use the `#` character to add the instance name to the named-results name. In the first example we have `food#candy check`, indicating the `food` named-results's `candy check` instance.







