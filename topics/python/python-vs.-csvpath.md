# Python vs. CsvPath

The CsvPath Framework is developed in Python. Python provides the basic CVS parsing plumbing. We love Python! But — and you knew a _but_ was coming — straight-up Python is not the best tool for CSV and Excel preboarding.&#x20;

To be fair, let's up-front acknowledge that there are some situations where CsvPath may not be as competitive with just plain old Python: &#x20;

* Your CSVs and/or Excel files are ad hoc
* You have low expectations for correctness or only an occasional need to validate
* There is just one format
* Volume is low

In these cases, you _might_ benefit from CsvPath, but you don't _need_ it.&#x20;

CsvPath was written for automated daily batch processing, large scale data collection, and many or changing data formats with high fidelity requirements. If you have those challenges, _need_ is the better word — you _need_ CsvPath. If you find yourself or your colleagues checking the work of computers by hand, even more so! Sadly, we've seen that too often.

* [So why not Python?](python-vs.-csvpath.md#so-why-not-python)
* [Benefits of the CsvPath Framework](python-vs.-csvpath.md#benefits-of-the-csvpath-library)
* [How about that Python example?](python-vs.-csvpath.md#how-about-that-python-example)

## So why not Python?

The problems with doing CSV validation in Python include:

* More code — in the example below the Python is \~200% of the CsvPath
* Less readable — we want more people contributing to getting the rules right, not just _that_ developer. While Python is readable, it is programming logic, not simple, declarative validation primitives. The more concise and self-documenting, the better.
* Lack of guardrails — Python is a general purpose language to do anything, CsvPath is function-specific. This means long term your CsvPaths will drift less and hew to good patterns more.
* Higher test burden — we would advocate putting your test effort into testing the constantly changing data, not the more constant code that processes it. CsvPath helps you do that by taking on much of the testing burden.

Those are good reasons. They are about CsvPath, the language.&#x20;

In retrospect, the reference implementation, the Python library, probably should have had a different name. (Yeah, there may never be another implementation of CsvPath, but we aspire to a Rust version, so who knows?)

## Benefits of the CsvPath Framework

The CsvPath _Framework_ brings a wealth of additional reasons to choose CsvPaths for data preboarding over rolling your own Python solution. Some of those features are delivered transparently or with minimal effort. Others are essentially hooks for application developers to weave CsvPath into their DataOps environment.&#x20;

Some of those capabilities include:

* Flexible error handling policies
* Programmatic, config, and csvpath-driven logging
* Printout capture and other reporting features
* Data lines matching and capture
* Metadata and runtime data capture &#x20;
* File metrics caching and file nicknames&#x20;
* Data exchange between csvpaths
* Validation strategies that speed performance, offer chain-of-responsibility patterns, etc.
* Multiple ways to organize csvpaths to suit different ways of managing validation

Lots of good stuff. Not everyone needs all that, but it's there. If you are a DataOps, DevOps, or data processing application developer some of that has got to sound interesting.

## How about that Python example?

In [Another Example, Part 1](../how-tos/another-example-part-1.md) and [Another Example, Part 2](../how-tos/another-example-part-2.md) we created a CsvPath validation for a simplified retail goods order file. The rules were:&#x20;

* There would be top-matter to skip before the header line
* The top matter would include two metadata fields to capture
* The header line would have > 10 headers
* Every data line below the headers would have a price in a certain format in the last position
* There would be UPC and SKU values
* The value under the category header would match one of a list
* There would be more than 27 lines

This is not an unusual set of validation rules; although, we picked it because the top-matter is a good entry-level challenge.&#x20;

The resulting csvpath clocked in at \~60 lines, but with a ton of whitespace and comments. Minus the whitespace, about 30 lines. Since CsvPath is a declarative path language, more like SQL or XPath than Python, we could arbitrarily bring the number of lines down closer to 7, technically. But whitespace is free.

A just-get-it-done Python version came in at about 130 lines. Now, lines of code is not the main issue, but it's a first good indicator. More importantly, the readability is significantly lessened and the features for DataOps automation need to be recreated.&#x20;

But the thing that most makes the blood run cold: the lack of patterns and guardrails is immediately noticeable. If you think in terms of a partnership of any kind—commercial, government, research, what have you—you want to know your partner's code is disciplined and verified, not messy, siloed, and unloved. With CSVs the latter is too often the case.&#x20;

CsvPath Framework cannot fix that problem completely, but it is a good first step. When you look at the example code below, imagine you have files in 100 formats coming in daily. Now imagine 1000 formats for 1000 data partnerships. And now imagine the developers playing hot-potato with the CSV wrangling code. You get the idea.

And without further ado, here's the Python implementation to compare to [Another Example, Part 2](../how-tos/another-example-part-2.md). Put your DataOps engineering manager hat on and judge for yourself.  &#x20;

```python
import re
import csv

class ValidateOrders():
    # This just replicates the DSL. It doesn't include anything mirroring CsvPath's error handling, logging, etc. or, unit tests

    def __init__(self, delimiter=",", quotechar='"'):
        self.headers = []
        self.variables = {"header_change_msg":False}
        self.is_valid = False
        self.delimiter = delimiter
        self.quotechar = quotechar

    def _index_of_header(self, name):
        for i, h in enumerate(self.headers):
            if name == h.strip():
                return i
        return None

    def validate(self, filepath ):
        with open(filepath,"r") as file:
            reader = csv.reader(
                file, delimiter=self.delimiter, quotechar=self.quotechar)
            for i, line in enumerate( reader ):
                if len(line) == 0:
                    continue
                if self.headers == []:
                    self.headers = line
                if self._is_our_line(i):
                    self._validate_line(i, line)
                    if self._is_last(i):
                        break
            self._validate_line_count(i)
        return self.is_valid

    def _is_our_line(self, i):
        # in this case we are taking all the lines. (i.e. [*])
        # but i'm leaving the door open to limiting/selecting lines
        # to better match what csvpath can do
        return True

    def _is_last(self, i):
        # we don't need this because we're taking all lines, and
        # because in the Python version we have a programmatic exit
        # point at the end of the iteration. leaving it for parity.
        return False

    def _validate_line(self, lineno, line):
        # if one of the first two methods returns True we
        # skip the rest of the rules for this line
        #
        # in this case we expect metadata in a top-matter block
        if self._collect_metadata_if(line):
            return
        # after the top matter we expect a header row and then the main data
        if self._headers_reset_if(lineno, line):
            return
        # validations go here.
        self._check_categories_if(lineno, line)
        self._check_prices_if(lineno, line)
        self._check_sku_and_upc_if(lineno, line)

    def _headers_reset_if(self, i, line) -> bool:
        """ reset headers when they go up and otherwise, if there
            aren't enough headers, just skip. print the line number when
            we reset headers. """
        mismatch = len(line) - len(self.headers)
        if mismatch > 9:
            self.headers = line
            if not self.variables["header_change_msg"]:
                print( f"Line {i}: number of headers changed by {mismatch}")
                self.variables["header_change_msg"] = True
            return True
        return False

    def _collect_metadata_if(self, line) -> bool:
        """ collect metadata fields from comments """
        if line[0].strip().startswith("#"):
            m = re.search("Run ID: ([0-9]*)", line[0])
            v = None
            if m:
                v = m.group(1)
            if v:
                self.variables["runid"] = v
            if not v:
                m = re.search("User: ([a-zA-Z0-9]*)", line[0])
                if m:
                    v = m.group(1)
                if v:
                    self.variables["userid"] = v
            return True
        return False

    def _validate_line_count(self, lineno):
        """ Check the file length """
        if lineno < 27:
            print( f"File has too few data lines: {lineno}")
            self.is_valid = False

    def _check_categories_if(self, i, line):
        """ Check the categories """
        index = self._index_of_header("category")
        if line[index] not in ["OFFICE", "COMPUTING", "FURNITURE", "PRINT", "FOOD", "OTHER"]:
            print(f"Line {i}: Bad category {line[index]} ")
            self.is_valid = False

    def _check_prices_if(self, i, line):
        """ Check the prices """
        p = line[len(line)-1]
        m = re.search("\\$?(\\d*\\.\\d{0,2})", p)
        v = None
        if m:
            v = m.group(1)
        if not p or p != v:
            print(f"Line {i}: bad price: {p}")
            self.is_valid = False

    def _check_sku_and_upc_if(self, i, line):
        """ Check for SKUs and UPCs """
        index = self._index_of_header("SKU")
        if not line[index] and line[index].strip() != "":
            print("Line {i}: No SKU")
            self.is_valid = False
        index = self._index_of_header("UPC")
        if not line[index] and line[index].strip() != "":
            print(f"Line {i}: No UPC")
            self.is_valid = False

if __name__ == "__main__":
    vo = ValidateOrders()
    file = ""
    valid = vo.validate("March-2024.csv")
    print(f"File is valid: {valid}")


```

&#x20;

