---
description: >-
  CsvPath Reference Language is a query language for navigating CsvPath
  Framework
hidden: true
---

# Exploring Data With CRL

{% hint style="warning" %}
CRL (CsvPath Reference Language) is the third version of references in CsvPath Framework. It is a complete break from v2, though they clearly have a family resemblance. The v2 references that CsvPaths objects return when you kick off a run, and the rewind/replay use of v2 references is exactly the same.&#x20;

At this time, v3 is only used for users' data exploration and AI automated status reporting and triage. It is a power user tool, and is completely optional for most users of the Framework.&#x20;
{% endhint %}

CsvPath Framework has two powerful DSLs:&#x20;

* CVL (CsvPath Validation Language)
* CRL (CsvPath Reference Language)

Both are functional path-based languages with minimal syntax. They are highly specific to the Framework. They are both intended to be simple, easy to read, and relatively hard to get wrong. They make simple things easy, hard things possible.

### What is CRL?

CsvPath Reference Language is a query language. You can also think of it as a navigational path language with predicates. It helps you find and access data and metadata in sets using simple expressions. As with CsvPath Framework, CRL is oriented towards arrival time and run time ordering. It answers questions like:&#x20;

* What data arrived and when?
* What runs were triggered and what were the results?
* What version of my validations was a run based on?&#x20;

### Where Do I Use CRL?

CRL is available today in the CsvPath Framework CLI. In a Q1 2027 release CRL will be available in a data estate exploration UI within FlightPath Data. And in that release, or possibly a quick follow-up, FlightPath will introduce:

* AI natural language narrative data estate reporting and Q\&A
* AI automated triage and data forensics with natural language tracing and remediation&#x20;

### What Validation Languages and Formats Does CRL Support?

All of Them! CRL is a tool for exploration and access. Any data that is registered, uploaded, or generated within CsvPath Framework is findable and accessable using CRL. &#x20;

### What Does CRL Look Like?

CRL is based on references v2. It adds functions, interpolated strings, variables, regular expressions and a functional programming style of writing, similar to SQLs. It looks like references v2, only more so.

* `$*.files.:all()` — show all the named-files registered with no template
* `$acme.files.:type("csv"):uuid()` — get a list of the UUIDs of CSV files registered under the `acme` named-file
* `$acme.files.2026/orders/:groups().:last()` — get the `acme` orders that were registered with a template starting `2026/orders`, treat each file name as a group and return the last version of each.

A CRL statement has the following parts:&#x20;

* `$` — the root of the statement
* A named-entity type: `files`, `csvpaths`, `results`
* A named-entity name — this is `acme` in the example above
* A named-entity sub-part — this is a version of a file, an individual csvpath in a named-paths group, or the results of an individual csvpath statement within a named-paths group run results

The last of these is optional.

CRL references can also be linked together as CRL expressions using three set operations:&#x20;

* `UNION`  — merges the sets found by two references
* `INTERSECT`  — returns those items common to two sets resulting from two references
* `SUBTRACT` — Subtracts the right-hand reference results from the left-hand reference results



