---
description: >-
  CsvPath is a very flexible language. There is often another way to do a thing.
  Sometimes you can make your work simpler than you first thought.
---

# Your First Validation, Simplified!

CsvPath is a rules-based validation language. Rules that define when data is valid are powerful. A rule can do things that a structural approach can't do. But sometimes just clarifying the shape of the data is enough. Here's our First Validation example again, this time using structure to define what is valid.

```python
from csvpath import CsvPath

csvpath = """$trivial.csv[*][
    ~ 
     id: First Validation, Simplified!
     description: Check if a file is valid
     validation-mode: print, no-raise, fail 
    ~
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

Here we're using line() to specify what a line of looks like in a valid CSV or Excel file. We expect exactly three headers and require two of them to always have values.&#x20;

We also added some metadata and a mode configuration. The `id` field will become the csvpath's `identity`, available on the `CsvPath` instance's `identity` property. It will be used in built-in validation errors. The `description` is ours to use as we wish—it is a user-defined field. And the `validation-mode` is a setting that tells the `CsvPath` instance that we want to print errors, but not raise exceptions, and we want the file to be marked as invalid if there are errors. We sometimes call this failing the file.&#x20;

There's a lot more you could do, of course. This is barely the tip of the iceburg.
