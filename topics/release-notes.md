---
description: High-level descriptions of point releases
---

# Release Notes

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
