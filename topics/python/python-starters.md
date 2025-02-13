---
description: A few really basic scripts to get you started
---

# Python Starters

The CsvPath library was build to be easy. You can do a lot with very little Python scaffolding. Let's look at some code. Obviously, you can do better and have more stringent requirements. But starting from a blank page is harder than editing. As you get started you should probably keep [the Python public interface docs](https://csvpath.github.io/csvpath/csvpath.html) open in a tab.

## Simplest CsvPath Runner Ever

<pre class="language-python"><code class="lang-python"><strong>import sys
</strong>from csvpath import CsvPath

if __name__ == "__main__":
    with open(sys.argv[1]) as file:
        csvpath = file.read()
        path = CsvPath().parse(csvpath).fast_forward()
</code></pre>

The script above reads a file you give it as a command line argument. The file is a csvpath that must include the file it is being run against.  It might look like this:&#x20;

```
$my_test_file.csv[print("$.headers.firstname was born on $.headers.dob")]
```

After parsing the csvpath the script fast-forwards through all CSV lines. Any print statements or other side effects happen, as you would expect, and you don't have to iterate or collect the lines. If your csvpath marks the file invalid you can see that on the `is_valid` property of `path`.

## Iterating Matches

```python
import sys
from csvpath import CsvPath

if __name__ == "__main__":
    with open(sys.argv[1]) as file:
        csvpath = file.read()
        path = CsvPath().parse(csvpath)
        for line in path.next():
            print(f"{line}")
```

This script, like the first, takes a file path as a command line argument. In this case we are iterating on all the lines that match and printing them out.

## A Multi-csvpath Starter

[CsvPath AutoGen](https://autogen.csvpath.org/) typically auto-generates multi-csvpath validations based on your example data. These require a `CsvPaths` instance. Setting up CsvPaths is not very different.

```python
from csvpath import CsvPaths

if __name__=="__main__":
    paths = CsvPaths()
    paths.paths_manager.add_named_paths_from_file(name="autogen", file_path="assets/created_by_autogen.csvpath")
    paths.file_manager.add_named_file(name="usage", path="assets/usage_report_excerpt.csv")
    paths.fast_forward_paths(pathsname="autogen", filename="usage")
```

In this case we are setting up a number of csvpath statements that live in a single file. They will run against a usage report CSV. We do `fast_forward_paths` to run the csvpaths sequentially without collecting or iterating on the matched lines.

## An Airflow Stub

```python
from __future__ import annotations

import json
import pendulum
from airflow.decorators import dag, task
from csvpath import CsvPaths

@dag(
    schedule=None,
    start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    catchup=False,
    tags=["csvpaths validation"],
)
def validation_api():

    @task(multiple_outputs=True)
    def validate():
        paths = CsvPaths()
        paths.file_manager.add_named_files_from_dir("./example_2_part_2/csvs")
        paths.paths_manager.add_named_paths_from_dir(directory="./example_2_part_2/csvpaths")
        paths.collect_paths(filename="March-2024", pathsname="orders")
        results = paths.results_manager.get_named_results("orders")
        return {"valid":paths.results_manager.is_valid('orders'), "results_count":len(paths.results_manager.get_named_results('orders'))}

    validate()

validation_api()    
```

There's nothing notable about this Airflow stub. To, I'm sure, nobody's surprise, the CsvPath library fits well in an Airflow solution. This code is just a placeholder for the awesome Airflow things you will do.
