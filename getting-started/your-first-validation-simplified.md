---
description: >-
  CsvPath is a very flexible language. There is often another way to do a thing.
  Sometimes you can make your work simpler than you first thought.
---

# Your First Validation, The Easy Way

CsvPath is a rules-based validation language. Rules that define when data is valid are powerful. A rule can do things that a structural approach can't do. But sometimes just clarifying the shape of the data is enough. You can [read more about the difference between these approaches here](../topics/schemas-or-rules.md).

Here's our First Validation example again, this time using structure to define what is valid.

We'll use `line()` to specify what a line of data looks like in a valid CSV or Excel file. This snippet is the whole validation:

```xquery
    line(
        string.notnone("firstname"),
        string.notnone("lastname", 30),
        string("say")
    )
```

We expect exactly three headers and require two of them to always have values.

We could run this using the CLI, but let's see how to do it with Python.

```python
from csvpath import CsvPath

csvpath = """
    ~ 
     id: First Validation, Simplified!
     description: Check if a file is valid
     validation-mode: print, no-raise, fail 
    ~
    $trivial.csv[*][
    line(
        string.notnone("firstname"),
        string.notnone("lastname", 30),
        string("say")
    )
]"""

path = CsvPath().parse(csvpath)
path.fast_forward()
if not path.is_valid:
    print(f"The file is invalid")
```

Two lines to run the validation. Two lines to print a warning if the file is invalid. Simple!

We also added some optional metadata and a mode configuration in a comment. The comment is the part between the `~` characters.

In the metadata we are saying that the `id` field will become the csvpath's `identity`. The identity is available on the `CsvPath` instance's `identity` property. It will be used in printing out any built-in validation errors.&#x20;

The `description` is ours to use as we wish—it is a user-defined field. And the `validation-mode` is a setting that tells the `CsvPath` instance what to do when there is a validation error. In this case we want to print errors, but not raise exceptions, and we want the file to be marked as invalid if there are errors. We sometimes call this failing the file.&#x20;

There's a lot more you could do, of course. This is barely the tip of the iceburg. Keep reading and experimenting!
