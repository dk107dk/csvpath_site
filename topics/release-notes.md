# Release Notes

### **0.0.576**&#x20;

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
