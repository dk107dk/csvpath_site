# Named Files and Paths

`CsvPaths` instances work with named-files, named-paths, and named-results. What are those?

* A named-file is simply a name that points to a physical file location
* A named-paths name points to a set of csvpaths that run together as a unit
* Named-results are the results of running a set of named-paths; their names are the same

## Named Files

Named-files are a convenience. It's a lot easier to ask `CsvPaths`  to process orders with their validations like this:&#x20;

```python
lines = csvpaths.collect_paths(filename=august_orders, pathsname=orders_validation)
```

Rather than, potentially, something like:&#x20;

```python
lines = csvpaths.collect_paths( filename=/users/me/validation/orders/august/aug-31-2024.csv, pathsname=....what do I even enter here?
```

{% hint style="warning" %}
The latter is an illustration, not a real method call.&#x20;
{% endhint %}

`CsvPaths`'s file manager also takes care of caching and other background details that `CsvPath` instances on their own don't support.

## Named Files

Named-paths are more interesting. The goal with named-paths is for us to be able to easily run multiple csvpaths against a single file in one go. The attraction to that is primarily that you can segment your validations into separate and composable csvpaths.  As discussed in [Validation Strategies](validation/validation_strategies.md) and [Another Example, Part 2](../getting-started/another-example-part-2.md), separate cvpaths can be important to:&#x20;

* Quality control of your validation
* Maintainability
* Reuse and efficient development
* Performance

You can set up named-paths that are simple 1-to-1 names, like with named-files. But you can also have multiple csvpaths in one file or multiple files keyed by one named-paths name. The options are:&#x20;

* Put your csvpath files in a directory and import them under whatever name you like
* Put your csvpath files in a directory and import them, each as separate named-path, optionally with multiple csvpaths per file
* Read a JSON structure from a file that contains a `Dict[str, List[str]]` where the list of strings is a list of csvpaths
* Do the same, but constructing the `Dict[str, List[str]]` yourself in Python

There is a table of the advantages of each approach [here](../getting-started/another-example-part-2.md).

Keep in mind that order matters in CsvPath. The order of match components within a csvpath is most important. But the order csvpaths are run in may also have an impact. Depending on if you run your named-paths breadth-first (a.k.a. line-by-line) or serially, you can enable different interactions. The differences are [discussed here](serial-or-breadth-first-runs.md). Having your separate csvpaths impact one another is optional, of course!

It is important to remember that order is important across csvpaths as well as within a single csvpath because when you import csvpaths from a directory the order is not guaranteed. By contrast, the order of csvpaths within single file is clear. Likewise, the order in the `Dict[str, List[str]]` structure is deterministic.&#x20;

## Named Results

`CsvPaths` instances keep named-results that store the outputs from named-paths runs. The name of the results is the same as the name of the paths that generated them. Named results are a collection of one `Result` object per `CsvPath` instance per csvpath string. The `Result` objects hold:&#x20;

* The `CsvPath` instance that ran each csvpath in the named-paths set
* All the print output lines&#x20;
* The CSV file lines that matched the csvpath _(optionally)_
* Any errors that happened _(configurable in_ [_config.ini_](how-tos/config-setup.md)_)_

The CsvPath instance also holds the metadata and variables collections. All-in-all, named-results have a ton of data to support your validations.

