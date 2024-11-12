---
description: Options for when you need to rerun a named-path group
---

# Replay Using References

A named-paths group is a set of csvpaths that are run as a unit. Named-paths groups are powerful tools for assembling and managing validation and data adjustments. They offer:&#x20;

* The ability to break down validations into bite-sized pieces that are easy to test and reuse
* A simple way to run a group of csvpaths
* A way to make results available across csvpaths and groups of csvpaths
* Options for serial csvpath execution or line-by-line breadth-first execution
* The ability to pipe results from one csvpath to be the input to the next
* The ability to rewind and replay

The last option is super valuable from an operations point of view. What do _rewind_ and _replay_ mean? Let's look at the what and how.

### Rewind vs. Replay

The concepts of rewind and replay are really close. It is more important that you know the capabilities than that you use the right word for an activity. This isn't about language, buzzwords, or product comparisons, it's about getting stuff done.

CsvPath can replay a single csvpath within a named-paths group. It can do that using the same data from a previous run or new data that hasn't been seen before.&#x20;

CsvPath can also rewind to a point in a named-paths group and play forward to any point in the series of csvpaths in that group. This can be combined with setting the run mode for any given csvpath in the group to no-run. And you can also modify the named-paths group itself in JSON, object, or single file form.&#x20;

You can think of these capabilities as being analogous to a music player. Replay is like setting Spotify to loop on a song infinitely. Rewind is like restarting the playlist from the first or any song.

Be aware that replay is most powerful for named-paths groups where data is piped from csvpath to csvpath. That means using the `source-mode` setting `preceding`. The source mode tells the `CsvPath` instance to pull the input data for its csvpath from the `data.csv` stored with the results of the preceding csvpath. Being able to replay from a particular csvpath in the named-paths group is particularly valuable when the data is large or the number of processing steps, represented as intermediate csvpaths, makes development and/or operations complex.&#x20;

Also keep in mind that rewind and replay are for the serial run methods `collect_paths()`, `fast_forward_paths()`, and `next_paths()`. The by-line breadth-first methods do not explicitly support rewind and replay, though there may be corner cases to explore. The reason is that the breadth-first runs do not generate independent intermediate data sets in the same discrete way that serial runs do.&#x20;

### References are key

To rewind and/or replay you need to:

* Use a `CsvPaths` instance, not a `CsvPath`, instance
* Create a named-path group, ideally with an identify for each csvpath in the group
* Pass references to one or both of the file manager and paths manager when you do your run

A named-file name is a pointer that maps to a physical filesystem path. The pointer is in the form of a string name or a reference. A named-paths name is the same, except that it points to one or more csvpaths. You have seen these before and we're not going to add or change anything here except using a reference rather than a simple name string.

### Named-file Names

First named-file names. They are a bit simpler. They come in two flavors:&#x20;

* name-of-named-file
* $named-paths-name.results.instance.csvpath-identity

The top bullet is just the basic name->path setup that you've seen many times in these pages. The second bullet is a reference. Like all references it starts with $. Next it identifies the named-paths result you want to use as your input. The token `results` is the reference datatype that indicates we're talking about the results of a past run. Next, the instance name is a date-time string. And last, the identity of the csvpath within the named-paths group that generated the `data.csv` we want to use as our input. Recall that the csvpath's identity is set in an external comment using a name or id metadata field. For example:

```xquery
~ id: my-identity ~
$[*][yes()]
```

That's a lot!

The result is that we pipe the resulting `data.csv` of a particular csvpath from a completed named-paths group run into our next run.&#x20;

To get it all to work, you need that instance name. Its date-time string identifies the run you want to use as a data source. The format of the instance identifier is like this:&#x20;

`%Y-%m-%d_%H-%M-%S.%f`

That means a date-time like:&#x20;

`2024-03-21_08-15-21.1`

Or March 21st in the year 2024, at 8:15 AM on the 21st second. The trailing `.1` is technically a number of milliseconds, but we only use that in the relatively rare case that two runs complete within the same second. This format would be a pain to remember if not for a couple of tokens:&#x20;

* `:last`
* `:first`

You can use these tokens in your date string to simplify what you are looking for. The way that works is that you substitute the smaller end of your date-time identifier with one of the tokens. E.g.

`2024-0:last`

Means that you want to use the last run, from no later than the last second of September, 2024.&#x20;

`2024-03-21:first`

Means that you want to use the first run that happened after March 21st, 2024.&#x20;

Without these tokens, all you need to do is look at the run times in the archive directory. But using the last and first tokens makes things much easier.

### So far...

So far we have described the named-files pointer. It is the filename argument used in this line to call a `CsvPaths` instance's `collect_paths` method. This one line is where all the rewind and replay magic happens:&#x20;

```python
paths.collect_paths(
    filename="$sourcemode.results.202:last.source1",
    pathsname="$sourcemode.csvpaths.source2:from"
)
```

Rewind and replay can and typically do involve not just the `filename` argument but also the `pathsname` argument.&#x20;

### The Named-paths Name

The file manager takes references that let you find data to use in your next run in the results of a specific csvpath from a past run. The paths manager lets use references to identify what csvpaths to run within the named-paths group in your rewind or replay.&#x20;

Bear in mind that you can achieve the same outcome by manipulating the structure of the named-paths group in its JSON, object, or single-file form, or by using `run-mode: no-run` strategically in your individual csvpath mode settings. But both those options have significant quality and development productivity risks that rewind and/or replay largely avoid.

A rewind or replay reference looks like this:&#x20;

```xquery
$my-named-paths-group-name.csvpaths.my-csv-identity:from
```

The CsvPaths language knows `my-named-paths-group-name` is a named-paths name because of the `csvpaths` datatype.  Anytime you are referencing a csvpath within a named-paths group you should be using that datatype. The exception to that rule is that this is also legal in some uses:&#x20;

```
my-named-paths-group-name#my-csv-identity
```

In general, though, unless you know you need to use the hashmark version for some reason, for rewind and replay use the `csvpaths` datatype in a reference.

Now, if you used just this:&#x20;

```xquery
$my-named-paths-group-name.csvpaths.my-csv-identity
```

You would be replaying just the `my-csv-identity` csvpath. That is useful, for sure. However, you can do more by using the :from and :to tokens. These tokens indicate that the CsvPaths instance should either:

* Run from the first csvpath up to and including the csvpath identified by the reference, or
* Run the identified csvpath along with any following csvpaths in the named-paths group

In both cases you are running as if you used run-mode: no-run in each of the csvpaths in the group that you want to avoid rerunning during the rewind.

This ability to say "pickup the named-group starting from this csvpath and using this data" is not a revolutionary leap from the normal way of running named-groups. But it does offer great tools for development and operational triaging. Definitely worth experimenting with and getting comfortable using.
