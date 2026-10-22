---
description: DataFrames are flexible and CsvPath Validation Language is onboard with that
---

# Validating DataFrames

As you know just from landing on this page, CsvPath Framework handles DataFrames validation. You have three complementary validation options for DataFrames:

* ODCS validation
* CsvPath Validation Langage (CVL)
* JSONPath

Each has different use cases and strengths. (The other three validation tools, XSD, JSON Schema, and XPath, are not as likely to be useful with DataFrames).

### Why Use CsvPath Framework With DataFrames?

There are many good options for validating your data frames, including CsvPath Framework. Why might you want to use the Framework?

* The option to combine validation approaches — use the Framework's native validation, JSONPath, or ODCS
* Modularity — layer rules and validation languages in separate files in a named-paths group that can be applied as a unit
* The integration with OpenLineage and OpenTelemetry — DataFrames passing through pipelines especially benefit from the visibility and traceability
* Consistent validation strategies across types and locations — your DataFrames can be handled exactly the same as your API endpoints and file feeds
* Tons of metadata capture, process transparency, and workflow options, if you need it
* Simplicity and flexibility with significantly less risk of drift and spaghetti code across the whole data estate&#x20;

That's a lot. But let's start by just seeing a simple example

{% hint style="info" %}
Remember that Pandas support is an optional extra that you must explicitly include in your Python project, through the Framework's extras or directly yourself. It is handled that way to make the Framework lighter and more installable in environments that don't support native code in Python libraries.
{% endhint %}

### Show Me How

We'll use the same basic example as on the JSONPath validation page. It helps illustrate how CVL and JSONPath work together.&#x20;

{% code lineNumbers="true" %}
```python
import tempfile

import pandas as pd

from csvpath import CsvPath
from csvpath.util.file_readers import DataFileReader

JSONL = [
    {"animals": {"fish":"blue", "gull":"blackback"}, "domain": "sea"},
    {"animals": {"snake":"green","rodent": "mouse"}, "domain": "underground"},
    {"animals": {"elephant":"indian", "panther":"black"}, "domain": "land"},
]

def run(path:CsvPath=None, jsonl:list=None):
    """ we could pass a JSONL structure in but we'll just use the
      prepared demo data """
    jsonl = jsonl if jsonl else JSONL
    
    """ if we were rerunning lots of dataframes with the same validation
      we could save reparsing by just rewinding the CsvPath instance. """
    if path:
        path.rewind()
    else:
        path = CsvPath()
    
    """ load our JSONL objects into a dataframe. obviously this data could
      come from a file, but not in this example """
    df = pd.DataFrame(jsonl)
    
    """ register the data so the CsvPath instance can find it. Note that 
      this is not data preboarding registration, we're just making the
      the data available for a moment, not capturing it in a versioned]
      immutable store with metadata production and lineage events. that
      is a whole different thing that you can definitely do, but not in
      this example. """
    DataFileReader.register_data(path="my_df", data=df, shape="jsonl")

    """ we're going to use CVL + JSONPath for this example. ODCS is an 
      equally straightforward option. """
    statement = """
        ~validation-mode:print, raise~
        $my_df[*][
            rename(#0, "animals")
            @fish = jsonpath(#animals, "$.fish")
            row_table()
            exists(@fish) -> print("fish exists! $.variables.fish")
            exists(@fish)
        ]"""
        
    """ here's the validation run """
    lines = path.collect(statement)

    """ and here we check if we got what we were looking for """
    if len(lines) == 1:
        print("There are fish.")
    elif len(lines) < 1:
        print("No fish!")
    else:
        print("Too many fish!")
    if not path.is_valid:
        print("There must be fish")

if __name__ == "__main__":
    run()
```
{% endcode %}

This is pretty basic stuff. If you strip out the comments and fluff, it comes down to more or less just this:&#x20;

```python
    path = CsvPath()
    df = pd.DataFrame(jsonl)
    DataFileReader.register_data(path="my_df", data=df, shape="jsonl")
    path.collect(statement)
    assert path.is_valid
```

Seven lines + a bit of CVL

### How Does the CVL Work?

Let's look at that CVL statement more closely. This is a good, small example of CsvPath Validation Langage's flexibility and debugging tools.

{% code lineNumbers="true" %}
```javascript
~ validation-mode:print, raise ~
$my_df[*][
    rename(#0, "animals")
    row_table()
    
    @fish = jsonpath(#animals, "$.fish")
    exists(@fish) -> print("fish exists! $.variables.fish")
    exists(@fish)
]
```
{% endcode %}

When we ingest our JSONL into a DataFrame we capture the animals header's JSON value, but Pandas drops the name `animals`. That's fine for us, we can just use `#0` to address that header by index, instead of name. But why not put that header back so we can make a more explicit reference to the header? Easy to do with `rename()`.&#x20;

Next, on line 4, we can use `row_table()` to get a nice printout showing what each line looks like. That can be useful in a report, but here we're just using it to get comfort with how the DataFrame translated our data. Our first line reports:&#x20;

```
┌───────────────────────────────────────┬─────────────┐
│ #animals (#0)                         │ #sea (#1)   │
├───────────────────────────────────────┼─────────────┤
│ {'fish': 'blue', 'gull': 'blackback'} │ sea         │
└───────────────────────────────────────┴─────────────┘
```

That immediately tells us two things.&#x20;

* We got the data and headers we would expect
* JSONPath could be helpful to extract information from `#animals`!

On line 6 we grab the information that determines if we validate or not. The @fish variable takes the value found by the jsonpath() function. On line 7 we print a message if we find a fish, but just as a debugging check.&#x20;

The real validation happens on line 8. Here we accept any line where a fish existed. The validation strategy we're taking in this example is that the data is valid if there is a fish in the dataset. Otherwise, if there are too many or not enough fish the data is invalid. But we could also do something like:&#x20;

```javascript
exists(@fish) -> counter.have_fish()
and( last(), @have_fish == 0 ) -> fail()
```

This would check that `path.is_valid` is `True`. Or you could taken one of many other validation strategies. There's a lot of flexibility to validate however works best for your use case.&#x20;

### How Simple Can The CVL Be?

Ultimately our CVL really boils down to just:&#x20;

{% code lineNumbers="true" %}
```javascript
$my_df[*][
    rename(#0, "animals")
    @fish = jsonpath(#animals, "$.fish")
    exists(@fish)
]
```
{% endcode %}

The `~ validation-mode:print, raise ~` is good practice, just to be explicit. But since the default is that built-in validations are always printed and exceptions raised noisily, it isn't needed, if those are the options you want. (In practice, outside of development and debugging `no-raise` is probably a good idea).&#x20;

And just for fun, we can boil the ocean down to:

{% code lineNumbers="true" %}
```javascript
$my_df[*][exists(jsonpath(#0, "$.fish"))]
```
{% endcode %}

Or, if we only care if there is a `sea` in the `domain` header on at least one line we could do:&#x20;

{% code lineNumbers="true" %}
```javascript
$my_df[*][ #domain == "sea" ]
```
{% endcode %}

And that's how easy it is to validate a DataFrame. Give it a shot.
