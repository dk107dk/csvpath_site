---
description: CsvPath Language examples for managing CSV/Excel file headers
---

# Headers

{% hint style="warning" %}
## Download FlightPath Data from [Microsoft](https://apps.microsoft.com/detail/9P9PBPKZ4JDF) or [Apple](https://apps.apple.com/us/app/flightpath-data/id6745823097) or [Github](https://github.com/dk107dk/flightpath)
{% endhint %}

## Using headers

Headers are the names of values in a CSV or Excel file. In a delimited file, any given line may not have values for the headers. And headers can change or be found at any point in a delimited file.

CsvPath Framework has many functions to help you work with headers. Most of the functions are oriented towards creating validation rules. Some of the header functions are quite unique. For example, in CsvPath Framework, you can reset the headers to the values of the current line at any time.

These examples will help you start exploring the headers functions so you can start crafting your own rules.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-08-26 at 11.58.18 AM.png" alt=""><figcaption></figcaption></figure>

```clike

---- CSVPATH ----

~
   The collect() function selects headers to collect values from when lines match.

   In this csvpath we are collecting three header values from two lines. Data from the
   matched lines is visible in the Matches tab. We'll also print to the Printouts tab
   just to make the results extra visible.

   test-data:examples/headers/projects.csv
   id: collect
~
$[*][

   #2 == "60 Kilmarnock Street"

   collect(#agency, #project_address, #period_ending)

   print_line.onmatch()
]


---- CSVPATH ----

~
   This csvpath updates the "compliance_project_name" header when it sees a certain value.
   Because we used the nocontrib qualifier the csvpath still returns all lines even though
   we are selecting a subset.

   id: replacing

   test-data:examples/headers/projects.csv
~

$[*][
	#compliance_project_name.nocontrib == "350 Boylston Street" ->
	replace(#compliance_project_name, "New Co. Build")

      last() -> print("See Matches tab for replacements")
]


---- CSVPATH ----

~
   This csvpath updates the test file data to have a processing date at the 0th header
   and a "modified by" header at the end of the line.

   id: insert and append

   test-data:examples/headers/projects.csv
~
$[*][

	insert( 0, "processing date", now() )
         append( "modified by", "CsvPath", yes() )

	last.nocontrib() -> print("See the Matches tab for the new column at the end of every line")
]

```

```clike

---- CSVPATH ----

~
   When used without arguments, all() returns True (it matches) when all headers 
   have values. 

   all()'s opposite is the missing() function. In this example we are looking for 
   any lines where a header has no value. We could use missing(), but to make 
   a more interesting example, we are using return-mode to return only lines that
   do not match.
   
   On the last line we print a tally of lines and matches. Notice that we add a 
   nocontrib qualifier to last(). nocontrib means that the match component with 
   that qualifier does not contribute to matching. If we didn't add nocontrib the
   last() would only match with the last line. Since we are interested in all(), 
   not last(), we use nocontrib to neutralize last().

   return-mode:no-matches
   id: missing example
   test-data:examples/headers/projects.csv
~

$[*][ 

	all()

	last.nocontrib() -> 
               print("Lines: $.csvpath.line_number, Matches: $.csvpath.count_matches")
]


---- CSVPATH ----

~
   In some cases you may want to reset headers. This often happens when there are prolog lines at the 
   top of a file or if multiple datasets are joined in one file.

   When that happens you may do a reset and then need to check that the new headers are what you expect.

   This csvpath shows how to do the check on the new set of headers.

   id: reset headers
   test-data:examples/headers/projects_with_reset.csv
~
$[1*][ 

    line_number() == 18 -> reset_headers(skip())

    header_names_mismatch.u("agency|neighborhood|project|outcome")

    print(
"Line: $.csvpath.line_number:
present: $.variables.u_present
misordered: $.variables.u_misordered
unmatched: $.variables.u_unmatched
duplicated: $.variables.u_duplicated
")

]
```

```clike
~
   One way to check a header's name
   id: header name
   test-data: examples/headers/projects.csv
~
$[1*][

    @name = header_name(1)
	@name == "compliance_project_name" -> print("Name is correct!")

]

---- CSVPATH ----

~
   Checking a header's position
   id: header name
   test-data: examples/headers/projects.csv
~
$[*][

    header_name("compliance_project_name") == 1 -> print("Position is correct!")
]

---- CSVPATH ----

~
  We can check if a header is what we expect using the header_name() function
  by passing the expected name as a second argument. The result is true or false.

  To add to the example, if we wanted to trigger an action based on the result
  of header_name() we could use a when/do expression based on one of two things:
    - A variable holding the value of header_name()
    - using header_name() in the when/do expression directly

  While you wouldn't typically use a variable in such a simple case, if you did
  you would need to remember that a variable standing by itself is an existance
  test. That means a variable with the value False is still True in the sense
  that it exists. To make the boolean value of the variable be used as its match
  vote you have to add the asbool qualifier.

  test-data: examples/headers/projects.csv
~
$[*][

    print("
Line: $.csvpath.line_number")

    @name = header_name(1, "compliance_project_name")
    @name.asbool -> print("    Name variable is correct: $.variables.name")

    @notname = header_name(1, "Compliance Project Name")
    not( @notname.asbool ) -> print("    Not name variable is also correct: $.variables.notname")

    header_name(1, "compliance_project_name") -> print("    Correct, no variable involved")
    not( header_name(1, "Compliance Project Name") ) -> print("    Also correct, still no variable involved")
]

---- CSVPATH ----

~
  The end() function returns the value of the last header. If you pass it an int N it will
  return the value of the header at the index: count_headers_in_line() - 1 - N. (The minus 1
  is because a count of the headers is 1-based; whereas, the index of a header is 0-based).

  To make the example a bit more interesting, we add the onchange qualifier to the variable
  assignment. That makes this variable assignment contribute a vote to matching lines. The
  onchange qualifier's main function is to limit an action to when it sees new information.

  Because we put onchange on the variable the Matches tab shows 9 lines. We could alternatively
  have put onchange on the print() function so we print only when the data changes, but still
  match every line.

  id: last column
  test-data: examples/headers/projects.csv
~

$[1*][
    @last_header_value.onchange = end(6)

    print.onmatch("$.variables.last_header_value")
]
```
