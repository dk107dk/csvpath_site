---
description: Like Schematron, only more delightful
---

# Validating XML Using XPath

Using XPath to validate XML in the Framework means combining a potentially trivial CsvPath Validation Language path with XPath applied using the `xpath()` function. This mode of XPath embedded in another language is exactly how (ISO standard) Schematron works. The difference is that here we use CsvPath Validation Language as the driver, not XML and, most commonly, XSLT. Other languages that Schematron has been implemented in include Java, Node, XQuery, and more.&#x20;

The practical difference of using a CsvPath Validation Language driver is that:

* The syntax is more readable than Schematron is
* The XPath statements or groups of statements can potentially be applied along side csvpath statements and/or in sets of statements composed for reuse, serial or breadth-first execution, replayability, etc.&#x20;
* You work in a fully awesome preboarding workflow with automatic metadata capture, immutable data, lineage, etc.

What you give up is the ability to output validation reports in HTML, FO, or other complex formats. At least today, CsvPath Framework's reporting, while quite powerful and flexible, is text only. (Markdown is easy, creating HTML is not so easy). For many purposes, though, that is a good tradeoff.

### Examples

Let's look at a few simple examples.

For starters, let's pull out a value from an XML document. This is a good basis line to explore validation from.

```python
        path = CsvPath()
        path.parse(
            f"""
            ~ validation-mode:raise, print ~
            ${PATH}[*][
                @s = xpath("<xml><is>great</is></xml>", "/xml/is")
            ]"""
        )
        path.fast_forward()
        assert "s" in path.variables
        assert path.variables["s"] == "great"

```

In this csvpath driver we are reading a file, presumably CSV or JSONL, but it could be XSLT or a DataFrame. However, because this is a simple example we drop an XML blob right in the csvpath where we can see it.&#x20;

`"<xml><is>great</is></xml>"` is of course a string. A string in csvpath statement terms is referred to as a `Term`. The xpath() function is comparing this XML in the first argument to an XPath in the second argument. If we wanted to compare a header from the doc, instead of a literal Term value, we would do something like one of these:

```powerquery
@s = xpath(#myxml, "/xml/is")
@s = xpath(#2, "/xml/is")
@s = xpath(@myxml, @myxpath)
```

The first looks at the value of the `myxml` header. The second looks at the 3rd header (0-based). And the 3rd csvpath looks at two variables, the first containing XML and the second containing XPath. These are just examples. We're haven't looked at the input document headers, but we're assuming there is one called `myxml` and it's the 3rd header. And we obviously didn't set up the two variables `myxml` and `myxpath`.&#x20;

The value of `@s` ends up being `"great"`.

Now let's validate

### XPath Validation

What we want to do is assert things about an XML doc. Let's switch to a CsvPaths instance — i.e. we're going to use the preboarding framework, not just do a one off programmatic validation, as we did above. We'll start just by grabbing some data, same as above.

Here's the data:&#x20;

```xml
<test>
    <zoo>
        <animal unknown='false'>Generic Bird</animal>
        <animal unknown='true'>Some kind of spotted cat</animal>
        <animal unknown='true'>A bear-like critter</animal>
    </zoo>
</test>
```

And here's our not-a-validator-yet XPath:

```javascript
$[0][ @animals = xpath("//animal[@unknown='true']") ]
```

What we're doing here is setting the `@animals` variable to the value of the two `<animal>` that are marked as unknown. We'll collect those two values in a list. That's obviously not a determinist test, yet.

```python
from csvpath import CsvPaths

class Example:

    def my_example(self) -> None:
        paths = CsvPaths()
        paths.paths_manager.add_named_paths_from_file(name="insert", file_path=PATH)
        paths.file_manager.add_named_file(name="insert", path=FILE)
        paths.collect_paths(pathsname="insert", filename="insert")
        results = paths.results_manager.get_named_results("insert")
        assert len(results) == 1
        result = results[0]
        assert result.errors_count == 0
        #
        # unless we set the csvpath to invalid within the csvpath, or 
        # automatically on built-in validation runs being triggered 
        # by setting validation-mode:fail, our run is valid by default.
        #
        assert result.is_valid is True
        variables = result.csvpath.variables
        assert "animals" in variables
        #
        # both unknown animals: node-sets of multiple nodes return a list
        #
        assert variables["animals"] == ["Some kind of spotted cat", "A bear-like critter"]
```

To make this a deterministic test, all we have to do is update the XPath:

```javascript
$[0][ @animals = xpath("//zoo[count(animal[@unknown='true']) = 2]") ]
```

This time `@animals` is `True`. At the moment we're just grabbing the value into the `@animals` variable and presumably checking it after the run in Python.

To take that up a notch, we can do the test within the statement. Typically we'll use a when-do expression to either:&#x20;

* Fail the run with `fail()`, making the is\_valid property `False`
* `print()` an error message (with or without failing the run)
* Print an `error()` message, which will also trigger a run failure if we set `validation-mode: fail`
* Stick with the `@animals` variable and do our test on it

And to be sure there are other options. These are just the most common. They look like the following, respectively:

```javascript
$[0][ 
    ~ 1. ~
    xpath("count(//animal[@unknown='true']) != 2") -> fail() 
    ~ 2a. ~
    xpath("count(//animal[@unknown='true']) != 2") -> print("There should be 2 unknown animals")     xpath("count(//animal[@unknown='true']) != 2") -> print("There should be 2 unknown animals") 
    ~ 2b. ~
    xpath("count(//animal[@unknown='true']) != 2") -> print("There should be 2 unknown animals", fail())     xpath("count(//animal[@unknown='true']) != 2") -> print("There should be 2 unknown animals") 
    ~ 3. ~
    xpath("count(//animal[@unknown='true']) != 2") -> error("There should be 2 unknown animals")     xpath("count(//animal[@unknown='true']) != 2") -> print("There should be 2 unknown animals") 
    ~ 4. ~
    @animals = xpath("count(//animal[@unknown='true']) != 2") 
    @animals.asbool -> fail()        
    
    ~ as explained below, both of these last 2 functions, 
    collect_original() and stop(), are optional, but helpful ~

    collect_original()
    
    ~ you can only use xpaths() that run against whole
    documents one time, so you either need to using a single 
    line scanning instruction (which we are doing) or you need 
    to use the stop() function to end after one iteration.  
    Obviously you don't need both, but just as an example 
    we'll add the stop() ~ 
    
    stop()
]
```

&#x20;And keep in mind, the statement above is completely legal, if not efficient or commonsensical. You can have as many XPath statements in your csvpath statement as you need. Or add multiple csvpath statements to your named-paths group with one or more `xpath()`s in each. Again, there are many options.

One more thing to remember. When you are applying XPath statements to a whole document, as we did directly above, you must only look at one line. We know we're looking at the whole source data file as one XML document because we didn't point to a header containing XML content in just one field. Iterating through all the lines of an XML document would, of course, make no sense. The way you limit the run to one line is to either:

* Use the scanning instruction to pick out only one line — typically `[0]`&#x20;
* Use `stop()` at the end of your validation statement so that the run ends

We also used the `collect_original()` function to create a copy of our untouched originally register bytes over into the results directory as `original.xml`. That is optional, but often useful.

So there you have it. Validation using XPath isn't so different from using rules in CsvPath Validation Language. And compared to Schematron, this is lightweight and easy on the eyes. What's not to like?
