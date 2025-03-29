# Loading

<figure><img src="../../../../../.gitbook/assets/Screenshot 2025-03-29 at 12.09.40 PM.png" alt=""><figcaption><p>Staging and loading</p></figcaption></figure>

Staging source data files is an easy task. You can register a single file name, a directory, or a JSON file containing name-to-file mappings.

```
from csvpath import CsvPaths
CsvPaths().file_manager.add_named_file( name="orders", path="./assets/files/orders.csv" )
```

Loading your csvpaths in a named-paths group is similarly easy. And again the options are loading a file with any number of paths, a directory of .csvpath files, or a JSON file defining the named-paths group.

```
from csvpath import CsvPaths
CsvPaths().paths_manager.add_named_paths_from_file( name="invoices", file_path="./assets/monthly-invoice-validations.csvpaths )
```
