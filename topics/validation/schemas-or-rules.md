# Schemas Or Rules?

The data quality tools we use, including languages like Python, validate according to schemas and/or rules. Here are some examples of each:

<figure><img src="../../.gitbook/assets/schemas and rules.png" alt="" width="563"><figcaption><p>CsvPath is placed kind of randomly on these lists. Obviously it should go at the top. :)</p></figcaption></figure>

Both types of validation are important and useful. Many of these tools do some of both. For example, you can use XPath in XSD to achieve some of what you can achieve with Schematron. Likewise, SQL provides DDL for defining structure and can easily write rules in DML (a.k.a. just plain SQL) to validate beyond just the entities and relationships.&#x20;

CsvPath provides both structural and rules-based validation. This is not a far reach, given CSV and Excel's limited capability for structural modeling. Regardless, both approaches are quite helpful. This page looks at structural validation in CsvPath, mainly. There is plenty of rules-based validation on basically every other page!

An entity model in CsvPath is a line, as defined by the `line()` function. There can be multiple lines per csvpath. This is particularly important for Excel, where people often have ancillary boxes of data sitting beside larger data sets. &#x20;

```xquery
$[*][
  line.person( 
      string.notnone(#firstname), 
      string.notnone(#lastname), 
      wildcard()
   ) 
]
```

This csvpath defines a valid line — an entity, if you like — as being a `firstname` field in header 0 and a `lastname` field in header 1, with any or no additional headers unspecified. We're giving it the name `person`, though that name doesn't add any meaning to the csvpath other than as documentation. The wildcard is not optional, because we're dealing with potentially unexpected data. We can add a specific number of possible headers and/or use the single column type `blank()`, with or without a header name. And of course we can put the `wildcard()` at the front or between headers, as needed.

All-in-all, the `person` definition using `line()` is equivalent, though not identical, to this DDL:

<pre class="language-sql"><code class="lang-sql"><strong>table person (
</strong>    firstname varchar not null,
    lastname varchar not null
)
</code></pre>

We can add some obvious specificity to the person model like this:&#x20;

```xquery
$[*][
  line.person( 
      string.notnone(#firstname, 25, 1), 
      blank(#middlename),
      string.notnone(#lastname, 35, 2), 
      wildcard(4)
   ) 
]
```

&#x20;The additional information we added is:

* That we expect certain lengths. For the `firstname`, let's pick an arbitrary `25` chars as the maximum and `1` char, for an initial, as the minimum. Likewise, for the `lastname`, `35` and `2`, on the assumption there are virtually no single letter family names.
* That there is a `middlename` header that we either don't know anything about or don't care to specify
* And that there are four additional headers that we are ignoring after the first three we declared.

In SQL this would be something like:&#x20;

```sql
table person (
    firstname varchar(25) not null,
    middlename varchar,
    lastname varchar(35) not null
    field_one varchar,
    field_two varchar, 
    field_three varchar,
    field_four varchar
)
```

Here there are some noticeable differences.  First off, SQL doesn't do wildcard columns, and rightly so! So we'll remove those. Second, there is no way to declare a min length in DDL. The third thing is subtle: we are making negative space. Given the CsvPath written so far, we can imagine there is another entity that we're not yet calling out.&#x20;

But first, let's update that SQL:

```sql
table person (
    firstname varchar(25) not null,
    middlename varchar,
    lastname varchar(35) not null
);
select * from person where len(firstname) == 0 or len(lastname) < 2; 
```

This gets us our first rule in the SQL world. (You can substitute in the length function of your SQL implementation of choice). On the CsvPath side, let's make our csvpath do some more interesting things:

```xquery
$[*][
   line.distinct.person( 
       string.notnone(#firstname, 25, 1), 
       blank(#middlename),
       string.notnone(#lastname, 35, 2), 
       wildcard(4)
   ) 
   
   line.address(
       wildcard(3),
       string.notnone(#street),
       string.notnone(#city),
       string.notnone(#state),
       integer.notnone(#zip)
   )
]
```

There are two things to notice. The `distinct` qualifier on the `person` `line()`. This requires that each combination of `firstname` and `lastname` is unique. Second, we now have two `line()`s. The second, address, neatly fits to the right of the name headers. That doesn't mean we are insisting that a `person` and an `address` will necessarily cohabitate a single file line. But that does look like the plan.

Since we're deviating from what SQL supports, let's specify a simple CSV.&#x20;

```csv
firstname,middlename,lastname,street,city,state,zip,height
Jimmy,C.,Cat,23 Main St.,Beverly,MA,01010,5.11
Anne,,Rat,9 High St.,Salem,MA,01001,6
```

A.k.a

| firstname | middlename | lastname | street      | city    | state | zip   | height |
| --------- | ---------- | -------- | ----------- | ------- | ----- | ----- | ------ |
| Jimmy     | C.         | Cat      | 23 Main St. | Beverly | MA    | 01010 | 5.11   |
| Anne      |            | Rat      | 9 High St.  | Salem   | MA    | 01001 | 6      |

And lets make a couple minor additions to our schema to show more capabilities.

```xquery
$[*][
   line.distinct.person( 
       string.notnone(#firstname, 25, 1), 
       blank(#middlename),
       string.notnone(#lastname, 35, 2), 
       wildcard(4)
   ) 
   
   line.address(
       wildcard(3),
       string.notnone(#street),
       string.notnone(#city),
       string.notnone(#state),
       integer.notnone(#zip)
   )
   
   line.height(
       wildcard(),
       decimal.notnone.strict("height",7.5)
   )
]
```

We added another `line()` group that clearly lives in the last header position. It has a max value and cannot be `None`.&#x20;

Our decimal matches on a signed number in standard decimal notation that would be a `float` in Python.  E.g. `5.95` or `98.6.` We gave it the `strict` qualifier. `strict` on a decimal requires the number to have a `.` character. With `strict` the number `1` would not only fail to match, it would also throw an exception, which depending on the run's configuration might stop the run cold. This behavior is because `1` is not the same as `1.0` in a stringified data format. By the same token, adding the `weak` qualifier will allow a `.`-less number to match as a decimal. I.e., with `weak`, `1` is considered as much a decimal as `1.0`. And, finally, if we want numbers that cannot have decimal points ever, we use the `integer` type.

Three quick last things, but this is by no means the end of the topic!  Here's another look:&#x20;

```xquery

$[*][
   line.distinct.person( 
       string.given_name.notnone(#0, 25, 1), 
       blank(#middlename),
       string.family_name.notnone(#2, 35, 2), 
       wildcard(4)
   ) 
   
   line.address(
       wildcard(3),
       string.notnone(#street),
       string.notnone(#city),
       string.notnone(#state),
       integer.post_code.notnone(#7)
   )
   
   line.height(
       wildcard(),
       decimal.notnone.strict(#height,7.5)
   )
   
   count_headers_in_line() == 8
   count_headers() == 8
   in(#state, "MA|CT|RI|ME|VT|NH")
   in(#zip, $zips.csvpaths.zipcodes)
]
```

Here we're adding three things:

* We're overlay-naming three of our entity fields: `#0`, `#2`, and `#7`. (We could have used the names of the headers just as well, but since we're giving our own names the indexes are cleaner). These names will show up in any built-in validation messages.
* With the first `in()` we are limiting the range of values in the `state` header
* And with the second `in()` we are referencing another table in the results of a different named-paths group run, `zips`, presumably on different data. _(If we wanted to do the same within our current named-paths group on our current data we could certainly do it, but that is less often needed and comes with the caveat that you would be typically be looking at just the results that streamed so far and only results, not the raw data; though there are ways around both issues, if really needed)._

So, basically, we have started to both creep into rules-based validation (the range limitation) and creep further towards SQL (the reference) at the same time. The header aliases are also SQLish, and in certain cases can be a real help in debugging tables of poorly labeled data. &#x20;

There you go, a few structural validation capabilities. Hopefully, seeing this, you are convinced that both structural schemas and validation rules are both helpful tools.&#x20;
