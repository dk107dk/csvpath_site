---
description: JSONL validation is supported as tabular data
---

# Validating JSONL With JSONPath

JSONL is essentially a tabular format, and a very interesting one. Especially when compared to CSV or Excel, the two file-based tabular formats CsvPath Framework supports. JSONL is even quite different from DataFrames validation, despite both being Python objects.&#x20;

With JSONL we have:&#x20;

* Headers in no defined order
* Headers that are unseen unless they have data — which sounds like CSV, but with JSONL there isn't a even placeholder to index on
* More likelihood of nested data
* No delimiter or quotechar needed

Those set aside, JSONL is perfectly tabular.

There are two main validation language options for JSONL:

* CsvPath Validation Language (CVL)
* JSONPath

If you have simple JSONL, with no nesting, or vary shallow nesting, you can stick with strightup CVL. You'll find that is the faster and more understandable choice. But if you have nested data, where headers key complex objects, not scalars, JSONPath may be the way to go.&#x20;

Since in other respects CVL handles JSONL beautifully, and largely the same as it does CSV or Excel, we'll do an example using JSONPath to make things more interesting.

### Opportunities and Limitations

JSONPath requires a CVL driver.  A way to engage the engine — as all languages do, in some way. CVL is that driver. However, unlike XPath, JSONPath is not specifically for predicate logic, so it acts as an object tree pointer and mainly relies on CVL for the good/bad ruling.

### A Simple Example

This example iterates over a JSONL in memory — in this case a list of dictionaries. It registers the data locally and creates or reuses a `CsvPath` object to do a simple JSONPath powered validation.&#x20;

While you could do this same validation using only CVL, you can imagine a less trivial example with deep nesting, where JSONPath would be a more elegant way to pick out data to validate. &#x20;

```python
from csvpath import CsvPath
from csvpath.util.file_readers import DataFileReader

#
# if you are reading JSONL off disk, this is basically what it 
# deserializes to.
#
JSONL = [
    {"animals": {"fish":"blue", "gull":"blackback"}, "domain": "sea"},
    {"animals": {"snake":"green","rodent": "mouse"}, "domain": "underground"},
    {"animals": {"elephant":"indian", "panther":"black"}, "domain": "land"},
]

def run(path:CsvPath=None, jsonl:list=None):
    jsonl = json if jsonl else JSONL
    #
    # We could reuse the CsvPath object, thereby not reparsing the CVL.
    # this example doesn't do that, but if we passed a CsvPath in we
    # would just call rewind() to make it ready for more data.
    #
    if path:
        path.rewind()
    else:
        path = CsvPath()
    #
    # When we're using CsvPaths as our runner -- i.e. full preboarding -- 
    # we have the option to pass shape="listof". That means we want to 
    # process each item in the array as a complete JSON doc, not JSONL. 
    # However, in standalone runs you don't have that option because if
    # you wanted to do that you'd just iterate in Python. Nonetheless, 
    # we still have to pass "jsonl" here.
    #
    DataFileReader.register_data(path="my_jsonl", data=jsonl, shape="jsonl")
    # 
    # Given JSONPath's quirkiness we set validation-mode to raise so that
    # we get loud feedback if something is wrong. `raise` makes each validation
    # error, as well as any actual exception raises, blow up as unhandled 
    # exceptions. In production you probably want `no-raise`.
    #
    statement = """
        ~validation-mode:print, raise~
        $my_jsonl[*][
            ~ get the value from JSONPath ~
            @fish = jsonpath(#animals, "$.fish")
            ~ test it in CVL ~
            exists(@fish)
        ]"""
    lines = path.collect(statement)
    
    if len(lines) == 1:
        print("There are fish.")
    elif len(lines) < 1:
        print("No fish!")
    else:
        print("Too many fish!")
    if not path.is_valid:
        print("There must be fish")

if __name__ == "__main__":
    run()

```

If we wanted to fail the run when any line was not matched we could just update the statement's `validation-mode`:

```
~ validation-mode:print, no-raise, fail ~
$my_jsonl[*][
        ~ get the value from JSONPath ~
        @fish = jsonpath(#animals, "$.fish")
        ~ test it in CVL ~
        exists(@fish)
]
```

That's about it. If you are coming from XPath, XQuery, or Schematron, JSONPath may require some experimentation time. But if you have JSONL or JSONL-like objects with nesting, JSONPath is worth learning.

***

### Notes On How To JSONPath

There are a few things to know about JSONPath. This page isn't going to attempt to be a tutorial on JSONPath. (Try [this page](https://blogboard.io/blog/knowledge/jsonpath-python/) or just ask Google).&#x20;

Here is a short list of things to be mindful of.

1. The Golden Rule: target dictionaries, not scalars. JSONPath filters (`[?(@ ...)]`) and deep search operators expect to inspect structured dictionaries or objects. Running filters against raw, flat scalar values (like a single string or number) will often result in silent failures or empty drops.&#x20;
2. Beware the scalar vs. list trap: If a JSONPath wildcard (`$.*`) matches a single property you may get a raw scalar string instead of a collection. If you need a reliable count or collection, combine JSONPath extraction with CVL’s native handling or target explicit arrays (`[]`).
3. Common Patterns:

| Goal                         | JSONPath Expression          | CsvPath / Python Context & Quirks                                                                                                                                                                                        |
| ---------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Extract a Specific Field     | `$.fish` or `$.animals.fish` | Safely pulls a direct key value. Returns a scalar if it exists.                                                                                                                                                          |
| Extract All Top-Level Values | `$.*`                        | Returns all values of the root or target column as a list (if >1) or a scalar (if 1).                                                                                                                                    |
| Search Deeply                | `$..*[?(@ =~ 'term')]`       | Trap: You cannot put a filter \[...] directly after ... You must include a wildcard (..\*) before the filter. Requires regex (=\~) in jsonpath-ng to catch nested values safely.                                         |
| Count Elements               | `jsonpath(#col, "$.*")`      | Quirk: If the dictionary only has 1 key, peek\_size() might return 0 because the engine returned a scalar string instead of a list. Use explicit JSON arrays (\[]) in your data schema if consistent sizing is critical. |



