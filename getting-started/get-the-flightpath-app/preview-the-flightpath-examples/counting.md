---
description: CsvPath Language examples of counting CSV data
---

# Counting

{% hint style="warning" %}
## Download FlightPath Data from [Microsoft](https://apps.microsoft.com/detail/9P9PBPKZ4JDF) or [Apple](https://apps.apple.com/us/app/flightpath-data/id6745823097) or [Github](https://github.com/dk107dk/flightpath)
{% endhint %}

These examples show different ways to count lines and data.

There are a number of ways to do similar counts that have separate purposes but which overlap. For example:

* increment() adds 1 each N times a match component evaluates to True
* counter() adds N each time a match component evaluates to True
* every() adds 1 every N-times a value is seen, matching or not

Likewise, summing offers options:

* sum() keeps a running count of values in a header
* count() keeps a count of matches and, like every(), can also count match components it contains
* subtotal() tracks the running sum of a header for each value in another header
* tally() tracks counts of the values seen in headers or combinations of headers

<figure><img src="../../../.gitbook/assets/Screenshot 2025-08-26 at 11.49.46 AM.png" alt=""><figcaption></figcaption></figure>

```clike

~
  This csvpath tracks the number of electricians. See the Variables tab for the
  results.

  Using increment() and mod() we can see that there are five electricians, and that
  there are two pairs with one electrician remaining. The mod() function will
  trigger errors until it has the values it needs for its calculation. But for this
  example we'll use validation-mode to make sure we ignore the complaints.

  From count() we can see that as well as those five electricians there are another 12
  trades persons who are not electricians.

  id: electricians
  test-data: examples/counting/projects.csv
  validation-mode: no-raise, no-print, no-stop
~

$[*][

     #trade == "Electrician"

     count.electricians(#trade == "Electrician")

     increment.nocontrib.half(#trade == "Electrician", 2)

     @half_remainder = mod(@half, 2)

     last.nocontrib() -> print("See the Variables tab")
]


---- CSVPATH ----

~
  This csvpath uses a decimal counter value to create a score for a
  developer based on how many projects they have.

  It also uses increment() to create a scaled impact metric based on
  a count of developer projects.

   id: developers
  test-data: examples/counting/projects.csv
~

$[1*][

     #developer == "The Druker Company LTD" -> counter.influence(6.35)

     increment.nocontrib.impact_scale(#developer == "The Druker Company LTD", 3)

     gte.nocontrib(@influence, 50) -> @msg = "Druker has influence: "
     lt.nocontrib(@influence, 50) -> @msg = "Druker has little influence: "

     last.nocontrib() -> @influence = round(@influence, 2)
     last.nocontrib() -> print("$.variables.msg $.variables.influence")

]

---- CSVPATH ----

~
  tally(), every(), and count() create the same counts in variables. However, they
  each have their own different capabilities.

   - count(): Counts line matches (the union of all match components) and individual
              match component matches. count() produces values but doesn't contribute
              to determining matches.
   - every(): Counts values, creates a scaled count variable, and matches if its
              modulus is 0
   - tally(): counts as a side-effect. tally() can count multiple header values as a
              join by passing multiple header arguments.

  tally() has no impact on matching and produces only the default value -- it
  is a complete side-effect. count() has no impact on matching, but produces its
  current count as its value. every() both produces a value, the scaled count,
  and votes on matching based on the remainder. You can remove every() as a factor in
  matching by adding the .nocontrib qualifier.

  id: counts
  test-data: examples/counting/projects.csv
~
$[1*][
     #general_contractor_name == "Suffolk Construction Company"

     ~ to limit the matched lines to every 3rd Suffolk project remove the .nocontrib qualifier ~
     every.nocontrib.e(#general_contractor_name, 3)

     tally.t(#general_contractor_name)

     count.c(#general_contractor_name)

     last.nocontrib() -> print("See variables tab for summaries")
]

```

```clike
~
 This csvpath shows the difference between tally() and subtotal(). 

 Tally counts the number of times a value is seen in a header or combination of headers.

 Subtotal keeps a running sum of values of one header for each value of another.

 To better understand the difference and usage, check out the Variables tab.

 Also, notice two things in the print() statement:

   - We can add the tracking value to the variable to get the specific tally or subtotal 
   - After the line number reference we use two periods, rather than just one

 The two points are related. A reference (pointers starting with $) has 
 four parts separated by three bullets. When we use references in print statements 
 the reference is local so we drop the first part of the reference, leaving the $. 
 notation. Typically we don't use a tracking value name in print() either, so we don't
 have the third period. However, if we want to put a period after a reference, 
 grammatically, when there is no tracking value name we need to escape the period. We 
 do that by doubling up with two periods.

 id: tally and subtotal
 test-data: examples/counting/projects.csv
~

$[1*][ 

	tally.projects_per(#agency)
	subtotal.worker_hours(#agency, #13)

	print("Line: $.csvpath.line_number.. BPDA projects: $.variables.projects_per_agency.BPDA")
]

```

