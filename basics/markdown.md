# The Reference Data Type

CsvPath uses a namespace-like path to point to data in various places. These are called references. References are integrated into the match components, print output, and the structure of a csvpath. If you want to do lookups from one csvpath to the results or metadata of another, you use a reference. When you need to print data from the `print()` function, you need references.

* [The Parts Of a Reference](markdown.md#the-parts-of-a-reference)
* [Four Types Of Data](markdown.md#four-types-of-data)
* [The Csvpath Runtime Fields](markdown.md#the-csvpath-runtime-fields)
* [The Metadata Fields](markdown.md#the-metadata-fields)

## The Parts Of a Reference

A reference has this structure:&#x20;

```perl
$name-of-path.type-of-data.name-of-datum.child-of-datum
```

Let's break this down a bit more.&#x20;

<table><thead><tr><th width="137">Part</th><th>Description</th><th>Example</th></tr></thead><tbody><tr><td>$</td><td>The root of the csvpath </td><td></td></tr><tr><td>name-of-path</td><td><p>This is either: </p><ul><li>a filename, when in the structure of a csvpath</li><li>the name of the csvpath(s) that generated the data the reference is pointing to</li><li>when blank, the currently running csvpath itself </li></ul></td><td><ul><li>$test.csv[*][yes()]</li><li>$mypaths.variables.my_variable</li><li>$.variables.my_variable</li></ul></td></tr><tr><td>type-of-data</td><td><ul><li>variables</li><li>headers</li><li>csvpath</li><li>metadata</li></ul></td><td>$mypaths.metadata.description</td></tr><tr><td>name-of-datum</td><td>Any alphanum (along with '_') name. In the case of headers the name can be quoted or can be the index of the header</td><td><ul><li>$mypaths.headers."my header"</li><li>$mypaths.headers.0</li></ul></td></tr><tr><td>child-of-datum</td><td>This is called a tracking value. Tracking values are keys in <code>dict</code> variables. In the case of references they can also be an index into a stack variable.</td><td><ul><li>$mypaths.variables.cities.Boston</li></ul></td></tr></tbody></table>

## Four Types Of Data

The four types of data are pretty simple.&#x20;

* `variables` are variables. Variables from completed runs are available from the CsvPath that the reference points to. We only lose the variables when the Python instance shuts down.
* `headers` are headers. The header names and indexes are available post-run. The data associated with the headers, line-by-line, may be available or not, depending on if the run method captured data. At this time CsvPath doesn't offer a way for a reference to point to a header value in an individual row.&#x20;
* `csvpath` is either runtime data about the current csvpath or it is post-run data about another csvpath the reference is pointing to
* `metadata` is descriptive data about the csvpath the reference is pointing to

## The Csvpath Runtime Fields

The `csvpath` fields include:&#x20;

* `stopped` — `True` if the csvpath stopped the CsvPath from processing using the `stop()` function. Stopping a CsvPath that is run by a CsvPaths instance does not affect any other CsvPath instances that the parent CsvPaths is also running.
* `failed` — `True` if the csvpath failed the CSV file using the `fail()` function. A CsvPath instance that enters the failed state continues to process lines until the end of the CSV file or until the csvpath stops the run by calling the `stop()` function.
* `delimiter` — the CSV file delimiter. By default a ","
* `quotechar` — the CSV file character used to quote header names and values
* The parts of the csvpath as their original text strings:
  * `scan_part` — something like `$myfile[1-10+20-30]`
  * `match_part` — something like `[concat("validation", "is", "good")]`
* The counts of lines, total lines, matches, and scans
  * `count_matches` — the 1-based count (all counts are 1-based) of the matches that have happened so far in the scan
  * `count_lines` — the 1-based count of the number of lines seen. This is also referred to as data lines because by default CsvPath skips blanks. You may also see references to "physical" lines. Physical lines means the number of line feeds in the file, regardless of if they create blank lines.
  * `count_scans` — the 1-based count of lines seen by the scan so far. If the scan is for 1+3+5 and CsvPaths is at line 3 the count will be 2.
  * `total_lines` — the 0-based count of all the physical lines in the file. This number was found before the first line is scanned.
* The validation failed and run stopped properties
* Basic timing:
  * `line_time` — the cumulative time processing lines so far
  * `last_line_time` — the time spent processing the line before the current line
* `headers` — a string created from the currently set headers. This is largely for debugging. Keep in mind that the headers can be reset on demand using the `reset_headers()` function. Resetting headers is fairly common due to the irregular way CSV files are often constructed.

## The Metadata Fields

The `metadata` fields come from the comments around a csvpath and from the CsvPath files, paths, and results managers.&#x20;

The metadata coming from the managers includes:&#x20;

* `paths_name` — the named-paths name
* `file_name` — the named-file name
* `data_lines` — the count of total data lines. This is a 1-based count of all lines with data. It is set before the first line.
* `csvpaths_applied` — the number of csvpaths that will be applied to the CSV file, all keyed under paths\_name&#x20;
* `csvpaths_completed` — the number of csvpaths completed to that point. This number is static after a run is complete. At that point csvpaths\_completed may not equal csvpaths\_applied if there are csvpaths that were stopped by the csvpath itself using the `stop()` function.
* `valid` — tells us if the file is considered valid according to all the paths applied so far.&#x20;

Much of the information above is available less conveniently from other sources. Perhaps more importantly, csvpath comments can provide keyed-metadata values. Using metadata fields in your comments can be a huge win for the long-term maintainability of large csvpath collections. Keys take the form of a word with a colon at the end. For example:

```clike
~ name: Order Batch File Valdiations
  description: The orders file arrives nightly between 1 - 3 a.m.
~ 
```

This comment would result in two entries in the metadata collection. One for the `name` and the other under the key `description`.
