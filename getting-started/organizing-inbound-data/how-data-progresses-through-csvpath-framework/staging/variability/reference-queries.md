# Reference Queries

The simplest use of CsvPath is to simply stick with names to reference files, groups of csvpaths, and results. But sometimes using a simple name is not enough. When you get to that point you need to use CsvPath's Reference Language.

{% hint style="warning" %}
As we dig into references, particularly named-paths group references, you may want to skip to the CsvPath Validation Language area for a quick intro to csvpaths and named-paths groups.&#x20;
{% endhint %}

CsvPath's default is to return the most recent file or results by name. Templates add a layer of complexity, but even then, asking for a file or results by name works great if you just need that most recent item. However, with or without the use of templates, you sometimes need to select data files in a dynamic way. There several typical reasons:

* You may need to rerun a file for testing or to account for a bug
* Maybe you missed a run
* You are running multiple files at once
* There are multiple systems using different files from the same named-file folder tree

The way we select files dynamically is to use references. References are essentially queries in the simple XPath-like CsvPath Reference Language. Like XPath, CsvPath Reference Language is a way to pick out resources according to their location within a dataset.&#x20;

{% hint style="success" %}
Note that CsvPath Reference Language is not the same as CsvPath Validation Language. Their goals, syntax, use case, and level of complexity are quite different.&#x20;

The two languages only overlap in two places: 1.) some Validation Language functions use limited Reference Language paths to pull in data from other runs, and 2.) simplified local references are used in the print function to pull in variables, metadata, headers, etc. from the running csvpath.&#x20;

Both of these limited uses of Reference Language within Validation Language are straightforward ways of pointing to data. They do not mean that CsvPath Reference Language is a part of CsvPath Validation Language.&#x20;

Think of them like XPath and XSD in the XML world, or DML and DDL in the SQL world.
{% endhint %}

## Where are references used?

References are mainly used to pick out files within named-files, individual csvpaths in named-paths groups, or named-results. Their form is: &#x20;

```xquery
$root.datatype.name_one.name_two
```

The four sections are:

* Root: a named-file name, named-path name, or named-result name
* datatype: an indicator of the type of data we're looking for
* `name_one`: the most important id/name/date, etc. we're pointing to
* `name_three`: a secondary id/name/date, etc. that helps determine what the reference is to&#x20;

The datatypes are like XPath's axes or a scope, they tell you where the root name is. Effectively they determine what kind of reference you are dealing with. The main datatypes are:&#x20;

* `files`: for references to a named-file
* `csvpaths`: for references to a named-paths group
* `results`: for references to named-results

Secondarily, there are datatypes to indicate the internal data structures of a running csvpath:

* `variables`: to give access to a csvpath's variables
* `metadata`: to pull user-defined metadata fields
* `csvpath`: for access to runtime stats like the match count or line number
* `headers`: to access the current header values, line by line

These latter four datatypes are primarily used "locally" from within a csvpath referring to data of the same csvpath. However, references to variables from different runs is a useful non-local use of these types. Local references forego the root name and instead start with just `$.`, i.e. dollar sign dot.

{% hint style="warning" %}
References from CsvPath Validation Language that pick out variables from other runs are a case where you can use a # to point to variables from a specific csvpath instance in the  other results, or even an earlier csvpath instance in the currently running results.

A reference of this type might look like:&#x20;

```
$mypaths#myinstance.variables.city
```

This reference says to pull the value of the `city` variable from the `myinstance` csvpath variables from the most recent `mypaths` named-results run.  If you didn't use `#myinstance` you would be pulling the `city` variable from the union of all the variable sets created in the most recent run of `mypaths`. Since two csvpath instances might both leave behind their own `city` variable with a different value you might want to be more specific. &#x20;

While this is a great use of references, it is not the most common syntax.
{% endhint %}

References use "pointers" to fill in parts of `name_one` and `name_three`. A pointer looks like a colon followed by a word or number. Using a pointer you can complete a date, provide an index, indicate a day, etc. The pointers are:&#x20;

* `:all` — returns all matches. `:all` is the default behavior. Using `:all` just more explicit.
* `:from` — used in the `csvpaths` datatype to indicate a run should start from a certain csvpath
* `:to` — like `:from`, but indicating the run should stop with a certain csvpath
* `:before` — selects all files registered before a date
* `:after` — selects all files registered after a date
* `:first` — selects the first file in a set of matching files
* `:last` — selects the most recent or last match
* `:yesterday` — converts to the datastamp of `0:00:00` on the previous day
* `:today` — converts to the datestamp of `0:00:00` on the present day
* `:n` _(n = any integer from `0` to `99`)_ — indicates which match to return out of a set of matches

{% hint style="danger" %}
As noted above, in some few cases you can split the root, name\_one, and name\_two path segments using a `#`. In fact, grammatically, you can always do this; however, the support for `#` separated words having a good effect is inconsistent and the intended usage has not yet settled.&#x20;

You might see the values created by a `#` referred to as `root_minor` and `name_two` and `name_four`

But again, it is not common and unless directions say to use the capability you should not.
{% endhint %}

## Examples

### Named-file references

```
$orders.files.EMEA/annual/20:first
```

This points to the `orders` named-file. It looks for a dataset in or below the `EMEA/annual` folder. `20` may indicate a folder that has a name starting with `20`. The reference would also match a filename starting with `20`. Of all the registered files found, the first version registered is selected.&#x20;

```
$orders.files.EMEA/annual/20:all
```

By default a reference will return all items unless there is a pointer indicating only a single match should be returned; e.g. `:last` returns a single match, if any. The default return, therefore, is `:all`. But in some cases you might want to be explicit and include `:all`, even if you don't have to. &#x20;

```
$orders.files.:5
```

This path returns the sixth file registered under the named-file name. (Remember that indexes are 0-based).

```
$orders.files.:today:1
```

`:yesterday` and `:today` are stand-ins for dates to make dynamic references a bit easier. Using the actual date is also pretty straightforward. This reference pulls all the files registered under the `orders` named-file and returns the second one.

```
$orders.files.a0de7c859e9058d5e05784b49c7d426cc5844359255aa143b44832f339a8b055
```

This reference matches a file by the SHA256 hash value of its content. It is an exact match. No two hash values are alike.&#x20;

```
$orders.files.2025-01-01_14-30-00:before
```

This reference returns all the files registered before `Jan 1, 2025 at 2:30 PM UTC`. The match on the datetime is progressive, meaning that any part of the datetime you don't specify will be added in `0`s.

```
$orders.files.acme/2025:all.2025-03-21_:before
```

Another reference returning any number of files before a date. This time we're scoping the datetime limitation to those files that have a named-files path beginning with `acme/2025`. To be clear, the reference would match any file located at `staging/orders/acme/2025-EMEA-invoices.csv` and registered before the start of March 21, 2025, assuming `staging` is the name we configured for our named-files area. It might match other filenames within the `orders` named-file as well, for e.g. `staging/orders/acme/2025-US-invoices.csv`.

### Named-paths references

Named-paths references are simpler. They only need to give dynamic control over which csvpaths within the named-paths group to run. A named-paths reference does that by using the :from and :to pointers to indicate the starting or stopping csvpaths. If there is no pointer the reference is to the specific csvpath named.

```
$invoices.csvpaths.cleanup:from
```

This reference says to do a run of the `invoices` named-paths starting from the `cleanup` csvpath. Or, to be more precise, it references the specific csvpath statements — but that typically means we're setting up a named-paths group run. It is, of course, equally easy to pass a reference to `PathsManager.get_named_paths()` and get back a list of the csvpath statements.&#x20;

Let's say that the invoices named-paths looks like:&#x20;

```bash
~ id: print date ~
$[0][ @day = today() print("Today is $.variables.day")]
---- CSVPATH ----
~ id: cleanup ~
$[*][ replace(#city, uppercase(#city)) ] 
---- CSVPATH ----
~ id: add line number ~
$[*][ append("line", line_number())] 
```

The reference would run the second (`cleanup`) and third (`add line number`) csvpaths in the group. The `print date` csvpath would not run.

```
$invoices.csvpaths.cleanup:1
```

Using the same example, this reference would return only the second csvpath from the `invoices` named-paths group.&#x20;

```
$invoices.csvpaths.cleanup:to
```

And finally, this version of the reference would run the first csvpath (`print date`) and the second (`cleanup`), but would not run the third csvpath in the group.



&#x20;
