# Tallying

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
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
