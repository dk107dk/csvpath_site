---
description: Options for when you need to rerun a named-path group
---

# Replay Using References

Named-paths groups are powerful tools for assembling and managing validation and data adjustments. They offer:&#x20;

* The ability to break down validations into bite-sized pieces that are easy to test and reuse
* A simple way to run a group of csvpaths
* A way to make results available across csvpaths and groups of csvpaths
* The ability to rewind and replay

The last option is super valuable. What does rewind and replay mean? Let's look at the what and how of it.

### Rewind vs. Replay

The concepts of rewind and replay are really close together. It is more important that you know of the capabilities than that you use the right word for an activity. It isn't about language, buzzwords, or product comparisons, it's about getting stuff done.

CsvPath can replay a single csvpath within a named-paths group. It can do that using the same data from a previous run or new data that hasn't been seen before.&#x20;

CsvPath can also rewind to a point in a named-paths group and play forward to any point in the series of csvpaths in that group. This can be combined with setting the run mode for any given csvpath in the group to no-run. And you can also modify the named-paths group itself in JSON, object, or single file form.&#x20;

You can think of these capabilities as being analogous to a music player. Replay is like setting Spotify to loop on a song infinitely. Rewind is like restarting the playlist from the first or any song.

### References are key

To rewind and/or replay you need to:

* Use a `CsvPaths` instance, not a `CsvPath`, instance
* Create a named-path group, ideally with an identify for each csvpath in the group
* Pass references to one or both of the file manager and paths manager when you do your run

A named-file name is a pointer that maps to a physical filesystem path. The pointer is in the form of a string name or a reference. A named-paths name is the same, except that it points to one or more csvpaths.&#x20;

### Named-file Names

First named-file names. They are a bit simpler. They come in two flavors:&#x20;

* name-of-named-file
* $named-paths-name.results.instance.csvpath-identity

The top bullet is just the name->path setup that you've seen many times in these pages. The second bullet is a reference. Like all references it starts with $. Next it identifies the named-paths result you want to use as your input. The token "results" is the reference datatype that indicates we're talking about the results of a past run. Next the instance is a date-time string. And last, the identity of the csvpath within the named-paths group that generated the data.csv we want to use as our input.

That's a lot!

The result is that we pipe the results of a named-paths group run into our next run.&#x20;

To get it all to work, you need that instance name, the date-time string that identifies the run you want to use as a data source. The format of the instance identifier is like this:&#x20;

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



