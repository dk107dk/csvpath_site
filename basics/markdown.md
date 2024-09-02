# References

CsvPath uses a namespace-like path to point to data in various places. These are called references. References are integrated into the match components, print output, and the structure of a csvpath. If you want to do lookups from one csvpath to the results or metadata of another, you use a reference. When you need to print data from the `print()` function, you need references.

A reference has this structure:&#x20;

```perl
$name-of-path.type-of-data.name-of-datum.child-of-datum
```

Let's break this down a bit more.&#x20;

<table><thead><tr><th width="137">Part</th><th>Description</th><th></th></tr></thead><tbody><tr><td>$</td><td>The root of the csvpath </td><td></td></tr><tr><td>name-of-path</td><td><p>This is either: </p><ul><li>a filename, when in the structure of a csvpath</li><li>the name of the csvpath(s) that generated the data the reference is pointing to</li><li>when blank, the currently running csvpath itself </li></ul></td><td><ul><li>$test.csv[*][yes()]</li><li>$mypaths.variables.my_variable</li><li>$.variables.my_variable</li></ul></td></tr><tr><td>type-of-data</td><td><ul><li>variables</li><li>headers</li><li>csvpath</li><li>metadata</li></ul></td><td>$mypaths.metadata.description</td></tr><tr><td>name-of-datum</td><td>Any alphanum (along with '_') name. In the case of headers the name can be quoted or can be the index of the header</td><td><ul><li>$mypaths.headers."my header"</li><li>$mypaths.headers.0</li></ul></td></tr><tr><td>child-of-datum</td><td>This is called a tracking value. Tracking values are keys in <code>dict</code> variables. In the case of references they can also be an index into a stack variable.</td><td><ul><li>$mypaths.variables.cities.Boston</li></ul></td></tr></tbody></table>

The four types of data are pretty simple.&#x20;

* `variables` are variables. Variables from completed runs are available from the CsvPath that the reference points to. We only lose the variables when the Python instance shuts down.
* `headers` are headers. The header names and indexes are available post-run. The data associated with the headers, line-by-line, may be available or not, depending on if the run method captured data. At this time CsvPath doesn't offer a way for a reference to point to a header value in an individual row.&#x20;
* `csvpath` is either runtime data about the current csvpath or it is post-run data about another csvpath the reference is pointing to
* `metadata` is descriptive data about the csvpath the reference is pointing to

The `csvpath` fields include:&#x20;

* Delimiter
* Quotechar
* The scan and match parts of the csvpath as the original text strings
* The counts of lines, total lines, matches, and scans
* The validation failed and run stopped properties
* Some timing information, including cumulative matching time

The `metadata` fields come from the comments around a csvpath and from the CsvPaths files, paths, and results managers.&#x20;

The metadata coming from the managers includes:&#x20;

* The named-paths name
* The named-file name
* The number of data lines (meaning the count of lines that had any data)
* How many csvpaths were (to be) applied&#x20;
* How many csvpaths were completed at the time of the request for metadata
* Is the file considered valid according to the paths applied?&#x20;

Csvpath comments can provide keyed-metadata values. Keys take the form of a word with a colon at the end. For example:

```clike
~ name: Order Batch File Valdiations
  description: The orders file arrives nightly between 1 - 3 a.m.
~ 
```

This comment would result in two entries in the metadata collection. One for the `name` and the other under the key `description`.
