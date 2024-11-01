# The Reference Data Types

CsvPath uses a namespace-like path to point to data in various places. These are called references. References are integrated into the match components, print output, and the structure of a csvpath. If you want to do lookups from one csvpath to the results or metadata of another, you use a reference. When you need to print data from the `print()` function, you need references.

* [The Parts Of a Reference](the\_reference\_data\_types.md#the-parts-of-a-reference)
* [Five Types Of Data](the\_reference\_data\_types.md#four-types-of-data)
* [The Csvpath Runtime Fields](the\_reference\_data\_types.md#the-csvpath-runtime-fields)
* [The Metadata Fields](the\_reference\_data\_types.md#the-metadata-fields)

## The Parts Of a Reference

A reference has this structure:&#x20;

```perl
$paths-name.data-type.name.child
```

Let's break this down a bit more.&#x20;

<table><thead><tr><th width="137">Part</th><th>Description</th><th>Example</th></tr></thead><tbody><tr><td><code>$</code></td><td>The root of the csvpath </td><td></td></tr><tr><td>paths-name</td><td>The name of a group of csvpaths. This is referred to as a named-paths name. In <code>print()</code> statements the name can be empty to indicate the csvpath the reference is in.</td><td><ul><li><code>$test.csv[*][yes()</code>]</li><li><code>$mypaths.variables.my_variabl</code>e</li><li><code>$.variables.my_variable</code></li></ul></td></tr><tr><td>type-of-data</td><td><ul><li><code>variables</code></li><li><code>headers</code></li><li><code>csvpath</code></li><li><code>csvpaths</code></li><li><code>metadata</code></li></ul></td><td><code>$mypaths.metadata.description</code></td></tr><tr><td>name-of-data-item</td><td>Any name. In the case of headers the name can be quoted or can be the index of the header. In the <code>csvpaths</code> type the name is the identity of a specific csvpath within the named-paths group.</td><td><ul><li><code>$mypaths.headers."my header</code>"</li><li><code>$mypaths.headers.0</code></li></ul></td></tr><tr><td>tracking value name</td><td>This is called a tracking value. Tracking values are keys in <code>dict</code> variables. In the case of references they can also be an index into a <code>stack()</code> variable.</td><td><ul><li><code>$mypaths.variables.cities.Boston</code></li></ul></td></tr></tbody></table>

## Five Types Of Data

The five data types are pretty simple.&#x20;

* `variables` are variables. Variables from completed runs are available from the CsvPath that the reference points to. We only lose the variables when the Python instance shuts down.
* `headers` are headers. The header names and indexes are available post-run. The data associated with the headers, line-by-line, may be available or not, depending on if the run method captured data. At this time CsvPath doesn't offer a way for a reference to point to a header value in an individual row.&#x20;
* `csvpath` is either runtime data about the current csvpath or it is post-run residual data about another named-paths group the reference is pointing to
* `csvpaths` is the namespace for the identities of the individual csvpaths in the named-paths group.
* `metadata` is descriptive data about the csvpath the reference is pointing to

## The Csvpath Runtime Fields

The `csvpath` data type's fields include:&#x20;

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

Metadata's most important contribution is the identity of a csvpath. You set the identity of a csvpath by adding an ID or name field to a comment above or below the csvpath. The ID can be like:

`id: my id`&#x20;

&#x20;`ID: my id`&#x20;

&#x20;`Id: my id`

All three forms will be recognized. If not found, the same forms of the metadata key `name` are looked for. The identity is used for importing csvpaths using `import()`. It is also used by header references and for traceability in validation printouts and logging.

The other metadata coming from the managers includes:&#x20;

* `paths_name` — the named-paths name
* `file_name` — the named-file name
* `data_lines` — the count of total data lines. This is a 1-based count of all lines with data. It is set before the first line.
* `csvpaths_applied` — the number of csvpaths that will be applied to the CSV file, all keyed under paths\_name&#x20;
* `csvpaths_completed` — the number of csvpaths completed to that point. This number is static after a run is complete. At that point csvpaths\_completed may not equal csvpaths\_applied if there are csvpaths that were stopped by the csvpath itself using the `stop()` function.
* `valid` — tells us if the file is considered valid according to all the paths applied so far.&#x20;

Much of the information above is available less conveniently from other sources. More importantly, csvpath comments can provide user defined keyed-metadata values. These are similar to tags in AWS, GCP, and Azure. Using metadata fields in your comments can be a huge win for the long-term maintainability of large csvpath collections. Keys take the form of a word with a colon at the end. For example:

```clike
~ name: Order Batch File Valdiations
  description: The orders file arrives nightly between 1 - 3 a.m.
~ 
```

This comment would result in two entries in the metadata collection. One for the `name` and the other under the key `description`. You can add a colon to end a metadata field without starting a new one, like this:&#x20;

```
~ name: header reset import
  description: this csvpath is used to reset the headers if they change :
  more testing is needed ~   
```

In that example there are two metadata fields: `name` and `description`. The additional comment, `more testing is needed`, is not captured in the metadata fields because the `description` field was closed with a following colon and no new field was started. In this way, `name` and `description` are machine-readable, while `more testing is needed` is only for humans.
