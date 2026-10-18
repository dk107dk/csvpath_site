---
description: Going beyond plain text output with Jinja
---

# Jinja Reporting

<figure><img src="../../.gitbook/assets/jinja.jpeg" alt="" width="177"><figcaption></figcaption></figure>

CsvPath Framework has excellent support for generating output text during a run. Some of the features available include:&#x20;

* Print to multiple named printstreams
* Use `print()` and `error()` to output any text needed using runtime variable interpolation
* Use table functions to output runtime variables and other indicators
* Separate and transfer printstream files as high-level logs or reports

However, the `print()` and `error()` functions don't write HTML reports summarizing runs. There are times when the ability to create more polished presentation is helpful. And yet, the Framework doesn't want to make assumptions about what data and what form you may need.&#x20;

The answer is that you have the option to create report outputs using Jinja templates. This gives you additional flexibility to create output that works for the people who will receive it.

### How Does Jinja in CsvPath Framework Work?

The `jinja()` takes a source Jinja template, an output filename, and, optionally, a reference to additional metadata from a prior run to add to that of the run that is proceeding at that moment.&#x20;

The function has some limitations, currently planned for upgrade in Q4 2026, that you should bear in mind:

* `jinja()` requires a `CsvPaths` instance. As you will see below, that's not a big limitation, but for some simple use cases it is an additional one line of code you might not have expected.
* The input and output paths must be on the local filesystem. This is the big one. In FlightPath Server filesystem access is locked down to a large degree. `jinja()` isn't a good fit for that environment until the upgrade mentioned above is released.&#x20;
* The Jinja template doesn't live in the named-paths group. If you only want to use Jinja in a "one-off" programmatic way, for e.g. in a pipeline or the script below, this is not a big problem. But in a server environment, or any full preboarding workflow, it would be much better and simpler to have the template in the named-paths group. And this improvement is also planned for the next release.

You can see more information on [`jinja()` in the repo docs](https://github.com/csvpath/csvpath/blob/main/docs/functions/jinja.md). You can also check out the functions look up in the CLI or the Help tab on the right-hand side of FlightPath Data.

### The Code

Here is a basic use of the `jinja()` function to generate an HTML report at the end of a run.

{% code lineNumbers="true" %}
```python
from csvpath import CsvPaths
from csvpath.util.file_readers import DataFileReader

JSONL = [
    {"animals": {"fish":"blue", "gull":"blackback"}, "domain": "sea"},
    {"animals": {"snake":"green","rodent": "mouse"}, "domain": "underground"},
    {"animals": {"elephant":"indian", "panther":"black"}, "domain": "land"},
]
IN = "my_report.jinja"
OUT = "my_report.html"

def run(path:CsvPath=None, jsonl:list=None):
    jsonl = json if jsonl else JSONL
    if path:
        path.rewind()
    else:
        paths = CsvPaths()
        path = paths.csvpath()

    DataFileReader.register_data(path="my_jsonl", data=jsonl, shape="jsonl")
    statement = f"""
        $my_jsonl[*][
            push( "animals", jsonpath(#animals, "$.*") )
            last() -> jinja("{IN}", "{OUT}")
        ]"""
    path.fast_forward(statement)

if __name__ == "__main__":
    run()
```
{% endcode %}

* Line 13: We recieve data or grab our dummy data
* Lines 14-18: If we recieve a `CsvPath` object we'll use it. Otherwise we need to pull a `CsvPath` instance from a `CsvPaths` object, rather than creating it ourseves. This is because the Jinja function uses the `ResultsManager`. A `CsvPath` object doesn't have a `ResultsManager`, but a `CsvPaths` object does have one.&#x20;
* Line 20: We register the JSON data in object form with the `DataFileReader` so that the `CsvPath` instance knows how to access it by the name on line 22.
* &#x20;Lines 23-24: The JSONPath expression pulls out the animals data and it is pushed on a stack called `animals`. When we hit the `last()` line we call the `jinja()` function to get our output.
* Line 26: We do a fast forward run. Fast forward means that we don't collect matched (or unmatched) lines. In this case we just want the Jinja-generated output.

I'll leave the creation of the Jinja template as an exercise for the reader. There are great examples and tutorials on the web.

That's about it, aside from the template. About four lines of Python and two of CVL. Not bad.
