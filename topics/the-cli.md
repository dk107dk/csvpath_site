---
description: CsvPath's command line interface is a productivity booster
---

# The CLI

CsvPath includes a CLI to help you iterate quickly on validation and canonicalization dev. It is also helpful when setting up and testing integrations. While the Python required for CsvPath automations is not hard or extensive, the CLI is often a faster alternative.

{% hint style="warning" %}
The CLI supports development and triage activities. Ultimately, it is **a rough and ready and effective tool that includes just the minimum a DataOps person would need** to work with CsvPath. In the future there will likely be more capable and polished tools available. &#x20;
{% endhint %}

{% hint style="danger" %}
Need the best possible CsvPath Framework dev and/or ops environment?  Try [**FlightPath Data**](../getting-started/get-the-flightpath-app.md)!&#x20;

The CLI is still useful, but _the future has arrived_. In most cases FlightPath is the better tool for the job.

With FlightPath's launch, the CLI will get updates only to fix problems or if someone finds an exceptionally cool way it can fill a gap.
{% endhint %}

<figure><img src="../.gitbook/assets/Screenshot 2025-02-14 at 3.09.17 PM.png" alt="The main menu of the CsvPath Framework&#x27;s command line app" width="375"><figcaption><p>Simple and effective!</p></figcaption></figure>

## Turn it on

If you are using Poetry to manage your CsvPath projects just do:&#x20;

```
poetry run cli
```

Alternatively, you can use a couple of lines of Python to create an entry point runner.

```
from csvpath.cli import Cli
Cli().run()
```

When it comes up, you will see a click-through splash screen and then a menu of tasks. As the splash screen says, the CLI tries to make life easier in two ways:&#x20;

* It offers tab completion for named-path group names and name-files names
* In most lists (directory drill downs excepted), the cursor jumps to the sorted initial letters when you press a key

## What does it do?

At this time (again, the CLI improves frequently), the CLI offers the ability to:&#x20;

* List registered data and register new files
* List named-path groups of csvpaths and load new ones
* List results and pop open the (local) archive to results directory
* Run named-paths groups against named-files
* Set some debugging config settings
* List functions and see basic usage information

{% hint style="danger" %}
At this time the CLI only works with local archives and inputs directories. In the future non-local files will likely be supported.
{% endhint %}

## Register data

CsvPaths registers CSV, Excel, and other delimited data files before processing them. Registration means giving them a durable identity and a well-known location. Think of it as a birth certificate and a social security number at the beginning of its lifecycle.&#x20;

When we register a file we are staging a immutable copy for downstream processes. Most often that will be CsvPath Framework itself. CsvPath will apply named-paths groups to validate, upgrade, and stage modified immutable copies in a consumer-oriented archive. Keep in mind, however, it is possible for consumers to go directly to the registration tree to access files, if validation and canonicalization are not needed.&#x20;

To register data you just need to use one of the `FileManager`'s `add_named_file` method and/or its variants. In the CLI this becomes a three or four step process:&#x20;

* Select `add named file`
* Pick the way you want to identify the file: dir, file, or JSON
* If you are selecting the file itself, giving it a name
* Drill down in your local inputs tree to select the file or directory

You can list the named-files you have staged. When you list your named files you are listing the top of your file inputs tree. These are the names in named-files concept.&#x20;

Within each name is a `manifest.json` tracking changes to the named files and the files themselves. Each individual dataset (one version of the named-file) is kept in a hash identified file within a directory that has the same name as the original file that you registered. Sound complicated? Have a look, it's not that bad. But keep in mind that your work with CsvPath is at the abstract named-files name level, not the bytes of physical files.&#x20;

## Load csvpaths

Loading csvpaths means creating named-paths groups. When you run a csvpath in the CsvPath Framework you are usually actually running a group of csvpaths. The group can have just one member. You run and manage groups of csvpaths by a name, hence `named-paths`. The main reason for this approach is that it allows you to break validation and data-upgrading down to fine-grained steps that are easier to develop, triage, reuse, and rerun.&#x20;

{% hint style="success" %}
You can of course use the `CsvPath` class to run a single csvpath without a named-paths group. That is not the ideal way to use the CsvPath Framework in production, in most cases. Regardless, the CLI does not support running individual csvpaths using only a `CsvPath` instance. That makes exactly 0% of use cases harder. And actually, in many, many ways, even though you have a bit more terminology to remember, things get much easier because of the Frameworks opinionated way of working.
{% endhint %}

To load named paths groups you use the `PathsManager`'s `add_named_paths` method or one of its variants. In the CLI this breaks down into four steps:

* Select `add named-paths`
* Chose a way to identify the group of csvpaths: a csvpaths file, a directory, or a JSON file
* If you are loading a csvpaths file, give the name you are going to use for the group
* Locate your file on your hard drive

You can also list your named-paths. When you do that you are looking at the names that you have given to groups of csvpaths, i.e. the named-paths names. Each named-paths directory has a `manifest.json` that describes the named-paths group. It has a `group.csvpath` file with one or more of your csvpaths aggregated into it. And, if you loaded your named-paths group from a JSON definition, a copy of the JSON file is stored in its named-paths directory.&#x20;

While changes to the named-paths group are tracked in the manifest, named-paths group files are not versioned in the inputs tree the way data files are. This is because we expect that as code they will primarily live in a revision control system, typically Git. Each csvpath from the group that you run is also captured in the run metadata along with its hash fingerprint, so there is no loss of identity, durability, or traceability from this approach, even if you don't use Git.&#x20;

## Access the archive

The CLI can list results and pop open the runs directory of a named-paths group. Results of runs are often called `named-results`. The name in named-results is the same name used for the named-paths group that generated the results. We use the named-paths name to identify results, rather than the name of the named-file, because the data in files can be used by multiple downstream users with different needs; whereas, each named-paths group is tailored for a particular use case.

Named-results directories have run directories that are named for the date-time of the run. Inside each run directory is a `manifest.json` that describes the run and its results and a directory named for each csvpath in the named-paths group. Each csvpath directory (sometimes referred to as an instance or an identity) contains the files generated by running that csvpath: `data.csv`, `unmatched.csv`, `errors.json`, etc.&#x20;

## Run named-paths groups

Running a named-paths group against a named-file is easy. Doing a rewind/replay takes a bit more thought, of course. To do a regular run you just pick your named-file and named-paths groups as the CLI lists them. You then pick your run method. The run methods currently available are:&#x20;

* `collect`
* `fast_forward`

In reality there are six run methods available on a `CsvPaths` instance, not just two. The two options offered are actually:&#x20;

* `CsvPaths.collect_paths()`
* `CsvPaths.fast_forward_paths()`

Both are serial run methods. Serial runs walk through the csvpaths of a named-paths group one-by-one, each finishing before the next starts.&#x20;

The other run methods that are not supported in the CLI are:&#x20;

* `CsvPaths.next_paths()`
* `CsvPaths.collect_by_line()`
* `CsvPaths.fast_forward_by_line()`
* `CsvPaths.next_by_line()`

There is no significant effort required, beyond the on-going testing, to add `collect_by_line` and `collect_fast_forward`. If there is demand it will happen! Since only very specific use cases benefit substantially from the difference in serial vs. parallel runs we'll wait for requests. The `next_paths` and `next_by_line` methods are not supported because they are very much intended for programmatic use as generators.&#x20;

## Do rewind/replay

When you use the CLI to run named-paths groups against named-files you have the option to do a rewind/replay run. Rewind/replay is a way to rewind the named-paths group back by some number of csvpaths and replay from there with the same or updated data.&#x20;

| Scenarios                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <p>Imagine you receive a CSV file of hospital procedures every month. It is typically 5 gigabytes. You run a 25-csvpath named-paths group on it. As the paths progress, the data shrinks down to a few hundred kilobytes.  One month the data provider makes a mistake and 10 days after delivery sends a 500k supplemental file.</p><p></p><p>Consider two scenarios:</p><p></p><p>You realize you could substitute the new file into the process at the fifteenth csvpath in the group and save yourself a lot of processing time. You decide to rewind the process to the 15th csvpath rather than marking the first 14 csvpaths with <code>run-mode: no-run</code>, which would require a change to production, and potentially errors if you forgot to reset r<code>un-mode</code> </p><p></p><p><em>— Or —</em> </p><p></p><p>You realize that you made a mistake on the 12th csvpath in the named-paths group. You want to fix that csvpath and rerun the same data from there, skipping the first 11 csvpaths. </p> |

Rewind/replay is particularly useful in cases where you are chaining csvpaths together, the output of one becoming the input of the next, using `source-mode: preceding`.&#x20;

A rewind/replay uses references, rather than just a named-file name and/or a named-paths name. The references are in the form:&#x20;

* For data: `$named-results-name.results.run-datetime.csvpath-identity`&#x20;
* For csvpaths: `$named-paths-name.csvpaths.csvpath-identity`

There is more to it, of course. You can read about references and rewind/replay [here](how-tos/file-references-and-rewind-replay-how-tos/replay-using-references.md), [here](how-tos/file-references-and-rewind-replay-how-tos/doing-rewind-replay-part-1.md), and [here](the_reference_data_types.md) — and there is an example of doing rewind/replay specifically in the CLI [here](how-tos/file-references-and-rewind-replay-how-tos/doing-rewind-replay-part-2.md), including a video of actually doing it.

In the CLI, running a rewind/replay is easy. When you select `run` you are presented with a list of named-files. You can type `$` and hit return to switch to building a file reference. (It doesn't matter what named-file the cursor is next to when you hit `$`). Likewise, when you are asked to pick a named-paths name you can hit `$` and return to build a cvspaths reference. In both cases, just follow the CLI prompts.

## Errors and debug settings

Errors are typically presented in one of two ways:&#x20;

* Errors caught by a csvpath that is not configured to raise exceptions on errors simply print their error messages to the screen&#x20;
* Csvpaths that are set to raise exceptions on errors will show a simple statement that an error happened and allow you to type `e` and hit `enter` to show the stack trace (which is often a mess of information, and rightly so)

You can also look in the log and in `errors.json` in the csvpath instance's results directory.

If you're seeing to much or too little, you can set the debugging config options right within the CLI. You can also set the same options in the `config/config.ini` file. And you can override the config setting within an individual csvpath using `validation-mode`; however, setting `validation-mode` requires reloading your csvpath.&#x20;

To change the debug settings you can use the config selection in the top menu, or click `c` and `enter` when you are faced with an error message that offers that option.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2025-02-14 at 1.54.06 PM.png" alt="The message and options you see when your csvpath file encounters an error, expected or not." width="375"><figcaption></figcaption></figure>

The config dialog that opens lets you change these settings:

* Set logging in logs/csvpath.log to the `DEBUG` or `INFO` levels
* Raising or suppressing exceptions on csvpath errors
* Stopping or continuing on csvpath errors
* Printing detailed validation error lines or bare errors messages without additional metadata

<figure><img src="../.gitbook/assets/Screenshot 2025-02-14 at 1.55.52 PM.png" alt="The debug config dialog"><figcaption></figcaption></figure>

Error messages can be customized in the `[errors] pattern` key of `config/config.ini`. The fields are pretty straightforward. You can [read more here](how-tos/working-with-error-messages.md).

## List functions

The last (for now!) feature of the CLI is functions documentation. On the main menu, select `functions` to see a list of all 150+ CsvPath Language functions. Selecting any one of them shows information like this:&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2025-02-14 at 4.18.45 PM.png" alt="A function definition giving call signature, qualifiers, a description of what the function does, etc."><figcaption></figcaption></figure>

Not all functions have this much information. Luckily [you can get even more detail from the GitHub function docs](https://github.com/csvpath/csvpath/blob/main/docs/functions.md). But regardless, the CLI information is very consistent, well-formatted, and quick to access. All of the functions have signatures and a focus, and all the `Type` functions (those that subclass `Type`) indicate that they can be used to create schemas using the `line()` function.&#x20;

Descriptions and argument names are still thin on the ground. Function look-ups is a new feature. Over time there will more information for each function.

There are a few things to know:

* CsvPath Language functions are match components. That means when they are evaluated they may have a role to play in deciding if a line is a match. The `Focus` line tells you if the function is mainly used to decide matches, calculate values, or do some side-effect that doesn't impact the data. (E.g. printing.)&#x20;
* Functions take match components as arguments. That means their signatures can be written in terms of the types of data they work on or the types of match components they use as data sources. The former is the `Data signatures` column and the latter is the `Call signatures` column. `Data signatures` are evaluated for validity on every line of a data file. `Call signatures` are validated one time when the csvpath begins. That means the data signatures are about the data file and the call signatures are about CsvPath Language correctness.
* Some CsvPath Language match components are schema types. Schema types are used with the `line()` function to create structural schemas. CsvPath Language supports both structure validation and rules-based validation. Most csvpaths or named-paths groups benefit from including both structure definition and rules-based validation. Basically, you generally know what your file should look like and you typically know the business impact of the data it contains, and therefore the constraints. The schema types include:&#x20;
  * `string()`
  * `decimal()`
  * `integer()`
  * `boolean()`&#x20;
  * `date()`
  * `datetime()`
  * `email()`
  * `url()`
  * `blank()`
  * `wildcard()`
  * `none()`

