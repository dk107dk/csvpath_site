# Track values

```
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
```
