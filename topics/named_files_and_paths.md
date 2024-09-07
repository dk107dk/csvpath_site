# Named Files and Paths

CsvPaths works with named files and named paths. What are those?

* A named file is simply a name that points to a physical file location
* A named path (or really a named paths) is a name that points to a set of csvpaths that go together as a unit

Named files are a convenience to us, as CsvPaths operators. It's a lot easier to ask CsvPaths to process orders with their validations like this:&#x20;

```
lines = csvpaths.collect_paths(filename=august_orders, pathsname=orders_validation)
```

Rather than, potentially, something like:&#x20;

```python
lines = csvpaths.collect_paths( filename=/users/me/validation/orders/august/aug-31-2024.csv, pathsname=....what do I even enter here?
```

{% hint style="warning" %}
The latter is not a real method call!
{% endhint %}

Named paths are more interesting, as you can see from the pseudo example above. The goal with named paths is for us to be able to easily run multiple csvpaths against a single file in one go. The attraction to that is primarily that you can segment your validations into separate and composable csvpaths.  As discussed in Validation Strategies, separating cvpaths can be important to:&#x20;

* Quality control of your validation
* Maintainability
* Reuse and efficient development
* Performance

You can set up named paths that are simple 1-to-1 names, like with named-files. But you can also have multiple csvpaths in one file or multiple files keyed by one named-paths name.
