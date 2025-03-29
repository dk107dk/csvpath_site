# Run Using the API

<figure><img src="../../../../../.gitbook/assets/Screenshot 2025-03-29 at 1.48.34 PM.png" alt=""><figcaption><p>Running a named-paths group against one or more files</p></figcaption></figure>

Runs of a named-paths group take one of six forms. Three run the csvpaths in the group in serial, one after another. The other three run the csvpaths in the group in a breadth-first manner, line-by-line. Each approach has its advantages; though, in practice you most often don't have a reason to choose one over the other.

Regardless or serial or breadth-first or serial, there are three main options:&#x20;

* `collect_paths()` — Collect each matching line (and optionally, separately collect unmatched lines)
* `fast_forward_paths()` — Collect none of the file data, but still collect variables, metadata, errors, and printouts, as well as optionally transferring files and firing alerts
* `next_paths()` — Iterate line by line through the file receiving back the matched lines

The method names above are for serial runs. For breadth-first runs the methods are `collect_by_line()`, `fast_forward_by_line()`, and `next_by_line()`.

```python
from csvpath import CsvPaths
CsvPath().fast_forward_paths( pathsname="orders", filename="acme-orders" )
```







