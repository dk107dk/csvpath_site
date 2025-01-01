# Validation Strategies

Rules-based validation is powerful. Its ability to make statements about data structure and data content and data-over-time goes well beyond schema formats like DDL or XSD. That power comes with its own challenges. One of which is how do you write rules in a way that is clear, consistent, and semantically informative. &#x20;

CsvPath validations can take different strategies. They can:&#x20;

* Validate correctness, returning all good lines
* Flag specific things that shouldn't happen, returning bad lines
* Report on simple rules that have little or no relationship to one another
* Render a single verdict based on all lines&#x20;

These are all good choices. In order to have coherent validations that are easy to act on, it is good to be intentional up front about the strategy or strategies you want to take. Here are some notes about each.

### Focus on gathering the good

The option to have CsvPath return valid lines works best if you want to use those lines in some way. For example, you might want to:&#x20;

* Create a new, different CSV
* Hold the results for reference by other csvpaths
* Push the data to another system&#x20;

CsvPath facilitates this pattern with the `next()`, `next_paths()`, and `next_by_line()` methods that let you step through the file line by line, and with the similar `collect()` methods that capture and return the matching lines all at once. The choice to write your rules to pick out valid lines or invalid ones depends on what you want to do with the data.

CsvPath is by default an AND system. _(We use upper case because it is commonly written that way to distinguish ∧, the logical conjunctive, from "and", the conjunction)_. That means all your match components are ANDed together to test if a line matches. If you say that a beautiful day has a blue sky, the sun is out, and the birds are singing, CsvPath can help validate that all of it is true.

CsvPath can also be a OR machine. That means it would match and return any line where any of a set of rules is true. The configuration to switch to OR is simple:&#x20;

```python
path = CsvPath()
path.OR = True
```

Exceptions are ORed. Declaring that it is not a beautiful day if the sun is not out, or if the birds are not singing, or if the sky is not blue is also easy do in CsvPath.&#x20;

It is important to be intentional about if you are ANDing or ORing because little things like qualifiers and assignments have different impacts. If you are making an assignment your need to use the `nocontrib` qualifier may be essential in AND but unnecessary in OR, or vice versa.&#x20;

To invoke Sesame Street, saying _one of these things is not like the others_ is not the same as saying one of _these things is not like at least one of the others_.&#x20;

### The right hand and the left hand&#x20;

Another approach to rule writing is to worry less about AND vs. OR and instead create some separation between your match components so they don't impact each other. This is a very natural approach. You can do it two ways:&#x20;

* Use when/do rules
* Separate rules into their own csvpaths

When/do rules look like:

```clike
function() -> function()
```

You can, of course, also use headers and variables in a do/when.&#x20;

This structure gives separation. It lets you think in ORs while working in AND. The main thing to remember is that your left-hand sides of do/when expressions either have to return `True` or you have to add the `nocontrib` qualifier to force the result on the left to be positive. In this approach, the positive returned by the `nocontrib` is essentially saying _ignore me_.

The right-hand side of your do/when expressions will be a side-effect. The main result of a match component is its `bool` match value, `True` or `False`. A side-effect is anything more it does. The most important side effect is to simply print the problem and its location in the file. That is a very effective way to do validation!  Other side effects might be declaring the file invalid using `fail()` or using `push()` to push a problem line number on a variable stack for later inspection.&#x20;

### Separate AND equal

The most clear-cut way to separate your match components is to move them into separate csvpaths. When you break down your validation rules into small groups of like rules or single rules you gain clarity and testability.  You lose nothing. If anything, it's easier to craft individual rules and run them together.&#x20;

CsvPaths makes runs with multiple csvpaths simple. [Another Example, Part 2](../../getting-started/another-example-part-2.md) shows several ways to do it. The closest approach to a single csvpath validation is to simply drop all your single-rule csvpaths into one file like this:&#x20;

```clike
~ name: rule one ~
$[*][ headers("firstname") ]

---- CSVPATH ----

~ name: rule two ~
$[*][ max_length(#firstname, 20) ]

```

These two rules are a good illustration. The first addresses the file as a whole. Does it have a "firstname" header?  The second rule speaks to each individual line. Is the value in the  `#firstname`  header less than  21 characters? The rules conflict, to some degree.&#x20;

The first rule says if there is such a header, all lines are wrong. That is only technically correct—the file as a whole is wrong, the lines are just following the structure they exist within. More importantly, the first rule could obscure the results of the second rule, which might only pick out a few of a large number of lines. Keeping these rules separate can help each be more effective.

If you use print() to communicate your validation results, using multiple csvpaths shows no difference from what you would see using a single csvpath.&#x20;

### What to keep?

We called out the question of keeping the good rows or the bad ones—or none. By default, CsvPath returns the rows your csvpath matches. However, if you set CsvPath's collect\_when\_not\_matched property to True it will return the unmatched lines. That may help, regardless of if you are thinking in ANDs or ORs. And it may not matter much if you're using do/when to print your validation results, or using CsvPath's `is_valid` property or the variables, or some other programmatic approach.&#x20;



These are all good options for straightforward considerations. If your validation use case is complex take a minute to think about the options up front. As your project grows, you'll be happy you did.

