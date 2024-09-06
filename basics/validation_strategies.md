# Validation Strategies

Rules-based validation is powerful. Its ability to make statements about data structure and data content and data-over-time goes well beyond schema formats like DDL or XSD. It does, however, bring its own challenges. One of which is how do you write rules in a way that is clear, consistent, and semantically informative. &#x20;

CsvPath validations can take different strategies. They can:&#x20;

* Focus on what good looks like, overall for the whole file and any file
* Address specific things that shouldn't happen
* Be broken down into steps that have no or little relationship to one another
* Collect the positive cases—what lines fit—or the negative cases or collect nothing and just indicate problems out of band and/or as a verdict at the end of a run&#x20;

These are all good choices. In order to have coherent validations that are easy to act on, it is good to be intentional up front about the strategy or strategies you want to take. Here are some notes about each.

### Focus on the good

Our first choice is the top strategy: focus on what constitutes a valid file. That approach fits very well with CsvPath. CsvPath is by default an AND system. (We use upper case because it is commonly written that way to distinguish ∧, the logical conjunctive from "and", the conjunction). That means all your match components are ANDed together to test if a line matches. If you say that a beautiful day has a blue sky, the sun is out, and the birds are singing, CsvPath can help validate that it is true.

While focusing on the positive aspects of your data may also be easier than thinking about the universe of exceptional cases, the bigger concern is that exceptions are ORed. Declaring that it is not a beautiful day if the sun is not out, or the birds are not singing, or the sky is not blue is a less of a fit with CsvPath. You can easily create those rules. But you will sometimes have to wrap functions and equalities in not()s and all your rules would need to be wrapped in one or(). Nothing says you can't do it. And it's not especially hard. But it isn't as good a fit.

### The right hand and the left hand&#x20;

Another approach to rule writing is to worry less about AND vs. OR and instead create some separation between your match components so that they less entangled with each other. This is a very natural approach. You can do it two ways:&#x20;

* Use when/do rules
* Separate rules into their own csvpaths

When/do rules look like:

```clike
function() -> function()
```

You can, of course, also use headers and variables in a do/when. This structure gives separation by letting you think in ORs while defining an AND. The main thing to remember is that your left-hand sides of do/when expressions either have to return True or you have to add the `nocontrib` qualifier to force the result on the left to be positive. In this approach, the positive returned by the `nocontrib` is essentially saying ignore me.

The right-hand side of your do/when expressions will be a side-effect. The main effect of a match component is its bool match value. A side-effect is anything more it does. The most important side effect is to simply print the problem and its location in the file. That is a very effective way to do validation!  Other side effects might be declaring the file invalid using `fail()` or using `push()` to push a problem line number on a variable stack for later inspection.&#x20;

### Separate AND equal

The most clear-cut way to separate your match components is to move them into separate csvpaths. When you break down your validation rules into small groups of like rules or single rules you gain clarity and testability.  You lose nothing. It's if anything easier to craft individual rules and run them together. CsvPaths makes it simple to set up. The best approach is to drop all your csvpaths in a single file like this:&#x20;

```clike
~ name: rule one ~
$[*][ headers("firstname") ]

---- CSVPATH ----

~ name: rule two ~
$[*][ max_length(#firstname, 20) ]

```

These two rules are a good illustration. The first addresses the file as a whole. Does it have a "firstname" header?  The second rule speaks to each individual line. Is the value in `#firstname` less than  21 characters? These two rules would conflict, to some degree. The first would say that all lines are wrong, which is only technically correct—the file as a whole is wrong, the lines are just following the structure they exist in. More importantly, the first rule would obscure the results of the second rule, which might only pick out a few of a large number of lines. Keeping these rules separate can help each be more effective.

If you use print() to communicate your validation results, there is no difference from what you would see using a single csvpath in a CsvPath instance. That said, using CsvPaths has the added benefit of capturing results, print lines, metadata, etc. that CsvPath on its own doesn't offer.

### What to keep?

A last consideration we called out above is whether we keep the good rows or the bad ones—or none. By default, CsvPath returns the rows your csvpath matches. However, if you set CsvPath's collect\_when\_not\_matched property to True it will return the unmatched lines. That may help, regardless of if you are thinking in ANDs or ORs. And it may not matter much if you're using do/when to print your validation results, or using CsvPath's `is_valid` property or the variables, or some other programmatic approach.&#x20;

All good options. If your validation use case is complex take a minute to think about the options up front.

