# Quickstart

This page gives you all the information you need to get started validating your CSVs with CsvPath. Happily, it's not a lot. You will want to go deeper on other pages later.

{% hint style="info" %}
If you need help getting started with Python, try [Python.org's intros](https://www.python.org/about/gettingstarted/). Starting with a project tool like [Poetry](https://python-poetry.org/docs/basic-usage/) or [Jupyter Notebooks](https://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/) can also help.
{% endhint %}

### PyPI and Github

The CsvPath library is available through [Py](https://pypi.org/project/csvpath/)PI as "csvpath". At this stage, pre 1.0, the project changes frequently. You should pin the version you use and update it methodically.&#x20;

You can check under the hood on [Github](https://github.com/dk107dk/csvpath). There are detailed docs that you can read in parallel or in addition to this site.

<div data-full-width="false">

<figure><img src="../.gitbook/assets/github-home.png" alt="" width="375"><figcaption></figcaption></figure>

</div>

### Let's run something!

The main class in CsvPath is unsurprisingly called CsvPath. For simple jobs, it is all you need.

To do a hello world path you'll need to import CsvPath, create an instance, and point it at a CSV file.

Create a script file and do the import:&#x20;

<figure><img src="../.gitbook/assets/import.png" alt="" width="375"><figcaption><p>Add CsvPath to your requirements.txt or dependency manger first, of course!</p></figcaption></figure>

```python
from csvpath import CsvPath
```

Create a test CSV file. Save it as trivial.csv or whatever name you like.

<figure><img src="../.gitbook/assets/csv.png" alt="" width="359"><figcaption></figcaption></figure>

{% file src="../.gitbook/assets/trivial.csv" %}

Make a csvpath. Also a trivial one, just to keep it simple.

<figure><img src="../.gitbook/assets/trivial-csvpath.png" alt="" width="563"><figcaption></figcaption></figure>

```python
csvpath = """$trivial.csv[*][yes()]"""
```

This path says: open trivial.csv, scan all the lines, match every one of them.

Next, run the csvpath against our CSV file.

<figure><img src="../.gitbook/assets/first_script (1).png" alt="" width="563"><figcaption></figcaption></figure>

{% code lineNumbers="true" %}
```python
from csvpath import CsvPath

csvpath = """$trivial.csv[*][yes()]"""

path = CsvPath()
path.parse(csvpath)
path.fast_forward()

print("Is this file valid?")
if path.is_valid:
    print("Yes! All good.")
else:
    print("No. Something is wrong with it.")

```
{% endcode %}

What does this script do?

* Line 1 imports CsvPath so we can use it
* Line 3 is our csvpath that we'll use to validate our test file, trivial.csv
* Line 5 creates a CsvPath instance that will do the validation
* Line 6 is where CsvPath reads our csvpath string to see how we describe valid lines. In this case, _yes()_ means that each line matches our csvpath.&#x20;
* Line 7 fast-forwards though the lines. We could also step through them one by one.&#x20;
* Line 10 checks if we consider the file valid. If the file didn't meet expectations our csvpath would have declared the file invalid using the _fail()_ function.&#x20;

When you run your script you should see something close to this:

<figure><img src="../.gitbook/assets/result.png" alt="" width="324"><figcaption></figcaption></figure>

No question that is far from impressive! Still, go with it. Small increments are good! You are now ready to dig in and see what CsvPath can really do.&#x20;
