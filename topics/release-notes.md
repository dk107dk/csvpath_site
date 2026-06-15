---
description: High-level descriptions of CsvPath Framework and FlightPath Data releases
---

# Release Notes

### 0.0.612 - 11 June 2026

* Generate multiple printout files by printer name using `print-mode:separate`&#x20;
* Transfers improvements encapsulated in the named-paths definition.json descriptor (csvpath statement `transfer-mode:` directives continue to exist as a simpler option):
  * Multiple transfers per csvpath statement
  * Transfers within csvpaths grouped by run state: all runs, valid, invalid, and runs with errors
  * Ability to transfer original source file, as well as any result file
  * Transfers can be sent to any backend
  * Multiple transfers-only SFTP servers can be configured, allowing you to use SFTP destinations that are not configured as a CsvPath Framework project backend
  * All files in the results directory can be transferred, including the new arbitrarily named printouts files that can be created by print(), error(), and jinja() using `print-mode:separate`
* Registration of all files in a directory can be filtered by a regex
* SFTP improvements:
  * Multiple SFTP source locations can be configured on a named file. This allows registering from SFTP servers that are not acting as the project's backend.
  * Multiple SFTP destination locations can be configured on a named-paths group. This allows SFTP transfers to go to SFTP servers that are not acting as the project's backend.
* New functions:&#x20;
  * `runtime()` — provides access to the runtime variables already available to `print()`, `error()`, and `jinja()`
  * `metadata()` — provides access to the user defined metadata fields in a csvpath statement's leading comment, as well as modes configurations
  * `env()` — provides access to the environment variables available to the project; either OS env variables or the variables in the project's env.json.
  * `uuid()` — a schema type for line() schemas that also generates UUIDs to populate variables
  * `select()` — selects a column of data from a SQL database into a stack variable&#x20;
* New `.tmp` qualifier to limit the data stored permanently in `vars.json` at the end of a run
* Date-time tokens in templates:
  * `:day`
  * `:month`
  * `:month_name`&#x20;
  * `:year`&#x20;
  * `:hour_24`&#x20;
  * `:hour`
  * `:minute`&#x20;
  * `:second`
* Additional fields in runtime metadata (print(), error(), jinja() and captured to meta.json):&#x20;
  * The datetime fields: `day`, `day_of_week`, `month`, `month_of_year`, `hour`, `hour_of_day`, `minute`, `second`
  * `run_dir`
  * The run's `reference`
  * `named-paths`
  * `named-file`<br>

### Spring 2026 FlightPath - v1.1.88

#### **AI-Assisted Authoring**

FlightPath’s sidebar AI assistant helps developers and BizOps team members with four core authoring tasks:

* **Generate validations from requirements**: describe a data contract in plain language and get a working CsvPath script as a starting point
* **Explain validation scripts**: Get a complete plain-English rule-by-rule walkthrough of what an existing script does
* **Create test data**: Generate sample files that exercise your validation logic before real data arrives
* **Refactor validation scripts**: Clean up, reorganize, or modernize existing CsvPath code without rewriting from scratch

#### **Autonomous workflows**

Three new operational capabilities reduce manual intervention in day-to-day data operations:

* **Arrival activations**: Automatically trigger runs when data files arrive — no scheduling, no polling, no manual handoff
* **Async job control**: Full visibility into running jobs: status, metrics, and results accessible at any point, with clean access to results when a run completes
* **No-code webhooks**: Fire automatically based on run outcome criteria, keeping downstream consumers, monitoring tools, and notification systems informed without anyone in the middle. The original webhooks integration can still be used csvpath-statement-by-csvpath-statement, using both capabilities at the same time is fine.

#### Config variable interpolation

Variable swapping support is significantly expanded. Projects can use OS-level or project-specific environment variables interchangeably. Config values written in ALL CAPS are automatically resolved against the environment. Config values can contain {...} replacement tokens that pull from OS or project environment variables. Resolved values can themselves can point to further environment variables, keeping credentials separated from runtime configuration.

#### Registration path templates

Templates can now be set as a default directly in the named-file definition. Previously, the same template had to be passed explicitly on every registration.

#### Post-Run transfers&#x20;

Transfers now support all files generated during a run, not just the primary output. Transfers work across all configured storage backends.

#### Parquet output generation&#x20;

Parquet output is based on a data schema defined using the `parquet()` function. `parquet()` is like <sub>`line()`</sub>, FlightPath’s structural schema function. Multiple `parquet()` functions can be active simultaneously, each generating its own Parquet file. This makes it possible to decompose a flat CSV into separate relational entities in a single pass.

#### Other improvements

* 10 new analytical and transformation functions
* Grid View for run metadata
* Default Markdown documentation Files generated in named-paths groups and named-files

### 0.0.599 - 31 March 2026

* Config variables are parsed for braces-bracketed substitution text. A OS or env.json variable in the form `"This is {who} variable"` will be rendered as `"This is my variable"` if there is another variable `who` with the value `"my"`.
* `transfer-mode` configuration also follows the braces-bracketed interpolation on the transfer-to path, enabling destinations like `sftp://{SFTP_SERVER}:{SFTP_PORT}/my/destination`.&#x20;
* The new `sql_in()` function is a SQL column analog to the existing `in()` function. `sql_in()` enables live or cached presence tests against a column from a table in Postgres, MySQL, or Sqlite.

### 0.0.598 - 11 March 2026

#### Major changes

* Support CsvPath-to-Parquet schemas and [Parquet file output](how-tos/parquet.md)
* Addition of a `definition.json` and `README.md` to named-files
* Added a configuration to automatically trigger runs on file registration
* Added a configuration to automatically use a default named-file path template for registrations
* Update to both `transfer-mode` and the SFTP integration to allow sending any/all files generated in a run
* Fix for a problem where delimiter and quotechar choices were not being applied to output files
* Substantially improved validation error reporting, including:&#x20;
  * Deduplication of similar errors
  * Improved descriptions
  * Providing more complete error information
  * Improving ID chains to better identify error sources within csvpaths
* Fix for a problem where CsvPaths run methods would act on only the first file returned by a reference, rather than all results found by the reference.
* Eight function improvements including the following new functions:&#x20;
  * **`parquet()`** - a specialization of line() that uses its schema to create a parquet file of all matching data
  * **`sort()`** a stack var
  * **`slice()`** a stack var
  * **`percent_matching(header, value|stack)`**
  * **matches()** - the same capability to indicate matching lines as the `onmatch` qualifier, but in the form of a function suitable for use cases where a function test is needed

### Winter 2025-2026 FlightPath - v1.1.87

* Comprises: CsvPath 0.0.591, FlightPath Server 0.1.27, FlightPath Data 0.1.28&#x20;
* FlightPath changes:&#x20;
  * Support for creating and editing JSONL
  * Support for editing CSV and JSON in grid view
  * New JSON text editing view
  * Edit JSONL as JSON
  * CSV and JSONL grid view editing, including copy-selected-to-new
  * Support for custom functions in FlightPath Data and FlightPath Server
  * Added `use-delimiter` and `use-quotechar` for FlightPath Data and FlightPath Server
  * Added a config dialog to compare and sync config between projects in Data and Server
  * Improved the env vars config dialog to act as a compare and sync, not just an upload, between projects in Data and Server
  * Changed to a fixed width font in the printouts tab for better table printouts
  * Many minor fixes and improvements

### **0.0.591 - 25 Jan 2026**

* Added `jsonpath()` function using jsonpath-ng
* Dozens of minor fixes and improvements

### **0.0.581 - 11 Jan 2026**

#### **Major changes**

When/do changes:&#x20;

* When/do operator right-hand sides now contribute to matching&#x20;
* When/do right-hand side now respects `nocontrib`

Custom functions changes:&#x20;

* External functions can be loaded from a file anywhere visible to the Python process&#x20;
* Functions loaded from different `function.imports` files within the same Python process do not collide&#x20;
* Multiple `functions.imports` will be loaded&#x20;
* `FunctionFactory` supports reloadeding imports files

Three new functions:&#x20;

* Added `line_before()` to compare current line header value to last line header value&#x20;
* Added `remove()` to drop one or more headers&#x20;
* Set headers manually using `rename(@stack)` or `rename(“a”, “b”, “c”…)`

Three qualifier changes:&#x20;

* Support for name qualifiers in `error()` that are visibile in error events. E.g. `error.myname(“this is a msg”)` outputs: `2025-12-08 00h42m40s-886915:temps.txt:1:`:m:`myname[1]: this is a msg`&#x20;
* Added `skipnone` qualifier primarily for `push()`. With `notnone` on `push()` `None` is flagged as an error; whereas, in some cases we just want to not push `None`s.&#x20;
* Support for the `distinct` qualifier in `string()`, `integer()`, `decimal()`, `date()`, `datetime()`

Other functions changes:&#x20;

* [New markdown docs](https://github.com/csvpath/csvpath/blob/main/docs/func_gen/index.md) generated from/by the functions. E.g. [https://github.com/csvpath/csvpath/blob/main/docs/func\_gen/advance.md](https://github.com/csvpath/csvpath/blob/main/docs/func_gen/advance.md). These docs are barebones, but always 100% up to date. The original function docs `.md` pages will be maintained but should not be considered the most current and/or correct.&#x20;
* `blank(name|header)` and `wildcard()` support `Any` in actuals, including `None`&#x20;
* `put()` support added for `dict`, `list`, `date`, `date` `time`, and `None`

Added `project` and `project_context` args to the `CsvPath` `__init__` in order to populate logger name fields.

### **0.0.576 - 7 dec 2025**

#### Major changes

* JSONL now available with all backends
* External custom functions are found before internals, allowing overriding
* 13 new CsvPath Validation Language functions. See the CLI functions look up for usage.
  * `headers_stack()`: returns the names of the current headers
  * `clear(var|var-name)`: removes a variable
  * `index_of(stack-var|stack-name, value)`: returns the int position of the value
  * `track_any()`: tracks typed values, optionally collecting values in a stack or summing them
  * `roll(date|datetime, number, unit-name)`: returns a date/datetime that is N-units in the future or past
  * `day(date)`: returns the date of the month as an int
  * `month(date)`: returns the month of the year as an int
  * `year(date)`: returns the year as an int
  * `format_date(date|datetime, str)`: formats a date/datetime as a string
  * `fingerprint(Optional[Header], ...)`: returns the hash of the line or the indicated header values
  * `format(str-value, str-format)`: formats a value according to a Python string template
  * `interpolate(str-value, str-format)`: formats a value within a longer string using Python formatting&#x20;
  * `xpath(xml-str, xpath-str)`: extracts a value from an XML document using an XPath expression&#x20;

#### Fixes and Updates

* 15 function updates:&#x20;
  * Number of times `reset_headers()` has been called and on what lines tracked in variables
  * Wildcard max length in `string()` using `none()`
  * `track()`: added 3rd arg `add` or `collect`, essentially the same function as for `track_any()`
  * `push()` and `get()` now able to take both stack vars and stack var names.
  * `get(x)` creates and returns a dict var if the variable named x is not found
  * Added an optional default arg to `get()`
  * `concat()` able to take a stack var of values to concatinate
  * Apply `regex()` to all headers using the `headers()` function like: `regex( headers(), /…/ )`&#x20;
  * `size()` now takes the `notnone` qualifier and either a stack var or name of a stack var
  * `eq()`  accepts None-valued vars, as well as `none()`
* Other minor user-facing changes&#x20;
  * Removed function name limitations disallowing numbers, '\_', and '.' after an inital alpha char.&#x20;
  * Made an alias to header\_names\_mismatch for clarity.
  * Added ability for transfer mode to append, rather than overwrite, using a target path ending in `+`
