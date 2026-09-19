---
description: Wire your REST API or message stream into unified Edge Data Governance
---

# Dynamic JSON Preboarding



<div align="center"><figure><img src="../../.gitbook/assets/Screenshot 2026-09-19 at 12.18.49 PM.png" alt="" width="375"><figcaption></figcaption></figure></div>

Everywhere data ingress hits the enterprise there is heightened risk and cost. Structured data flows into the organization in three main channels:

* Files
* APIs
* Message streams

You need Edge Data Governance guarding and facilitating all three channels so that BizOps can be low cost and highly effective. CsvPath Framework provides that unified control plane.

Let's look at how an API or message stream consumer can lean on the same CsvPath Framework project setup that a file feed would.

### Some decisions&#x20;

The code to wire CsvPath Framework into your data flow is super simple and the setup is easy. Config and ops are also made even more accessible using [FlightPath Data](https://www.flightpathdata.com/) as your viewport.

You do have some things to think about before you start, though:

* Are you validating data as a blocking gatekeeper, just monitoring, generating metrics, or a combination of all three?&#x20;
* If you are gatekeeping, do you capture suspect records for review or just block processing?
* If your data is coming as JSON, is it JSONL, a JSON doc, or microbatch of several JSON docs?
* Do you want to capture raw data and/or validated and/or upgraded data and/or invalid data, or some or none of these?

And, after the basics are in place, you'll also want to think about how you want to monitor and alert on the data flow. You might also want to publish data out-of-band to downstream systems direct from CsvPath Framework.&#x20;

Lots of things to think about. But the basics are easy.&#x20;

### The Python implementation

First, we need some objects. Let's use this JSONL form. Similar to a microbatch of JSON documents. The difference is that in this case, we are enabling tabular processing using CsvPath Validation Language and/or JSON Schema. Whereas, if we used the LIST\_OF\_JSON form, we would be limiting ourselves to applying one or more JSON Schemas to each object in the list.&#x20;

```json
[
    {"a": "fish", "b": "gull", "c": "clam"},
    {"a": "ant", "b": "mouse", "c": "dog"},
    {"a": "elephant", "b": "tiger", "c": "snake"},
]
```

Next, a few lines to get the live data objects into CsvPath Framework. This code typically lives in your API or message consumer.

```python
#
# setup and perform the validation
#
from csvpath import CsvPaths
paths = CsvPaths()
refs = paths.collect_dynamic(
                pathsname="dynamic",
                dataname="dynamic",
                data=DATA_THREE,
                shape=Runner.JSONL,
                register=False,
                )
#
# if we want to immediate inspect the results we do this:
#
results = paths.results_manager.get_named_results(refs[0])
```

This is the minimum set of information the Framework needs. It is a complete and practical approach, though there are a few other options that can be useful.

* **`pathsname`** — this is our named-paths group, i.e. a set of validation and upgrading assets we will apply to the data as a unit.
* **`dataname`** — this is our named-files registration category. If we capture the raw data to the Framework's versioned immutable storage, this field indicates how that happens. Even if we don't capture the raw data, we still use the named-file `dataname` as an organizing concept.&#x20;
* **`data`** — the objects we are applying the `pathsname` contract to. In this case `DATA_THREE` is our object name.&#x20;
* shape — one of `JSON`, `JSONL`, or `LIST_OF_JSON` to indicate document-form or lines-oriented evaluation. Note that a single JSON object can be treated as any of these three.
* **`register`** — `False` means we are not registering the raw data into the named-file staging area for as a permanent version of truth. A high volume API would create a lot of little documents that might not be helpful. Moreover, we can decide to collect clean data rather than holding on to the raw data. `collect_dynamic` gives us the ability to collect valid and/or invalid data post validation and upgrading.

### A Little CsvPath Validation

We set up the dynamic named-paths group using a single line of Python or we can do it point-and-click style in FlightPath server. Here's the CsvPath Validation Language we'll use.

```javascript
~
  validation-mode: no-raise, print
~
$[*][
    print_line()
    header_table()
    line(
        string.notnone(#a),
        string.notnone(#b),
        string(#c)
    )
    #a == "ant"
]
```

Again, we can use JSON Schema for this same data, if we want to apply a schema to each line separately. Here we can do the same, but with more business rules power and expressiveness. That said, the only rule I have here is `#a == "ant"`. That means when the header `a` is equal to the value `ant` the line matches and can be considered valid, or invalid as the case may be.

To load it, I'll just use Python, rather than FlightPath, just because it's simple:&#x20;

```python
from csvpath import CsvPaths
CsvPaths().paths_manager.add_named_paths(name="dynamic", from_file=CONTRACT)
```

Where CONTRACT is a fully qualified path to a file of one or more CsvPath Validation Language statements, like the one above. As you can see a bit further up the page, to apply this contract to live data is easy enough. And inspecting the output is straightforward.&#x20;

We can get the results from the `ResultsManager` using the reference(s) our `CsvPaths` object gave us to track our validation. In a dynamic data situation like we are demoing here, there will only be one reference in the list we receive back from `CsvPaths`. That is because we're not giving `CsvPaths` a query-like pointer to one or more files, but rather simply handing live data over to be validated. Likewise, there is only one `Result` object in the list of results because we only have one validation statement in our named-paths group.

```python
results = paths.results_manager.get_named_results(refs[0])
assert results[0].errors_count == 0
assert results[0].is_valid 
```

### Mission Accomplished

And that's pretty much it. Well, actually, there is much more you can do both tactically and strategically. But what you see here is a powerful start that works for most general requirements. And keep in mind that you can do similar things with live data frames and other shapes of JSON.&#x20;
