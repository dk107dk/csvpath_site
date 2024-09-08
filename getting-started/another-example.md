---
description: >-
  Some CSV files have documentation or other ancillary data at the top, above
  the main data lines. This  want to skip that noise. Our goal is to validate
  just the regular rows below the line of headers.
---

# Another Example

Some CSV files have documentation or ancillary data at the top, above the main data lines. When that happens, it complicates recognizing and handling headers correctly and validation difficult in other ways. Let's take a look at an example.&#x20;

<figure><img src="../.gitbook/assets/data-before.png" alt=""><figcaption></figcaption></figure>

There are so many things to validate here. Types of products, IDs, prices. Just sticking with simple checks we could come up with many rules. We'll create a csvpath that applies six rules while dealing with the complicating top-matter.

When our csvpath sees this prolog it has some challenges. It needs to:

* Recognize that the header line is line 9 (0-based)
* Discard the lines that are comments, unless
* We want to capture some of that information

Doable? Absolutely!

Let's try doing it without just skipping the top 7 lines. Skipping the lines would obviously be trivial. Just create the scanning part of the csvpath like:

```
$[8*][ ... ]
```

But let's say we don't trust that those lines will always be there and/or there always be a consistent number to skip. Or maybe we want to grab the info in those lines. Let's capture the date and run ID from the comment.

As well as the comments, say that the orders files will always:&#x20;

* Be more than 10 headers wide
* Have just 1 header row per file
* Have more than 10 data rows

And of course there will be requirements for the fields:&#x20;

* The product category must be correct
* Lines must have UPCs and SKUs
* Prices must be in the right format

If this were an actual order file in a real-world situation we could imaging collecting average selling prices, checking the vender's name, looking for duplicate lines, and more. All things csvpaths can do.

We'll step through the strategies for each of the bullets. Then see them together in one file with a trivial Python script that runs the csvpath. Then we'll switch to CsvPaths to create a more long-term management friendly version. That will show you the advantages of small modular csvpaths working together.

## Rule 1: Capture the Metadata

You can capture the metadata using regular expressions. Our comment lines are prefixed with a `#` character. We can use that and a regex to grab the values we want and put them in variables.

```
starts_with(#0, "#") -> @runid.notnone = regex( /Run ID: ([0-9]*)/, #0, 1 )
starts_with(#0, "#") -> @userid.notnone = regex( /User: ([a-zA-Z0-9]*)/, #0, 1 )
```

These two [match components ](https://github.com/dk107dk/csvpath/tree/main?tab=readme-ov-file#components)look at comment lines and capture data. The variable `@runid.notnone` will take the value of the regular expression only when the value is not `None`. None is the Python way of saying null. Because we have the `notnone` [qualifier](https://github.com/dk107dk/csvpath/blob/main/docs/qualifiers.md), it doesn't matter if this match component is activated for every line in the file. Regardless, we only pick up run IDs from comment lines and we never overwrite a good run ID with a None. The same is true for the `@userid` variable.&#x20;

## Rule 2: Find the Headers

We know there is one header row. It comes after the top-matter. And we know we have >= 10 headers. That's easy to spot.

```
skip( lt(count_headers_in_line(), 9) )
gt(count_headers_in_line(), 9) -> reset_headers()
```

These two match components handle those requirements. The first one skips a line if it doesn't have enough headers. Those are probably comment lines and we already took care of the comments. This is an illustration of how order matters in csvpath. Match components are activated from left to right, top to bottom. What I do in match component A may affect match component B. Or, in this case, we're just skipping B.&#x20;

When we see the number of line values jump to 10 or more we can safely assume we hit the header row and act accordingly.

```
@header_change = mismatch("signed")
gt( @header_change, 9) ->
      reset_headers(
        print("Resetting headers to: $.csvpath.headers."))

print.onchange(
    "Number of headers changed by $.variables.header_change..",
        print("See line $.csvpath.line_number.", skip())) ]
```

The three match components here:&#x20;

* Create a header\_change variable with the difference in the number of line values vs. headers expected. The mismatch function gets this count. We pass it "signed" so that it will give us a negative or positive number, not just the absolute difference.&#x20;
* If @header\_change is more than 9, we do reset\_headers(). Resetting headers changes the header row to the current row and sets the expectation for the values that will be found in subsiquent lines. We have reset\_headers() activate print() to give a visual output of what the csvpath is doing.&#x20;
* We then do another print() to provide more information. In both print()s we use references to include metadata about the headers and the line number where we made the change.

## Rule 3: Product Category

Next we'll check if the product category is correct. This is a pretty straightforward rule.

```
not( in( #category, "OFFICE|COMPUTING|FURNITURE|PRINT|FOOD|OTHER" ) ) ->
        print( "Bad category $.headers.category at line $.csvpath.count_lines ", fail()) ]
```

Following the same pattern, we are going to identify a problem row and print a validation message. The in() function looks at the value of the #category header and checks if it is in a delimited string. We could also ask in() to check against one or more other match components. Or, we could even use a reference to point in() towards a list of values created by a different csvpath. But for now we're keeping it simple with the delimited list.

Notice that we asked print() to activate a fail() function. fail() sets the is\_valid property of the csvpath to False. We are saying that the CSV file is invalid. If needed, we could use this information programmatically, in print messages, or take action in other match components using the failed() or valid() functions.

## Rule 4: Price Format

Moving right along, the next rule is that prices must exist and be in the correct format.

```
not( exact( end(), /\$?(\d*\.\d{0,2})/ ) ) ->
       print("Bad price $.headers.'a price' at line  $.csvpath.count_lines", fail()) ]
```

Again we use the same rule pattern. This time we use regular expressions again to check that a price:

* Must have a price value in the last header
* May but doesn't have to start with a $
* Must be numbers
* May have a decimal point
* Must have at most two numbers byond the decimal point

The new thing here is end(). The end() function is a pointer to the last column. If we're not certain what the last column name or index is we can use end() to refer to it. Our options are:&#x20;

* Use a name like #"a price"
* Use an index like #14
* Use end(), possibly with an offset

In this case, let's say we know price is always the last column.&#x20;

## Rule 5: UPCs and SKUs

Retailers, distributors, and manufacturers use Universal Product Codes to identify products. Retailers use Stock Keeping Units to identify products in inventory. Both are very important numbers to the business. If they were missing the orders file would be for sure invalid.

```
not( #SKU ) -> print("No SKU at line $.csvpath.count_lines", fail())
not( #UPC ) -> print("No UPC at line $.csvpath.count_lines", fail())
```

&#x20;These two match components should start to look familar. We're testing the #SKU and #UPC headers to see if they have data. If not, we complain and fail the file. Simple!

## Rule 6: Total Expected Lines

We are expecting a file that is greater than 10 lines. That gives room for the comments at the top and at least a one or two orders. If we don't see at least 10 lines we want to fail the file.

```
below(total_lines(), 10)
last.onmatch() ->
      print("File has too few lines: $.csvpath.count_lines.
      Contact $orders.variables.userid about this batch:
      $orders.variables.runid at $.csvpath.file_name.", fail())

```

We could do this a few ways. This is one reasonable approach. The first match component, below(), matches when a file has fewer than 10 lines. The second line activates print() on the last line of the file, but only if the line matches. Since a short line will match, we will see the printed statement.

As I said, there are other ways to handle this. And some may be more robust or have a better operational impact. For example, if our orders files were hundreds of megabytes and the rule was that that the line count had to be between 10 and 1 million, we might want to fail the file and stop processing earlier in the csvpath since  on line 10 we know if this rule passes. &#x20;

