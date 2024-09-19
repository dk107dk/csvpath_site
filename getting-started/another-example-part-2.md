# Another Example, Part 2

In this second part of the orders data file example we are going to modify our csvpath and its Python runner to be more automation and management friendly. &#x20;

## Requirements

First let's call out the requirements. What are we trying to achieve?

* Separate the code from the csvpath
* Break down the validation rules
* Give ourselves more options for reporting and error handling
* Set ourselves up for making references to other data for lookups

Let's say more.

#### Separate the code

Separating the code from the csvpath is straightforward. We don't want to colocate the csvpath in a Python variable. That constrains our formatting choices, complicates updates and the code, and makes the solution single use. We don't want to keep that physical file reference built into the csvpath, either. Our ideal root for our path is this:

```xquery
$[*]
```

#### Componentize the csvpath rules

Secondly, having our six validation concerns in one file makes us work harder in development. With six rules you have to take all of them into account when you test your csvpath. Writing and testing one rule at a time, sepaately, is simpler. Our solution, ideally, should let us have six csvpaths that we can run and manage as a group.&#x20;

#### Capture print statements and errors

Third, printing validation messages is an excellent way to do data validation. This kind of reporting may seem simple, but simple is good. That said, could we wish for more control over the output? Sure. We might want to craft an email or some other kind of report. It would be nice to be able to do that without scraping the command line.&#x20;

Likewise with error handling. We'll test our csvpath, of course! But at runtime things happen. And keep in mind that the data may change—we don't control that. So we'd like error handling that is robust with outputs that are inspectable.&#x20;

#### References to other data

Finally, our csvpath doesn't currently refer to outside data, but it could. And, given what the data is, there is a strong possibility that in a real scenario we would want to check UPCs or company names, or other things against known-good values. To do that we need our references to be able to find other data sets. The way our script is currently set up, we can't do that.

## The Solution

We're going to use a CsvPaths instance. CsvPaths is a manager class. It organizes CSV files, csvpath strings, and CsvPaths instances and their run results.&#x20;

A CsvPaths instance creates an instance of CsvPath for each csvpath it runs. It has managers to find files, sets of csvpaths to run, and capture the results of runs. And it gives you options that let you decide the best way to run multiple csvpaths for your situtation. &#x20;

As you may already know from other pages, the main difference in setting up a CsvPaths instance is that you need to point its managers to your files. Your results live in the Results Manager. You access them using the same name as you used for the paths that created the results.&#x20;

That's about it. Easy!

## The Python

In this second part of the example, we're going to change our csvpath string more than the Python code. But the Python motivates our changes to the csvpath. So let's start with the Python.

Create a new directory and make a Python file with the contents below. Also create a `cvspaths` directory and a `csvs` directory.

```python
from csvpath import CsvPaths

paths = CsvPaths()
paths.files_manager.add_named_files_from_dir("csvs")
paths.paths_manager.add_named_paths_from_dir(directory="csvpaths")

paths = CsvPaths(print_default=False)
LogUtility.logger(paths, "warn")

name = "metadata"
#name = "reset"
#name = "file_length"
#name = "categories"
#name = "prices"
#name = "sku_upc"
lines = paths.fast_forward_paths(filename="March-2024", pathsname=name)

print(f"lines: {lines}")

valid = paths.results_manager.is_valid(name)
print(f"is valid: {valid}")
```

None of this is complicated stuff. Let's go through it.

### Printing and logging

First we import the CsvPath library and create an instance of `CsvPaths`. We create it with `print_default=False`.

`print_default=False` prevents the `CsvPath` instances that run your csvpaths from printing to the default command line `Printer`. Your print statements will still be captured and available with your results from the `ResultsManager`. By default both things would happen: you would see results on the command line and you would also get print statements with your results.&#x20;

Now that you've seen  `print_default=False`, go ahead and delete it. We'll want to see the output in the terminal, at least at first.

Next, we do another completely optional thing: set the logging level. We're just seeing how to do it, for future reference. Out of the box, CsvPath is already set to `warn` by default. You can [read more about setting up logging and error handling policies here](../topics/debugging.md).

### Named-files, named-paths, named-results

On to more important things. First, we set up the named files and named paths. Named-files are just short names that point to full filesystem paths. They are convenient and help you keep your CSV files organized.&#x20;

Named-paths are more interesting. These are sets of csvpaths strings that can be run as a group. You set them up by one of:

* Creating a dict in Python
* Pointing to a directory full of csvpath files
* Pointing to a file that contains multiple csvpaths strings

When we're done with Part 2 of our orders file example, we're going to have the last one—multiple csvpaths in a single file. You can [read more about names here](../topics/named\_files\_and\_paths.md). But we'll start with separate files.

### The fast\_forward\_paths() method

After we set up the named files and named paths we have CsvPaths do `fast_forward_paths()`. This is similar to the `fast_forward()` method we called on our `CsvPath` instance in the first part of the example. The difference is that CsvPaths runs all the csvpaths in the named-paths you are using. That's CsvPaths's job: running multiple csvpaths and CSV files.

With `fast_forward_paths()` CsvPaths runs your csvpaths serially. That means a few things:&#x20;

* Order is guaranteed&#x20;
* Results of earlier csvpaths are available for later csvpaths to use
* Every row is seen before the next csvpath is run, making side-effects like `print()` simpler
* Every csvpath has to iterate on the same CSV file, which is not the most efficient way

There is an equally simple to use fast forward method that run the csvpaths breadth-first: `fast_forward_by_line()`. That method solves the efficiency problem. But let's leave it as a topic for another time.

At the bottom of the Python we pull the results from the results manager using the same name as our named-paths name. We store them under the same name because the results are the result of running those csvpaths.

## Improving Our Csvpath

The cool part happens over in the csvpath.

We want to achieve a few things.&#x20;

* Easy development of independent rules
* Separated results, printouts, and error handling&#x20;
* Overall better flexibility

We're going to do this by creating six csvpaths, in place of the one we have now. When we're done we'll have the option of putting them all in one file or in multiple files in one directory.&#x20;

There's only one real challenge with breaking down our big csvpath into multiple little ones. It is a challenge that is specific to this example. The challenge is the top-matter that precedes the data in our CSV file.&#x20;

Each csvpath has to handle the top matter. It definitely complicates things. That why we used it as the example! We're talking about this part:&#x20;

```xquery
~ Capture metadata from comments ~
    starts_with(#0, "#") -> @runid.notnone = regex( /Run ID: ([0-9]*)/, #0, 1 )
    starts_with(#0, "#") -> @userid.notnone = regex( /User: ([a-zA-Z0-9]*)/, #0, 1 )

    skip( lt(count_headers_in_line(), 9) )

~ Reset the headers when we see the full set ~
    @header_change = mismatch("signed")
    gt( @header_change, 9) -> reset_headers()

~ Print the line number of the header reset in case we need to check ~
    print.onchange.once(
        "Line $.csvpath.count_lines: number of headers changed by $.variables.header_change", skip())
```

Since this part came first in our csvpath and shielded all the remaining match components below it, we need a way to give that same shielding to our match components in their individual csvpaths. And we don't want to repeat this code six times.&#x20;

The answer is to use the `import()` function. We can import this fragment into our other csvpaths to get the same effect without cut-and-paste. Creating an importable csvpath is simple because its just a  csvpath. Create a file named `top_matter_import.csvpath`. Copy in this csvpath and you're done:&#x20;

```xquery
~ reset headers when they go up and 
  otherwise if there aren't enough headers 
  just skip ~

$[*][
    @header_change = mismatch("signed")
    gt( @header_change, 9) -> reset_headers()
    lt(count_headers(), 9) -> skip()
]
```

{% file src="../.gitbook/assets/top_matter_import.csvpath" %}

We're going to create six more csvpaths files. Most will import this one. No reason to go slow since you've already created these once in a single file, so here we go.

```xquery
---- CSVPATH ----

$[*][

    starts_with(#0, "#") -> @runid.notnone = regex( /Run ID: ([0-9]*)/, #0, 1 )
    starts_with(#0, "#") -> @userid.notnone = regex( /User: ([a-zA-Z0-9]*)/, #0, 1 )

    and( @runid, @userid ) ->
        print(" Contact: $.variables.userid for batch ID: $.variables.runid", stop())

]
```

&#x20;

{% file src="../.gitbook/assets/metadata.csvpath" %}

Wait, what's that `---- CSVPATH ----` block? I'm glad you asked. It is a separator between csvpaths that live in the same file.  It is of course completely optional at this stage because we're using multiple files with one csvpath in each. Doesn't hurt to have it there, though.

```xquery
---- CSVPATH ----
~ print the line number when we reset headers ~

$[*][
    import("top_matter_import")

    print.onchange.once(
        "Line $.csvpath.count_lines: number of headers changed by $.variables.header_change", stop())
]
```

{% file src="../.gitbook/assets/reset.csvpath" %}

You may have noticed that these csvpath files have more comments outside the csvpath itself. These comments are important. While we're not doing anything with them at the moment, we could add metadata fields that describe the csvpath. If you add an `ID` or a `name` field you can use it to reference the individual csvpath, even if it is bundled with others under the same named-paths name. We'll look at how to do that another time.

```xquery
---- CSVPATH ----

~ Check the file length ~
$[*][
    import("top_matter_import")

    below(total_lines(), 27) ->
      print.once("File has too few data lines: $.csvpath.total_lines", fail_and_stop())

]
```



{% file src="../.gitbook/assets/file_length.csvpath" %}

```xquery
---- CSVPATH ----
~ Check the categories ~

$[*][
    import("top_matter_import")

    not( in( #category, "OFFICE|COMPUTING|FURNITURE|PRINT|FOOD|OTHER" ) ) ->
        print( "Line $.csvpath.count_lines: Bad category $.headers.category ", fail())
]
```

{% file src="../.gitbook/assets/categories.csvpath" %}

Two more csvpaths to go!

```xquery
---- CSVPATH ----

~ Check the prices ~
$[*][
    import("top_matter_import")

    not( exact( end(), /\$?(\d*\.\d{0,2})/ ) ) ->
        print("Line $.csvpath.count_lines: bad price $.headers.'a price' ", fail())
]
```

{% file src="../.gitbook/assets/prices.csvpath" %}

```xquery
---- CSVPATH ----

~ Check for SKUs and UPCs ~
$[*][
    import("top_matter_import")

    not( #SKU ) -> print("Line $.csvpath.count_lines: No SKU", fail())
    not( #UPC ) -> print("Line $.csvpath.count_lines: No UPC", fail())
]
```

{% file src="../.gitbook/assets/sku_upc.csvpath" %}

There, that's all of them. You should now have seven .csvpath files in your csvpaths dir.

<figure><img src="../.gitbook/assets/all-csvpaths.png" alt="" width="375"><figcaption></figcaption></figure>

Back to your modified script. Here's where we left it. From this you can run any of the csvpaths files you just created. Each file will be named (minus its extension) in the named-paths manager. Just uncomment each name to run that file's csvpath by itself.

```python
from csvpath import CsvPaths

paths = CsvPaths()
paths.files_manager.add_named_files_from_dir("csvs")
paths.paths_manager.add_named_paths_from_dir(directory="csvpaths")

name = "metadata"
#name = "reset"
#name = "file_length"
#name = "categories"
#name = "prices"
#name = "sku_upc"
paths.fast_forward_paths(filename="March-2024", pathsname=name)

valid = paths.results_manager.is_valid(name)
print(f"is valid: {valid}")
```

The results should be completely unsurprising. These are just the same csvpath steps we created in Part 1. They are just pulled apart for easier development management.&#x20;

## One File Or One Directory

Now the big question: do we want all the working csvpaths in one file or one directory or to create a JSON file to describe groups of csvpaths that are used together? So many options! In fact there are four. For clarity:&#x20;

* Single files that contain a mix of Python and CsvPath—kind of like mixing SQL and Python
* A single csvpath containing a group of csvpaths separated by `---- CSVPATH ----` markers
* A directory of csvpath files imported under their own names (minus extension) or a single name provided by the user
* A JSON file containing a dictionary of named lists, where each item in the list is the path to a csvpath

Before we go into this, let's look at the JSON option.   &#x20;

```json
{
    "orders": [
        "csvpaths/metadata.csvpath",
        "csvpaths/file_length.csvpath",
        "csvpaths/reset.csvpath",
        "csvpaths/categories.csvpath",
        "csvpaths/prices.csvpath",
        "csvpaths/sku_upc.csvpath",
    ],
    "top_matter", [
        "csvpaths/top_matter_import.csvpath"
    ]
}
```

You would run our orders csvpaths using Python like this:&#x20;





Having six files with one csvpath each is obvious and easy to do without an example. A more important consideration, though, is that loading a named-path as a directory of separate files has a drawback. The drawback is that order is not deterministic. Order matters in CsvPath, including, sometimes, the order of executing multiple csvpaths. That's not always the case, and it isn't the case here. The order within our csvpaths matters because the top-matter handling match components need to come first. However, because we import the match components that handle the top-matter we don't have to worry about that. Still, it is a good thing to keep in mind.

Instead let's put the csvpaths in one `orders.csvpath` file in the `examples/complex_headers/csvpaths` directory we used above. And, actually, while we could use just one file, in order to facilitate our `import()`, let's make it two files.

`orders.csvpath` should look like this:&#x20;

```xquery
---- CSVPATH ----

~ description: Check correct category ~
$[*][
    import("skip_top_matter")

    not( in( #category, "OFFICE|COMPUTING|FURNITURE|PRINT|FOOD|OTHER" ) ) ->
        print( "Bad category $.headers.category at line $.csvpath.count_lines ", fail()) ]

---- CSVPATH ----

~ description: Correct price format? ~
$[*][
    import("skip_top_matter")

    not( exact( end(), /\$?(\d*\.\d{0,2})/ ) ) ->
       print("Bad price $.headers.'a price' at line  $.csvpath.count_lines", fail()) ]

---- CSVPATH ----

~ description: Missing product identifiers ~
$[*][
    import("skip_top_matter")

    not( #SKU ) -> print("No SKU at line $.csvpath.count_lines", fail())
    not( #UPC ) -> print("No UPC at line $.csvpath.count_lines", fail()) ]

---- CSVPATH ----

~ description: Too few lines
~
$[*][
      below(total_lines(), 27)
      last.onmatch() ->
            print("File has too few lines: $.csvpath.count_lines.
                Contact $orders.variables.userid about this batch:
                $orders.variables.runid at $.csvpath.file_name..", fail()) ]

```

And `skip_top_matter.csvpaths` should look like this:&#x20;

```xquery

starts_with(#0, "#") -> @runid.notnone = regex( /Run ID: ([0-9]*)/, #0, 1 )
starts_with(#0, "#") -> @userid.notnone = regex( /User: ([a-zA-Z0-9]*)/, #0, 1 )
skip( starts_with(#0, "#"))
skip( lt(count_headers_in_line(), 9) )

~ Warn when the number of headers changes ~
@hc = mismatch("signed")
gt(@hc, 9) ->
    reset_headers(
        print("Resetting headers to: $.csvpath.headers.."))

    print.onchange(
        "Number of headers changed by $.variables.hc.",
            print("See line $.csvpath.line_number..", skip()))

```

Put them both in that same directory. Both will be imported by CsvPaths's PathsManager when we pass it the directory path. As I'm sure you guessed, if you didn't already know, the csvpath separator is `---- CSVPATH ----`.

Now, assuming our orders file is where we're expecting it, `examples/complex_headers/csvs/March-2024.csv`, these two lines provide the lightning.&#x20;

```python
paths.fast_forward_paths(pathsname="orders", filename="March-2024")

results = paths.results_manager.get_named_results("orders")
```

Notice that we are running just the `orders` named-paths, not our top-matter csvpath. The latter is executed once per each of the five `orders` csvpaths.

The rest is just pulling the results from the ResultsManager and iterating them to see the print lines and do whatever else we need to do. Or if we just need the indicator of if the file is valid for all the csvpaths, the results manager can give us that go/no-go too.&#x20;

And that's it. An automation-friendly rule set using a pattern that will scale to any size operation.
