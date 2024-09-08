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

```
$[*]
```

#### Componentize the csvpath rules

Secondly, having our six validation concerns in one file makes us work harder in development. With six rules you have to take all of them into account when you test your csvpath. Writing and testing one rule at a time, sepaately, is simpler. Our solution, ideally, should let us have six csvpaths that we can run and manage as a group.&#x20;

#### Capture print statements and errors

Third, printing validation messages is an excellent way to do data validation. This kind of reporting may seem simple, but simple is good. That said, could we wish for more control over the output? Sure. We might want to craft an email or some other kind of report. It would be nice to be able to do that without scraping the command line system out.&#x20;

Likewise with error handling. We'll test our csvpath, of course! But at runtime things happen. And keep in mind that the data may change—we don't control that. So we'd like error handling that is robust with outputs that are inspectable.&#x20;

#### References to other data

Finally, our csvpath doesn't currently refer to outside data, but it could. And, given what the data is, there is a strong possibility that in a real scenario we would want to check UPCs or company names, or other things against known-good values. To do that we need our references to be able to find other data sets. The way our script is currently set up, we can't do that.

## The Solution

We're going to set our validation up using a CsvPaths instance. CsvPaths is the manager of CSV files, csvpaths, and run results. It instantiates a CsvPath instance for each csvpath it runs. And it has its own managers to find files, sets of csvpaths to run, and capture the results of runs. &#x20;

As you may already know from other pages, the main difference in setting up CsvPaths is that you need to point its managers to your files. Second, you pull your results from the Results Manager using the same name as you used to run your paths. That's about it. Easy!

In this second part of the example, we're going to change our csvpath more than the Python code. At the same time, we need the Python runtime context to motivate our changes to the csvpath. So let's start with the Python.

```python
import csvpath

paths = CsvPaths(print_default=False)
LogUtility.logger(path, "warn")

paths.files_manager.add_named_files_from_dir("examples/complex_headers/csvs/")
paths.paths_manager.add_named_paths_from_dir("examples/complex_headers/csvpaths")
paths.fast_forward_paths(pathsname="orders", filename="March-2024")

results = paths.results_manager.get_named_results("orders")
for r in results:

    print(f"""\n\t Description: {r.csvpath.metadata["description"]}""")
    print(f"\t valid: {r.is_valid()}")
    print(f"\t errors: {len( r.errors)}")

```

#### Printing and logging

First we import the CsvPath library and create an instance of `CsvPaths`. We create it with `print_default=False`. This prevents the `CsvPath` instances that run your csvpaths from printing to the default `Printer`. Your print statements will still be captured and available with your results from the `ResultsManager`. By default both things would happen: you would see results on standard out and you would be able to get print statements with your results.&#x20;

Next we do another completely optional thing, set the logging level. This is here just so you know how to do it. Out of the box, CsvPath is already set to warn by default. You can [read more about setting up logging and error handling policies here](../topics/debugging.md).

#### Named-files, named-paths, named-results

After that, we set up the named files and named paths. Named-files are just short names that point to full filesystem paths. They are convenient. Named-paths are more interesting. They are sets of csvpaths that can be run as a group. You set them up by one of:

* Creating a dict in Python
* Pointing to a directory full of csvpath files
* Pointing to a file that has multiple csvpaths in it

When we're done we're going to have the last one. You can [read more about names here](../topics/named\_files\_and\_paths.md).

After we set up the named files and named paths we have CsvPaths do `fast_forward_paths()`. This is similar to the `fast_forward()` method we called on our `CsvPath` instance in the first part of the example. The difference is that CsvPaths runs all the csvpaths in the named-paths you are using. It runs them serially. There is an equally simple but different fast forward method to run the csvpaths breadth-first, but that's a topic for another time.

At the bottom of the Python we pull the results from the ResultsManager using the same name as our named-path name. We store them under the same name because the results are the result of running those csvpaths.

## Improving Our Csvpath

The cool part is over in the csvpath.

We want to achieve a few things.&#x20;

* Easy development of independent rules
* Separated results, printouts, and error handling&#x20;
* Overall better flexibility

We're going to do this by creating six csvpaths. When we're done we'll have the option of putting them all in one file or in multiple files in one directory.&#x20;

There's only one real challenge with breaking down our big csvpath into multiple little ones. That is the top-matter that precedes the data in our CSV file. Each csvpath will have to handle that. We're talking about this part:&#x20;

```
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

Since this part came first in our csvpath and shielded all the remaining match components below it, we need a way to give that same shielding to our match components in their individual csvpaths. And we don't want to repeat this code six times.&#x20;

The answer is to use the `import()` function. We can import this fragment into our other csvpaths to get the same effect without cut-and-paste. For example, our second rule becomes its own csvpath that looks like this:&#x20;

```

~ description: Check correct category ~
$[*][
    import("skip_top_matter")

    not( in( #category, "OFFICE|COMPUTING|FURNITURE|PRINT|FOOD|OTHER" ) ) ->
        print( "Bad category $.headers.category at line $.csvpath.count_lines ", fail()) ]

```

We added a couple of things:&#x20;

* A bit more documentation at the top. In this case we're capturing the description so it will be findable in the CsvPath metadata or by reference in a print statement.
* The import() that brings in the top-matter handling match components we looked at above.
* The root is now a "local" reference. $\[\*] refers to all lines in the current csvpath, but it doesn't say what csvpath it refers to. We leave that to CsvPaths and our named-paths setup.

We can run this csvpath independently to make sure it does exactly what we want. And we can do it using small known-good test files and version control it on its own. That's a good way to work. &#x20;
