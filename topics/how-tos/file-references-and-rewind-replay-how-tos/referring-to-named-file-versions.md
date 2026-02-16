---
description: It's common to need to rerun an older file version again -- and easy to do.
---

# Referring to named-file versions

CsvPath stores file versions as named-files. Each name identifies a set of physical files. The set of physical files may have had the same name or different names. One by one they all become the most current named-file.

But what about when you want to re-run last week's version or last month's or year's?  Happens all the time when we need to compare data or update our CsvPath Language files and rerun. Luckily it is easy to run old versions. The way you do it is with references.

## Types of references

File references are not the same as named-paths references or references to results data files. Those are three different capabilities that help you do similar things: re-run CsvPath Language files against data files.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-02-26 at 1.44.12 PM.png" alt="A comparison of how different types of references help you run your data preboarding process on new or older delimited data."><figcaption><p>There are lots of options for rerunning or reusing preboarding processes and data</p></figcaption></figure>

You can read about using results and named-paths references in doing rewind/replays [here](doing-rewind-replay-part-1.md), [here](doing-rewind-replay-part-2.md) and [here](replay-using-references.md). This page is about named-file references. A.k.a. _how do I go back in time to run earlier data?_

## The file reference datatype

References have types. You can [read about there here](../../practical-stuff/the_reference_data_types.md). Named-file references look like:&#x20;

```bash
$new-arrivals.files.yesterday:last
```

The datatype for this reference is `files`, indicating that it is a reference into the named-files collection. It points to a named-file named `new-arrivals`. The version of `new-arrivals` it refers to is the last version that was registered yesterday. If no `new-arrivals` file was registered yesterday, this reference will result in an error message saying the file cannot be found.

## Identifing versions

In the reference above, `:last` is a token or pointer that modifies the word `yesterday`. There are several of these pointers that help you more easily identify versions of named-files. If you have ever looked at the physical files associated with a named-file name you've seen that they are named using sha256 hashes. The hash comes from the bytes of the file and changes each time a new file is registered with different bytes. One of these file names might look like:&#x20;

```url
inputs/named_files/food/food.csv/74d3787c36bdb2098a3479126d28970618696237d63f9006717d61e86af5a988.csv    
```

Obviously a hash filename is a pain to work with so we have several approaches to identifying versions of named-files. And some of the ways have optional pointers like `:last`.  The ways are:&#x20;

* Index
* Fingerprint&#x20;
* Day
* Date

## Index

Using an index is pretty much what it sounds like: a zero-based integer that is the count of versions of the named-file. You can see the versions in the manifest file. In the food named-file example above the manifest file is at:&#x20;

```bash
inputs/named_files/food/manifest.json
```

Opening the manifest.json we might see:&#x20;

<figure><img src="../../../.gitbook/assets/Screenshot 2025-02-26 at 3.34.35 PM.png" alt="The contents of the named-files manifest.json. It shows that four CSV files were registered under the name &#x22;food&#x22;."><figcaption></figcaption></figure>

You can see that four files have been registered under the name `food`. The first and last were named `food.csv` and the second and third physical files registered as the `food` bytes were actually `people.csv` and `people2.csv`. To refer to the second file by zero-based index we would simply use:&#x20;

```
$food.files.1
```

## Fingerprint

A fingerprint is a sha256 hash. It is a representation of the exact bytes in a file. If even one byte changes, the new fingerprint would be complete different and unique. Any two files with exactly the same bytes, regardless of the filename, will have the same fingerprint.&#x20;

To make a reference by fingerprint to the third `food` file in the `food` named-file's `manifest.json` screenshot above we would have to find the fingerprint in the manifest and add it to our reference like this:&#x20;

```bash
$food.files.be9fadda358d434e29c4cbf794bbbe1d505bf17d68598c4131f10c4ece176c67
```

This is the most exact way to refer to a file, but it isn't the most convienent.&#x20;

## Day

We can create a reference to a file by day using today or yesterday. These do exactly what they sound like. Today picks out the file version from the current day. Yesterday picks out the file version from the preceding day.&#x20;

But wait, what if there are multiple versions from today or more than one from yesterday?  You can solve that problem, in some cases, using `:first` and `:last`. These pointers say that you are looking for either the first version registered in the specified day or the last version registered. If you don't provide a pointer the default is `:last`.&#x20;

```bash
$food.files.yesterday:last
```

This could be a helpful reference when you pickup the previous day's work in the morning and want to start working on the bytes you had then. On the other hand, to pick out the 1st version of `food` in the `manifest.json` above you would use the following (assuming it's still the 26th of February 2025):&#x20;

```bash
$food.files.today:first
```

Instead of `:first` and `:last` you can also use the index of a registration. That works the same way we described an index reference above, except that the index is just within the subset of registrations from `today` or `yesterday`. If I have a named-file with 10 registrations the last five of which happened yesterday, I can use a reference like this to pick out the second bytes registered yesterday, a.k.a. the registration at the seventh index of all registrations on all days:&#x20;

```bash
$food.files.yesterday:2
```

## Date

The final way to refer to a named-file version is by datestamp. A date reference might look like:&#x20;

```bash
$food.files.2025-02-2:after
```

This reference says that we want the food bytes from the first file registered as food after February 20, 2025, midnight. Similarly:

```bash
$food.files.2025-02-26_18-50:after
```

This reference would pickout the first registration in `food`'s `manifest.json`, above.

The full timestamp pattern you use in your references in strftime notation is:&#x20;

```python
%Y-%m-%d_%H-%M-%S
```

You can provide as much specificity as you like by adding more to the format string. I.e. `2025-01-21_01` is less specific than `2025-01-21_01-30-45`. However, neither goes to the subsecond, so in principle there could be a conflict where you specify the datatime to the second, but there are two registrations that happened in the same second. In practice, that is hugely unlikely, and if you think it could happen you should just use the fingerprint. Since you'd need to dig the to-the-second datetime out of the `manifest.json` anyway, using the fingerprint would be no more effort.

As well as `:after` and `:before` you can pass a datetime string without a pointer. A reference like that is an exact match reference. In general, the benefit of using a datetime string without a pointer is clarity. A fingerprint or an index would be equally effective, but less easy to interpret without checking the `manifest.json`.







