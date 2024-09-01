---
description: Super simple rules to demonstrate how validation works
---

# Your First Validation

As you saw in the Quickstart, CsvPath is easy to set up. But what value does it add?

The cool part, CsvPath's best value-add, is automated data quality checks for CSV files. Let's take a step in that direction by making the Quickstart files into something a little more realistic.

Our mission is to write a three-rule csvpath that can keep some simple problems getting loaded into our data management systems. The rules are:

* The CSV files we validate cannot have blanks; every header must have data
* The files' `lastname` header cannot have values greater than 30 characters
* The first header must be `firstname`

Our strategy is to collect any lines that break these rules. The validity of the file as a whole will depend on there being no failing lines.

<figure><img src="https://gitbookio.github.io/onboarding-template-images/publish-hero.png" alt=""><figcaption></figcaption></figure>

Open getting\_started.py (or whatever you named your Quickstart script). Paste this rule into the CsvPath instance's parse method after the scanning part. The scanning part of a csvpath looks like this: `[1*][`

`~ Apply three rules to check if a CSV file meets expectations ~`

Your file should now look something like:&#x20;

<figure><img src="../.gitbook/assets/three-rules-1.png" alt="" width="375"><figcaption></figcaption></figure>

Csvpaths can include line breaks, so you can format your csvpath any way that works for you.

What did we just do? We added a comment saying what our csvpath will do. That's all. Comments are completely optional, but they are useful. Let's continue.

## Rule one: no blanks

Our csvpath's first rule is that valid files have data under every header. CsvPath looks at the 0th line to determine the files headers. Of course, some files don't include headers. We'll see how to handle that later.

Add this line below the comment. Make it replace the `yes()` function:

```clike
not(all(header()))        
```

What does this statement do?&#x20;

As we iterate through the CSV file line by line, the `all()` looks at values and returns `True` if all of them have data. We pass `all()` a `header()` function to direct it to look in all the headers. We want to collect the offenders so we use `not()` to match any line that has any blanks.

## Rule two: no long lastnames

```clike
above(length(#lastname), 30)
```

This line uses functions to check a particular header's length. We're saying that values under the `lastname` header must be less than 30 characters long. Csvpaths use `#` to indicate a header.

No wait! There's a better simpler way. There seems to always be a better, simpler way with csvpaths, if you look for it. Swap out the line above for:

```
too_long(#lastname, 30)
```

That's much better!

