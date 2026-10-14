---
description: ODCS contract enforcement lets the edge speak downstream's language
---

# Validating With ODCS

<figure><img src="../../.gitbook/assets/odcs.png" alt="" width="350"><figcaption></figcaption></figure>

ODCS sits alongside JSON Schema, XSD, and CsvPath Validation Language as a first-class option for validating your data at the ingress point. While more commonly used with relational databases, ODCS's broader fit with tabular data sets is good. In many cases ODCS contracts are an excellent choice for edge data governance.&#x20;

Each validation language has its strengths and weaknesses. At a high level, here's the breakdown for ODCS:

| Strengths                                                                                                                          | Not intended for                                                                                                                                                                                   |
| ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Support for v3.0.x, v3.1.0, v3.2.0                                                                                                 | XML and JSON documents                                                                                                                                                                             |
| Enables validating against existing database contracts upstream at the edge, preventing bad data from corrupting flows in the core | Does not support SQL rules at this time                                                                                                                                                            |
| Carries substantial non-validation metadata that carries through the run                                                           | Does not validate relational structures                                                                                                                                                            |
| Good format for sharing data contracts with external partners                                                                      | Does not support multiple entities defined in a single tabular structure when used in standalone validations. Used in the full preboarding workflow, multiple contracts per ODCS file are allowed. |
| Covers CSV, JSONL, DataFrames, and Excel data                                                                                      |                                                                                                                                                                                                    |

As you would expect, validating data with ODCS requires a driver and engine. We use the CsvPath Validation Language engine to interpret and enforce a contract. That gives you all the data preboarding workflow automation the Framework offers in a data firewall stance. It does not offer validation of deeply hierarchical JSON or XML, at this time, but it does support JSONL, as well as other tabular formats and DataFrames.&#x20;

ODCS is about more than validation, of course. The non-technical data contract fields are preserved and propagated downstream through runs. ODCS properties become user-defined (or in this case, standard-defined) metadata fields. They are available in meta.json, along with the runtime metrics, as usual. The ODCS file itself will also follow the results downstream into the results directories. For a standalone validation you can find this metadata in the `CsvPath` instance's `metadata` property.

Let's see ODCS in action. There are two possible modes, same as with any use of CsvPath Framework:

* Standalone, validating just the data passed in and skipping the data preboarding workflow
* As part of a complete workflow, starting with a named-paths group and resulting in the full set of results assets

The former is ideal for API backends, DataFrames, and scripted validations that need an immediate answer, without the need to capture the full set of versioned, immutable result metadata. The latter is the way to go if longitudinal metrics, lineage, support, no-code integration, or data forensics-friendly history are requirements.&#x20;

### First, standalone

The basic pattern is like this:

```python
from csvpath import CsvPath
from csvpath.odcs import OdcsContractLoader, OdcsConverter

def run():
    odcs = OdcsContractLoader.from_path(path="orders_contract.yaml")
    conversion = OdcsConverter(contract=odcs).convert(path="orders.csv")
    path = CsvPath()
    lines = path.collect(conversion.csvpaths["orders"])
    assert path.is_valid
```

* `odcs` is the contract structure
* `conversion` is the contract converted to the engine's format, a csvpath statement. In a standalone run the ODCS should have only one contract (in a full data preboarding run you may have any number of contracts in the file)
* `orders.csv` is the data. Using live objects, a JSONL, etc. is also straightforward.
* `lines` are the matching lines, i.e. the lines that are valid according to the ODCS contract
* `path.is_valid` is a test against the engine's end state to see if we consider the data as a whole valid. As usual, all the various validation strategies are available, so `is_valid` may or may not declare that every line in the data matched. Taking that approach is just one of several possible ways of assessment.&#x20;

This is the same pattern as for any stand-alone run. The validation boolean, errors, printouts, variables, etc. are all available, as usual, on the `CsvPath` instance. And running the same validation but with live objects is [exactly the same](validating-json/validating-json-objects.md) as you would do without ODCS, with the addition of the `OdcsContractConverter`.&#x20;

### Using ODCS In a data preboarding workflow

While standalone is great for live objects backends, pipeline automation, notebooks, etc. a data firewall often requires a consistent preboarding workflow across data partners and greater metadata capture. It is, of course, possible, and in many cases practical, to use data preboarding for files and, at the same time, standalone validation in other scenarios. But let's set those implementation considerations aside for now and just focus on the mechanics.

Happily, the mechanics of a preboarding run are not a lot more complex than the standalone version. We don't need to parse our ODCS. That happens behind the scenes. But, as you would expect, we do register our data and load our ODCS into a named-paths group. Here's what it looks like:&#x20;

```python
from csvpath import CsvPaths

paths = CsvPaths()
paths.file_manager.add_named_file(name="orders", path="orders.csv")
paths.paths_manager.add_named_paths(name="orders", from_file="orders.odcs.yaml")
paths.collect_paths(pathsname="orders", filename="orders")
for result in paths.results_manager.get_named_results("orders"):
    print(result.is_valid, result.lines.to_list())

```

* We use `CsvPaths`. The class with the plural name is the preboarding runner. The sigular `CsvPath` we used above is for one-off runs.
* The named-file `"orders"` can be anything you like. It doesn't have to match the named-paths name. It does here just for convenience.&#x20;
* `collect_paths` is the serial run method that captures all matching lines. You also have the option to not collect the matches and/or to run multiple csvpath statements in breadth-first mode. Those options are explained elsewhere in the docs.
* `get_named_results` gets you a set of `Result` objects, one per csvpath or ODCS contract in the named-paths group.

And that's it. Clearly you get much more in terms of history, immutability, modularization of validation rules, and integrations when you use the full preboarding workflow. But, overall, the complexity of the the run setup is about the same — i.e. quite low.
