# Inspect Run Results

<figure><img src="../../../../../../.gitbook/assets/Screenshot 2025-03-29 at 1.49.17 PM.png" alt=""><figcaption><p>Inspecting the results of a named-paths run</p></figcaption></figure>

Results come from CsvPaths's ResultsManager. You ask for the results of a named-paths run by name or reference. The return is a list of Result objects. Each Result has the CsvPath object that generated it, along with all the data and metadata that was produced. By default, the ResultsManager returns the most recent run.

```python
from csvpath import CsvPaths
CsvPath().get_named_results( name="orders" )
```



