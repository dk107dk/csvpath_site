---
description: >-
  CsvPath Language examples of using math functions in processing CSV/Excel
  files
---

# Math

{% hint style="warning" %}
## Download FlightPath Data from [Microsoft](https://apps.microsoft.com/detail/9P9PBPKZ4JDF) or [Apple](https://apps.apple.com/us/app/flightpath-data/id6745823097) or [Github](https://github.com/dk107dk/flightpath)
{% endhint %}

These examples focus on percents and summing. Most of the math functions are\
easy enough to understand from their names.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-08-26 at 12.02.40 PM.png" alt=""><figcaption></figcaption></figure>

```clike
~
  sum() produces a value and also maintains a variable. You can add a name
  qualifier to enable the use of multiple sum()s or just for clarity.

  id: hello world
  test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~

$[1*][

  @r = random(1, 5)
  @d = divide( sum.autos_moved(#2), @r )
  @i = int( @d )
  @rr = round( @d, 2 )

  print("Line $.csvpath.line_number: divide $.variables.autos_moved by $.variables.r to get $.variables.d and cast to integer $.variables.i; alternatively rounded value $.variables.rr")
]

---- CSVPATH ----

~
  Subtract is similar to add, multiply, and divide, but it has the additional
  ability to negate a value. (This example uses the alias minus())

  id: minus and subtract
  validation-mode: raise, print, stop
  test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~
$[1-2][
	@i = random(1,3)
         @minus_i = minus(@i)
	@r = subtract(@i, @minus_i)
	print("$.variables.i subtract $.variables.minus_i = $.variables.r")
]

```

```clike
~
  This csvpath shows the min() and max() functions' potential to mirror the
  increase and decrease qualfiers. Look in the Variables tab to see the results.

  Notice that increase and decrease will do a lexical comparison if you don't
  pass them numbers. min() and max() convert to numbers, but plain headers
  are always strings until you do something with them.

  id: min-max
  test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~
$[1*][
	@m1 = max(#"Automobile Volume")

	@m2.increase = int(#"Automobile Volume")

	@m3 = min(#"Automobile Volume")

	@m4.decrease = int(#"Automobile Volume")

  last() ->
    print("
    m1: $.variables.m1
    m2: $.variables.m2
    m3: $.variables.m3
    m4: $.variables.m4
   ")
]

---- CSVPATH ----

~
  Here we have the running median and the running average. The end result in variables @a and
  @m are for the full list of numbers. However, @a and @m are available at each line as the
  average and median of the lines scanned to that point.

  id: ave and median
  validation-mode: print, stop
  test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~
$[1*][
     @a = average(#"Automobile Volume")
     @m = median(#"Automobile Volume")

     last() ->
     print("Final average: $.variables.a
Final median: $.variables.m
See variables for running values.
")]

---- CSVPATH ----

~
   This csvpath checks if the % unique values is below 90% after at least 20% of years
   have been checked.

   id: percent unique
   validation-mode: raise, print, stop
   test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~
$[1*][
   @reviewed = percent("scan")
   @uniques = percent_unique.units(#"Automobile Volume")

   below( @reviewed, .20 ) -> skip()
   below( @uniques, 90 ) -> print("Line $.csvpath.line_number looks wrong: $.variables.uniques")
]
```

